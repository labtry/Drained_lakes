var poi = ee.FeatureCollection("users/NC_R2/GEE_Get_Climate_poi");

var annual = ee.ImageCollection("ECMWF/ERA5_LAND/MONTHLY_AGGR")
                .filter(ee.Filter.calendarRange(2000,2020,'year'))
                .filter(ee.Filter.calendarRange(1,12,'month'))
                .select("temperature_2m","soil_temperature_level_1","total_precipitation_sum","snowmelt_sum","surface_solar_radiation_downwards_sum","u_component_of_wind_10m","v_component_of_wind_10m","total_evaporation_sum","snowfall_sum");

var computeYearlyMean = function(year) {
  var yearStart = ee.Date.fromYMD(year, 1, 1);
  var yearEnd = ee.Date.fromYMD(year, 12, 31);
  var yearlyMean = annual.filterDate(yearStart, yearEnd).mean();
  yearlyMean = yearlyMean.rename("t2m_ann","tsl_ann","precip_ann","snowmelt_ann","srad_ann","u_ann","v_ann","evap_ann","snowfall_ann");
  var uComponent = yearlyMean.select('u_ann');
  var vComponent = yearlyMean.select('v_ann');
  var windSpeed = uComponent.hypot(vComponent).rename("windsp_ann");
  yearlyMean = yearlyMean.select("t2m_ann","tsl_ann","precip_ann","snowmelt_ann","srad_ann","evap_ann","snowfall_ann").addBands(windSpeed);
  return yearlyMean.set('year', year);
};
var years = ee.List.sequence(2000, 2020);
var era5LandYearlyMean = ee.ImageCollection.fromImages(years.map(computeYearlyMean));
print(era5LandYearlyMean);


//Sen's Slope
var annual_col = ee.ImageCollection(era5LandYearlyMean.map(function(img) {
  var year = img.get('year');
  var yr = ee.Image.constant(ee.Number(year)).toShort();
  return ee.Image.cat(yr, img).set('year', year);
}));

var t2m_Slope = annual_col.select("constant","t2m_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("t2m_slope");
var tsl_Slope = annual_col.select("constant","tsl_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("tsl_slope");
var precip_Slope = annual_col.select("constant","precip_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("precip_slope");
var snowmelt_Slope = annual_col.select("constant","snowmelt_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("snowmelt_slope");
var srad_Slope = annual_col.select("constant","srad_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("srad_slope");
var windsp_Slope = annual_col.select("constant","windsp_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("windsp_slope");
var evap_Slope = annual_col.select("constant","evap_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("evap_slope");
var snowfall_Slope = annual_col.select("constant","snowfall_ann").reduce(ee.Reducer.sensSlope()).select("slope").rename("snowfall_slope");

var merged_slope = t2m_Slope.addBands(tsl_Slope).addBands(precip_Slope).addBands(snowmelt_Slope).addBands(srad_Slope).addBands(windsp_Slope).addBands(evap_Slope).addBands(snowfall_Slope);

print(merged_slope);

var result = merged_slope.reduceRegions({
    reducer: ee.Reducer.mean(),
    collection: poi,
    scale: 1000
  });
Export.table.toDrive({
  collection: result,
  folder: '',
  description:'DrainPred_Get_Climate_Trend',
  fileFormat: 'CSV'
});
/**/
