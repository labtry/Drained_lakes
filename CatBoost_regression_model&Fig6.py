import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib import rcParams
from catboost import CatBoostRegressor
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error


# Load data
data = pd.read_csv("D:/PredNDVI_data_R4.csv")
data = data.drop(columns=["UID"])

categorical_features = ["ecoregion","extent","thermokarst","Flooded"]

X = data.drop(columns=["DL_NDVI","ecoregion","extent","thermokarst","Flooded"])
correlation_matrix = X.corr()
print(correlation_matrix)
correlation_matrix.to_csv('D://correlation_matrix4.csv')

#Removing multicollinearity
from statsmodels.stats.outliers_influence import variance_inflation_factor

vif_data = pd.DataFrame()
vif_data["feature"] = X.columns
vif_data["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
print(vif_data)


from scipy.stats import spearmanr
X = data.drop(columns=["DL_NDVI"])
spearman_corr_matrix, _ = spearmanr(X)
correlation_matrix = pd.DataFrame(spearman_corr_matrix, columns=X.columns, index=X.columns)

print(correlation_matrix)
correlation_matrix.to_csv('D://spearman_correlation_matrix.csv')

correlation, p_value = spearmanr(data["Flooded"], data["ecoregion"])
print("Spearman's Rank Correlation:", correlation)
print("P-value:", p_value)


#During iterative training, variables with correlation coefficients greater than 0.5 
# with important variables are removed to avoid covariance problems
#data = data.drop(columns=["slope","srad_ann","precip_ann"])
#data = data.drop(columns=["tsl_ann","t2m_sum","tsl_sum"])
#data = data.drop(columns=["yedoma","srad_max","t2m_max","tsl_max"])
#....


train_data, test_data = train_test_split(data, test_size=0.3, random_state=123)

X_train = train_data.drop(columns=["DL_NDVI"])
y_train = train_data["DL_NDVI"]
X_test = test_data.drop(columns=["DL_NDVI"])
y_test = test_data["DL_NDVI"]

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
model = CatBoostRegressor(loss_function='RMSE', eval_metric='RMSE', cat_features=categorical_features, verbose=False)

#Randomized Search
random_search  = RandomizedSearchCV(model, param_distributions=param_grid, n_iter=100, scoring='neg_mean_squared_error', cv=3, verbose=2, n_jobs=-1)
random_search.fit(train_data.drop('DL_NDVI', axis=1), train_data['DL_NDVI'])

print("Best Parameters:", random_search.best_params_)
#best_params = random_search.best_params_
model = random_search.best_estimator_

best_params = {'subsample': 0.5, 'random_strength': 0.8, 'min_data_in_leaf': 10, 'learning_rate': 0.2, 'l2_leaf_reg': 1, 'iterations': 2000, 'early_stopping_rounds': 30, 'depth': 10, 'colsample_bylevel': 1, 'border_count': 128, 'bagging_temperature': 0.5}
#best_params = {'subsample': 1, 'random_strength': 0.6, 'min_data_in_leaf': 1, 'learning_rate': 0.05, 'l2_leaf_reg': 1, 'iterations': 1000, 'early_stopping_rounds': 30, 'depth': 10, 'colsample_bylevel': 1, 'border_count': 255, 'bagging_temperature': 1.0}
model = CatBoostRegressor(loss_function='RMSE', eval_metric='RMSE', cat_features=categorical_features, verbose=False, **best_params)

#train model
#model.fit(X_train, y_train)
model.fit(X_train, y_train, eval_set=(X_test, y_test))

y_pred = model.predict(X_test)



rmse = mean_squared_error(y_test, y_pred, squared=False)
Prmse = rmse*100/y_test.mean()
r2 = r2_score(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
bias = y_pred.mean() - y_test.mean()

# 输出结果
print(f"RMSE: {rmse:.2f}")
print(f"%RMSE: {Prmse:.1f}")
print(f"R2: {r2:.2f}")
print(f"MAE: {mae:.2f}")
print(f"Bias: {bias:.2f}")


plt.xlabel("Actual Values")
plt.ylabel("Predicted Values")
plt.title("Actual vs Predicted Values")




#Fig.6A
plt.figure(figsize=(3, 3))
hb = plt.hexbin(x=y_test, y=y_pred, gridsize=60, cmap='viridis', mincnt=1)
plt.plot([0, 1], [0, 1], color='r', linestyle='--')

plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.0])
#plt.xlabel('Observed NDVI')
#plt.ylabel('Predicted NDVI')
#cb = plt.colorbar(hb)
#cb.set_label('Density')
plt.xticks([0, 0.2, 0.4, 0.6, 0.8, 1.0], ['']*6)
plt.yticks([0, 0.2, 0.4, 0.6, 0.8, 1.0], ['']*6)

plt.savefig('Fig6A.jpg', dpi=600, bbox_inches='tight')
plt.show()



#Fig.6B
residuals = y_pred - y_test
plt.figure(figsize=(3, 3))
hb = plt.hexbin(x=y_pred, y=residuals, gridsize=60, cmap='viridis', mincnt=1)
plt.axhline(y=0, color='r', linestyle='--')
#plt.xlabel("Predicted NDVI")
#plt.ylabel("Residuals")
#cb = plt.colorbar(hb)
#cb.set_label('Density')
plt.xticks([0, 0.2, 0.4, 0.6, 0.8, 1.0], ['']*6)
plt.yticks([-0.6,-0.4,-0.2,0, 0.2, 0.4, 0.6], ['']*7)
plt.xlim([0.0, 1.0])
plt.ylim([-0.6, 0.6])

plt.savefig('Fig6B.jpg', dpi=600, bbox_inches='tight')
plt.show()

import shap
from sklearn.inspection import permutation_importance

explainer = shap.TreeExplainer(model, feature_perturbation="tree_path_dependent")

# SHAP value
shap_values = explainer.shap_values(X_test)

feature_importance = np.abs(shap_values).mean(axis=0)
feature_importance_df = pd.DataFrame({'Feature': X_train.columns, 'Importance': feature_importance})
feature_importance_df = feature_importance_df.sort_values(by='Importance', ascending=True)
print(feature_importance_df)
shap.summary_plot(shap_values, X_test,cmap=plt.get_cmap("YlGn"))

# Permutation Importance
perm_importance = permutation_importance(model, X_test, y_test, n_repeats=30, random_state=0)

# normalized
normalized_shap_importance = np.abs(shap_values).mean(axis=0) / np.max(np.abs(shap_values).mean(axis=0))
normalized_perm_importance = perm_importance.importances_mean / np.max(perm_importance.importances_mean)

# ascending
feature_importance_df = pd.DataFrame({'Feature': X_train.columns, 'SHAP Importance': normalized_shap_importance, 'Perm Importance': normalized_perm_importance})
feature_importance_df = feature_importance_df.sort_values(by='SHAP Importance', ascending=True)
#feature_importance_df = feature_importance_df.sort_values(by='Perm Importance', ascending=True)

#Fig.6C
# plot feature importance
rcParams['font.family'] = 'Arial'
rcParams['font.size'] = 11
plt.figure(figsize=(5, 3))
plt.barh(feature_importance_df['Feature'], feature_importance_df['SHAP Importance'], color='skyblue', label='Shapley value')
plt.barh(feature_importance_df['Feature'], feature_importance_df['Perm Importance'], color='orange', alpha=0.7, label='Permutation importance')
#plt.xlabel('Normalized Importance')
#plt.ylabel('Feature')
#plt.title('Normalized Feature Importance')
legend = plt.legend(loc='lower right', bbox_to_anchor=(0.99, 0.01), borderaxespad=0.0, prop={'size': 9})
plt.savefig('Importance.jpg', dpi=600, bbox_inches='tight')
plt.show()


#Fig.6D
feature_name = 't2m_sum'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]
plt.figure(figsize=(3, 3))
kde_plot = sns.kdeplot(X_test[feature_name] - 273.15, shap_values_feature, cmap='viridis', shade=True)
plt.xlabel('')
plt.xlim(2, 22)
plt.ylim(-0.12, 0.12)
plt.xticks([5, 10, 15, 20], ['']*4)
plt.yticks([-0.10,-0.05,0, 0.05, 0.1], ['']*5)
#plt.xlabel(feature_name)
#plt.ylabel('SHAP Value Density')
#plt.title('Dependency Plot with SHAP Value Density for '  + feature_name)
#colorbar = plt.colorbar(kde_plot.collections[0], label='Density of point distribution')
plt.savefig('t2m_sum_new.jpg', dpi=600, bbox_inches='tight')
plt.show()



#Fig.6E
feature_name = 't2m_slope'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]

plt.figure(figsize=(3, 3))
kde_plot = sns.kdeplot(X_test[feature_name], shap_values_feature, cmap='viridis', shade=True)

plt.xlabel('')
plt.xlim(-0.05, 0.22)
plt.ylim(-0.12, 0.12)
plt.xticks([-0.05, 0.00, 0.05, 0.10,0.15,0.20], ['']*6)
plt.yticks([-0.10,-0.05,0, 0.05, 0.1], ['']*5)
plt.savefig('t2m_slope_new.jpg', dpi=600, bbox_inches='tight')
plt.show()


#Fig.6F
feature_name = 'Flooded'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]
shap_df = pd.DataFrame({feature_name: X_test[feature_name], 'SHAP Value': shap_values_feature})

plt.figure(figsize=(3, 3))
sns.violinplot(x=feature_name, y='SHAP Value', data=shap_df, palette='viridis', inner='box')

plt.ylim(-0.13, 0.07)
plt.xticks([0,1], ['']*2)
plt.yticks([-0.10,-0.05,0, 0.05], ['']*4)
plt.xlabel('')
plt.ylabel('')
plt.savefig('Flooded_new.jpg', dpi=600, bbox_inches='tight')
plt.show()

#Fig.6G
feature_name = 'thermokarst'
feature_idx = X_test.columns.get_loc(feature_name)
shap_values_feature = shap_values[:, feature_idx]
shap_df = pd.DataFrame({feature_name: X_test[feature_name], 'SHAP Value': shap_values_feature})

plt.figure(figsize=(3, 3))
sns.violinplot(x=feature_name, y='SHAP Value', data=shap_df, palette='viridis', inner='box')

plt.ylim(-0.13, 0.07)
plt.xticks([0,1,2], ['']*3)
plt.yticks([-0.10,-0.05,0, 0.05], ['']*4)
plt.xlabel('')
plt.ylabel('')
plt.savefig('thermokarst_new.jpg', dpi=600, bbox_inches='tight')
plt.show()




from sklearn.model_selection import learning_curve

def plot_learning_curve(estimator, title, X, y, ylim=None, cv=None, n_jobs=-1, train_sizes=np.linspace(0.1, 1.0, 5)):
    plt.figure(figsize=(8, 6))
    plt.title(title)
    if ylim is not None:
        plt.ylim(*ylim)
    plt.xlabel("Training examples")
    plt.ylabel("Score")
    train_sizes, train_scores, test_scores = learning_curve(
        estimator, X, y, cv=cv, n_jobs=n_jobs, train_sizes=train_sizes)
    
    train_scores_mean = np.mean(train_scores, axis=1)
    train_scores_std = np.std(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)
    test_scores_std = np.std(test_scores, axis=1)
    
    plt.grid()
    
    plt.fill_between(train_sizes, train_scores_mean - train_scores_std,
                     train_scores_mean + train_scores_std, alpha=0.1,
                     color="r")
    plt.fill_between(train_sizes, test_scores_mean - test_scores_std,
                     test_scores_mean + test_scores_std, alpha=0.1, color="g")
    plt.plot(train_sizes, train_scores_mean, 'o-', color="r",
             label="Training score")
    plt.plot(train_sizes, test_scores_mean, 'o-', color="g",
             label="Cross-validation score")
    
    plt.legend(loc="best")
    return plt

plot_learning_curve(model, "Learning Curve", X_train, y_train, cv=5)
plt.savefig('Learning_Curve.jpg', dpi=600, bbox_inches='tight')
plt.show()
