import pandas as pd
from catboost import CatBoostClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, roc_curve
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV
from sklearn.metrics import accuracy_score, balanced_accuracy_score, f1_score, precision_score, recall_score, matthews_corrcoef
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib import rcParams

# Load data
data = pd.read_csv("D:/Pred_LakeDrain_data_final.csv")
data = data.drop(columns=["NID"])

#During iterative training, variables with correlation coefficients greater than 0.5 
# with important variables are removed to avoid collinearity
#data = data.drop(columns=["slope","srad_ann","precip_ann"])
#data = data.drop(columns=["tsl_ann","t2m_sum","tsl_sum"])
#data = data.drop(columns=["yedoma","srad_max","t2m_max","tsl_max"])
#data = data.drop(columns=["precip_sum","srad_sum"])
#....
X = data.drop(columns=["Drain"])
correlation_matrix = X.corr()
print(correlation_matrix)
correlation_matrix.to_csv('D://correlation_matrix.csv')

'''
#Removing collinearity
from statsmodels.stats.outliers_influence import variance_inflation_factor

X = data.drop(columns=["Drain","content","extent","therokarst"])

vif_data = pd.DataFrame()
vif_data["feature"] = X.columns
vif_data["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]

print(vif_data)

from scipy.stats import spearmanr
correlation, p_value = spearmanr(data["t2m_ann"], data["extent"])
print("Spearman's Rank Correlation:", correlation)
print("P-value:", p_value)
'''


train_data, test_data = train_test_split(data, test_size=0.3, random_state=123)
categorical_features = ["content","yedoma","extent","therokarst"]
X_train = train_data.drop(columns=["Drain"])
y_train = train_data["Drain"]
X_test = test_data.drop(columns=["Drain"])
y_test = test_data["Drain"]

# param range
param_grid = {
    'iterations': [200, 500, 1000, 2000],
    'learning_rate': [0.01, 0.05, 0.1, 0.2],
    'depth': [3, 6, 8, 10],
    'l2_leaf_reg': [1, 3, 5, 10],
    'bagging_temperature': [0.0, 0.5, 1.0, 2.0],
    'random_strength': [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    'border_count': [32, 64, 128, 255],
    'min_data_in_leaf': [1, 10, 20, 50],
    'colsample_bylevel': [0.5,0.75,1],
    'subsample': [0.5,0.75,1],
    'early_stopping_rounds': [30, 50]
}


#initial model
model = CatBoostClassifier(loss_function='Logloss', eval_metric='AUC', cat_features=categorical_features, verbose=False)

#Randomized Search
random_search  = RandomizedSearchCV(model, param_distributions=param_grid, n_iter=100, scoring='roc_auc', cv=10, verbose=2, n_jobs=-1)
random_search.fit(train_data.drop('Drain', axis=1), train_data['Drain'])

print("Best Parameters:", random_search.best_params_)
best_params = random_search.best_params_
#model = random_search.best_estimator_

best_params = {'subsample': 1, 'random_strength': 0.6, 'min_data_in_leaf': 1, 'learning_rate': 0.05, 'l2_leaf_reg': 1, 'iterations': 1000, 'early_stopping_rounds': 30, 'depth': 10, 'colsample_bylevel': 1, 'border_count': 255, 'bagging_temperature': 1.0}
model = CatBoostClassifier(loss_function='Logloss', eval_metric='AUC', cat_features=categorical_features, verbose=False, **best_params)

#train model
model.fit(X_train, y_train, eval_set=(X_test, y_test))


y_score = model.predict_proba(X_test)[:, 1]
auc_score = roc_auc_score(y_test, y_score)
print("AUC Score:", auc_score)


predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
balanced_accuracy = balanced_accuracy_score(y_test, predictions)
f1 = f1_score(y_test, predictions)
precision = precision_score(y_test, predictions)
recall = recall_score(y_test, predictions)
mcc = matthews_corrcoef(y_test, predictions)

print("Accuracy:", accuracy)
print("Balanced Accuracy:", balanced_accuracy)
print("F1 Score:", f1)
print("Precision:", precision)
print("Recall:", recall)
print("MCC:", mcc)


#Fig.4A
rcParams['font.family'] = 'Arial'
rcParams['font.size'] = 11
# Receiver Operating Characteristic Curve
y_score = model.predict_proba(X_test)[:, 1]
fpr, tpr, _ = roc_curve(y_test, y_score)
roc_auc = auc(fpr, tpr)

plt.figure(figsize=(3, 3))
plt.plot(fpr, tpr, color='darkorange', lw=2, label='ROC curve (AUC = %0.2f)' % roc_auc)
plt.plot([0, 1], [0, 1], color='navy', linestyle='--', label='Random guess')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.0])
#plt.xlabel('False positive rate')
#plt.ylabel('True positive rate')
plt.legend(loc='lower right')
plt.savefig('ROC_curve.jpg', dpi=600, bbox_inches='tight')
plt.show()



#Fig.4B
# PR curve
precision, recall, _ = precision_recall_curve(y_test, y_score)
avg_precision = average_precision_score(y_test, y_score)

plt.figure(figsize=(3, 3))
plt.plot(recall, precision, color='darkorange', lw=2, label='PR curve (AP = %0.2f)' % avg_precision)
plt.plot([0, 1], [np.mean(y_test), np.mean(y_test)], color='navy', linestyle='--', label='Random guess')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.0])
#plt.xlabel('Recall (ability to find actual positives)')
#plt.ylabel('Precision (accuracy of positive predictions)')
plt.legend(loc='lower right')
plt.savefig('PR_curve.jpg', dpi=600, bbox_inches='tight')
plt.show()



import shap
from sklearn.inspection import permutation_importance

explainer = shap.TreeExplainer(model, feature_perturbation="tree_path_dependent")

# SHAP value
shap_values = explainer.shap_values(X_test)

# Permutation Importance
perm_importance = permutation_importance(model, X_test, y_test, n_repeats=30, random_state=0)

# normalized
normalized_shap_importance = np.abs(shap_values).mean(axis=0) / np.max(np.abs(shap_values).mean(axis=0))
normalized_perm_importance = perm_importance.importances_mean / np.max(perm_importance.importances_mean)

# ascending
feature_importance_df = pd.DataFrame({'Feature': X_train.columns, 'SHAP Importance': normalized_shap_importance, 'Perm Importance': normalized_perm_importance})
feature_importance_df = feature_importance_df.sort_values(by='SHAP Importance', ascending=True)

#Fig.4C
# plot feature importance
rcParams['font.family'] = 'Arial'
rcParams['font.size'] = 11
plt.figure(figsize=(5, 3))
plt.barh(feature_importance_df['Feature'], feature_importance_df['SHAP Importance'], color='skyblue', label='Shapley value')
plt.barh(feature_importance_df['Feature'], feature_importance_df['Perm Importance'], color='orange', alpha=0.7, label='Permutation importance')
#plt.xlabel('Normalized Importance')
#plt.ylabel('Feature')
#plt.title('Normalized Feature Importance')
plt.legend(loc='lower right')
plt.savefig('Importance.jpg', dpi=600, bbox_inches='tight')
plt.show()

#Fig.4D
feature_name = 't2m_slope'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]

plt.figure(figsize=(3, 3))
kde_plot = sns.kdeplot(X_test[feature_name], shap_values_feature, cmap='viridis', shade=True)

plt.xlabel('')
plt.xlim(-0.08, 0.22)
plt.ylim(-2.4, 2.4)

#plt.xlabel(feature_name)
#plt.ylabel('SHAP Value Density')
#plt.title('Dependency Plot with SHAP Value Density for '  + feature_name)
#colorbar = plt.colorbar(kde_plot.collections[0], label='Density of point distribution')

plt.savefig('t2m_slope.jpg', dpi=600, bbox_inches='tight')
plt.show()


#Fig.4E
feature_name = 't2m_ann'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]

plt.figure(figsize=(3, 3))
kde_plot = sns.kdeplot(X_test[feature_name] - 273.15, shap_values_feature, cmap='viridis', shade=True)

plt.xlabel('')
plt.xlim(-18, 3)
plt.ylim(-1.9, 2.8)

plt.savefig('t2m_ann.jpg', dpi=600, bbox_inches='tight')
plt.show()


#Fig.4F
feature_name = 'elevation'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]

plt.figure(figsize=(3, 3))
kde_plot = sns.kdeplot(X_test[feature_name], shap_values_feature, cmap='viridis', shade=True)

plt.xlabel('')
plt.xlim(-200, 1200)
plt.ylim(-2, 2.8)

plt.savefig('elevation.jpg', dpi=600, bbox_inches='tight')
plt.show()

#Fig.4G
feature_name = 'ATL'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]

plt.figure(figsize=(3, 3))
kde_plot = sns.kdeplot(X_test[feature_name], shap_values_feature, cmap='viridis', shade=True)

plt.xlabel('')
plt.xlim(0, 2.5)
plt.ylim(-1.2, 1.2)

plt.savefig('ATL.jpg', dpi=600, bbox_inches='tight')
plt.show()

#Fig.4H
feature_name = 'extent'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]
shap_df = pd.DataFrame({feature_name: X_test[feature_name], 'SHAP Value': shap_values_feature})

plt.figure(figsize=(3, 3))
sns.violinplot(x=feature_name, y='SHAP Value', data=shap_df, palette='viridis', inner='box')

plt.xlabel('')

plt.savefig('extent.jpg', dpi=600, bbox_inches='tight')
plt.show()


