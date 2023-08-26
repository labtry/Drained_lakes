var aoi = ee.FeatureCollection("users/NC_R2/Annual_NDVI/GEE_extract_poly");

// Import Landsat Collection Builder module: https://jdbcode.github.io/EE-LCB/
var lcb = require('users/jstnbraaten/modules:ee-lcb.js'); 

//aoi = aoi.first().geometry();
//print(aoi);

// Set initial ee-lcb params
var props = lcb.setProps({
  startYear: 2000,
  endYear: 2020,
  startDate: '06-01',
  endDate: '09-30',
  sensors: ['LT05', 'LE07', 'LC08'],
  cfmask: ['cloud', 'shadow'],
  harmonizeTo: 'LC08',
  aoi: aoi,
  printProps: false
});


function sr_removeBandCFmask(img){ // TODO: add this to the exports - possibly make it remove all qa bands
  return img.select(img.bandNames().filter(ee.Filter.neq('item', 'pixel_qa')));
}

function setMosaicMetadata(img){
  var yearString = ee.Algorithms.String(img.get('composite_year')).slice(0,4);
  var yearInt = ee.Number.parse(yearString);
  return {
    'filler': img.get('filler'),
    'band_names': img.get('band_names'),
    'composite_year': yearInt,
    'harmonized_to': img.get('harmonized_to'),
    'system:index': yearString,
    'system:time_start': ee.Date.fromYMD(yearInt, props.compDateInt.month, props.compDateInt.day).millis()
  };
}


// Define an annual collection plan.
var plan = function(year){
  var col = lcb.sr.gather(year)
    .map(lcb.sr.maskCFmask)
    .map(lcb.sr.harmonize)
    .map(lcb.sr.addBandNDVI)
    .map(lcb.sr.addBandTC)
    .select('NDVI','TCG');
  return col.map(sr_removeBandCFmask)
    .reduce(ee.Reducer.percentile([90]))		//90th
    .set(setMosaicMetadata(col.first()))
    .rename(sr_removeBandCFmask(col.first()).bandNames());
};

// Define annual collection year range as ee.List.
var years = ee.List.sequence(props.startYear, props.endYear);   // <--- use props. instead of lcb.props.

// Generate annual summer image composite collection.
var col = ee.ImageCollection.fromImages(years.map(plan)).first();
var ndviMask = col.select('NDVI').gte(0);
var tcgMask = col.select('TCG').gte(0);
col = col.updateMask(ndviMask).updateMask(tcgMask);

print(col);

var stat = col.reduceRegions({
    collection:aoi, 
    reducer:ee.Reducer.median(), 
    scale: 30,
    tileScale: 4
  });

print(stat);

Export.table.toDrive({
  collection: stat,
  description: 'ndvi_tcg_2020',
  fileFormat: 'CSV'
});
