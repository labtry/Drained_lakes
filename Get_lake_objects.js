//Study region from NCSCDv2_circumpolar_WGS84.shp (Hugelius et al., 2013)
//var aoi = ee.FeatureCollection("/NatureCommunications/StudyRegion");


aoi = aoi.first().geometry();

//used the JRC product's thematic map of water extent to identify persistent water
var image = ee.Image("JRC/GSW1_3/GlobalSurfaceWater");
var water = image.select("max_extent").clip(aoi).rename("water");
water = water.selfMask();

/*
// Perform morphological operations; an erosion followed by a dilation
// To separate finely connected water bodies and eliminate isolated pixels
var kernel = ee.Kernel.circle({radius: 1});
var water = water.focalMin({kernel: kernel, iterations: 2})
             .focalMax({kernel: kernel, iterations: 2}).selfMask();
//var water = water.focalMin().focalMax();
Map.addLayer(water, {palette: 'blue'}, 'water_opened');


//River mask way #1; Shapefile from Allen & Pavelsky (2018)
//var river_shp = ee.FeatureCollection("users/liuab8023/NatureCommunications/river");
//var mask = ee.Image.constant(1).clip(river_shp).mask().not();
//water = water.updateMask(mask);
*/


//River mask way #2; Use 'maxSize'
//Any objects larger than maxSize in either the horizontal or vertical dimension will be masked
var objectId = water.connectedComponents({connectedness: ee.Kernel.square(1),maxSize:1024});
Map.addLayer(objectId.randomVisualizer(), null, 'Objects',true);

var objectSize = objectId.select('labels').connectedPixelCount({maxSize: 1024, eightConnected: true});
var pixelArea = ee.Image.pixelArea();
var objectArea = objectSize.multiply(pixelArea);


//Mask lakes smaller than 1 ha
var areaMask = objectArea.gte(1e4);
objectId = objectId.updateMask(areaMask).select("labels");


// WKT projection description for https://epsg.io/102017
var proj = ee.Projection(
    'PROJCS["North_Pole_Lambert_Azimuthal_Equal_Area",'+
    '    GEOGCS["GCS_WGS_1984",'+
    '        DATUM["WGS_1984",'+
    '            SPHEROID["WGS_1984",6378137,298.257223563]],'+
    '        PRIMEM["Greenwich",0],'+
    '        UNIT["Degree",0.017453292519943295]],'+
    '    PROJECTION["Lambert_Azimuthal_Equal_Area"],'+
    '    PARAMETER["False_Easting",0],'+
    '    PARAMETER["False_Northing",0],'+
    '    PARAMETER["Central_Meridian",0],'+
    '    PARAMETER["Latitude_Of_Origin",90],'+
    '    UNIT["Meter",1],'+
    '    AUTHORITY["EPSG","102017"]]');
//print(proj);  // crs: EPSG:102017

var lon = ee.Image.pixelLonLat().clip(aoi).select("longitude");
//sign for negative values
var flag = lon.lt(0); 
//for instance, -80 -> 1080; 120 -> 0120
var temp = lon.abs().add(flag.multiply(1E3));
//round three decimal places
//mark negative sign with 1
temp = temp.multiply(1E3).round().multiply(1E-6);

var lat = ee.Image.pixelLonLat().clip(aoi).select("latitude");
//round three decimal places
lat=lat.multiply(1E3).round();
//merge latitude and longitude
var latlon = lat.multiply(1E1).add(temp).rename("latlon");

var newobject = objectId.addBands(latlon);
//set unique latlon for each lake object
var lake_objects = newobject.reduceConnectedComponents({
  reducer: ee.Reducer.first(), //or ee.Reducer.last()
  maxSize: 1024,
  labelBand: 'labels'
});

//get lat&lon and count the pixels of lakes larger than 1 ha 
var count = lake_objects.reduceRegion({
    reducer: ee.Reducer.frequencyHistogram(),
    geometry: aoi,
    scale: 30,
    crs: proj,
    maxPixels: 1e13,
    tileScale: 4
  });

var ff =  ee.FeatureCollection([ee.Feature(null,count)]);
Export.table.toDrive({
      collection: ff,
      folder: 'Ecoregion_stat+lake_number',
      description: 'gee_eco_01',
      fileFormat: 'CSV'
    });
