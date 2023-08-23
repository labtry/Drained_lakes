var poi = ee.FeatureCollection("users/NC_R2/GEE_Get_Climate_poi");

var annual = ee.ImageCollection("ECMWF/ERA5_LAND/MONTHLY_AGGR")
                .filter(ee.Filter.calendarRange(2000,2020,'year'))
                .filter(ee.Filter.calendarRange(1,12,'month'))
                .select("temperature_2m","soil_temperature_level_1","total_precipitation_sum","snowmelt_sum","surface_solar_radiation_downwards_sum","u_component_of_wind_10m","v_component_of_wind_10m");

var computeYearlyMean = function(year) {
  var yearStart = ee.Date.fromYMD(year, 1, 1);
  var yearEnd = ee.Date.fromYMD(year, 12, 31);
  var yearlyMean = annual.filterDate(yearStart, yearEnd).mean();
  yearlyMean = yearlyMean.rename("t2m_ann","tsl_ann","precip_ann","snowmelt_ann","srad_ann","u_ann","v_ann");
  var uComponent = yearlyMean.select('u_ann');
  var vComponent = yearlyMean.select('v_ann');
  var windSpeed = uComponent.hypot(vComponent).rename("windsp_ann");
  yearlyMean = yearlyMean.select("t2m_ann","tsl_ann","precip_ann","snowmelt_ann","srad_ann").addBands(windSpeed);
  return yearlyMean.set('year', year);
};
var years = ee.List.sequence(2000, 2020);
var era5LandYearlyMean = ee.ImageCollection.fromImages(years.map(computeYearlyMean));
print(era5LandYearlyMean);


var extractBandsByYear = function(year) {
  var feature = poi.filter(ee.Filter.eq('Get_Year', year));
  var img = era5LandYearlyMean.filter(ee.Filter.eq('year', year)).first();
  var result = img.reduceRegions({
    reducer: ee.Reducer.mean(),
    collection: feature,
    scale: 1000
  });
  return result;
};

var allResults = ee.FeatureCollection([]);

for (var year = 2000; year <= 2020; year++) {
  var result = extractBandsByYear(year);
  allResults = allResults.merge(result);
}

Export.table.toDrive({
  collection: allResults,
  folder: '',
  description:'DrainPred_Get_Climate_AnnValue',
  fileFormat: 'CSV'
});
/**/
