var poi = ee.FeatureCollection("users/NC_R2/GEE_Get_Climate_poi");

var annual = ee.ImageCollection("ECMWF/ERA5_LAND/MONTHLY_AGGR")
                .filter(ee.Filter.calendarRange(2000,2020,'year'))
                .filter(ee.Filter.calendarRange(1,12,'month'))
                .select("temperature_2m_max","soil_temperature_level_1_max","total_precipitation_max","snowmelt_max","surface_solar_radiation_downwards_max","u_component_of_wind_10m_max","v_component_of_wind_10m_max");
print(annual);


var computeYearlyMax = function(year) {
  var yearStart = ee.Date.fromYMD(year, 1, 1);
  var yearEnd = ee.Date.fromYMD(year, 12, 31);
  var yearlyMax = annual.filterDate(yearStart, yearEnd).max();
  yearlyMax = yearlyMax.rename("t2m_max","tsl_max","precip_max","snowmelt_max","srad_max","u_max","v_max");
  var uComponent = yearlyMax.select('u_max');
  var vComponent = yearlyMax.select('v_max');
  var windSpeed = uComponent.hypot(vComponent).rename("windsp_max");
  yearlyMax = yearlyMax.select("t2m_max","tsl_max","precip_max","snowmelt_max","srad_max").addBands(windSpeed);
  return yearlyMax.set('year', year);
};
var years = ee.List.sequence(2000, 2020);
var era5LandYearlyMax = ee.ImageCollection.fromImages(years.map(computeYearlyMax));
print(era5LandYearlyMax);

var extractBandsByYear = function(year) {
  var feature = poi.filter(ee.Filter.eq('Get_Year', year));
  var img = era5LandYearlyMax.filter(ee.Filter.eq('year', year)).first();
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
  description:'DrainPred_Get_Climate_MaxValue',
  fileFormat: 'CSV'
});
/**/
