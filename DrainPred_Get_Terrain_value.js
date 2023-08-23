
//经测试，ee.Terrain.products和ee.Terrain.slope计算的坡度值大致一样，只是products导出整数
//另外，只使用ArcticDEM的话，很多地方存在空缺
//将ArcticDEM和AW3D30结合的话，坡度值会显著改变。奇怪了

var DEM = ee.Image('UMN/PGC/ArcticDEM/V3/2m_mosaic').select('elevation');
//var terrain = ee.Terrain.products(DEM).select("elevation","slope");
var terrain = DEM.addBands(ee.Terrain.slope(DEM));
print(terrain);

var dem_stat = terrain.reduceRegions({
     collection: poi,
     reducer: ee.Reducer.mean(),
     scale: 1000,
  });

Export.table.toDrive({
  collection: dem_stat,
  description: 'DrainPred_Get_Terrain_ArcticDEM',
  fileFormat: 'CSV'
});


var dem_dataset2 = ee.Image('JAXA/ALOS/AW3D30/V2_2').select('AVE_DSM').rename("elevation");
var terrain2 = dem_dataset2.addBands(ee.Terrain.slope(dem_dataset2));

var dem_stat2 = terrain2.reduceRegions({
     collection: poi,
     reducer: ee.Reducer.mean(),
     scale: 1000,
  });

Export.table.toDrive({
  collection: dem_stat2,
  description: 'DrainPred_Get_Terrain_AW3D30',
  fileFormat: 'CSV'
});

 