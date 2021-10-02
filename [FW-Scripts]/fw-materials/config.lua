Config = Config or {}

Config.ScrapyardLocations = {
    [1] = {['Name'] = 'Yellow Jack', ['X'] = 2352.27, ['Y'] = 3133.19, ['Z'] = 48.20},
   -- [2] = {['Name'] = 'Secret Location', ['X'] = 2352.27, ['Y'] = 3133.19, ['Z'] = 48.20}
}

Config.CanScrap = true

Config.OpenedBins = {}

Config.Dumpsters = {
  [1] = {['Model'] = 666561306,    ['Name'] = 'Blauwe Bak'},
  [2] = {['Model'] = 218085040,    ['Name'] = 'Licht Blauwe Bak'},
  [3] = {['Model'] = -58485588,    ['Name'] = 'Grijze Bak'},
  [4] = {['Model'] = 682791951,    ['Name'] = 'Grote Blauwe Bak'},
  [5] = {['Model'] = -206690185,   ['Name'] = 'Grote Groene Bak'},
  [6] = {['Model'] = 364445978,    ['Name'] = 'Grote Groene Bak'},
  [7] = {['Model'] = 143369,       ['Name'] = 'Kleine Bak'},
  [8] = {['Model'] = -2140438327,  ['Name'] = 'Unknow Bak'},
  [9] = {['Model'] = -1851120826,  ['Name'] = 'Unknow Bak'},
  [10] = {['Model'] = -1543452585, ['Name'] = 'Unknow Bak'},
  [11] = {['Model'] = -1207701511, ['Name'] = 'Unknow Bak'},
  [12] = {['Model'] = -918089089,  ['Name'] = 'Unknow Bak'},
  [13] = {['Model'] = 1511880420,  ['Name'] = 'Unknow Bak'},
  [14] = {['Model'] = 1329570871,  ['Name'] = 'Unknow Bak'},
}

Config.BinItems = {
 'plastic',  
 'metalscrap',  
 'copper', 
 'aluminum',
 'iron',
 'steel',
 'rubber',
 'glass',
}

Config.CarItems = {
  'plastic',  
  'metalscrap',  
  'copper', 
  'aluminum',
  'iron',
  'steel',
  'rubber',
  'glass',
}

Config['delivery'] = {
	outsideLocation = {x=55.576,y=6472.12,z=31.42,a=230.732},
	insideLocation = {x=1072.72,y=-3102.51,z=-38.999,a=82.95},
	pickupLocations = {
		[1] = {x=1067.68,y=-3095.43,z=-39.9,a=342.39},
		[2] = {x=1065.2,y=-3095.56,z=-39.9,a=356.53},
		[3] = {x=1062.73,y=-3095.15,z=-39.9,a=184.81},
		[4] = {x=1060.37,y=-3095.06,z=-39.9,a=190.3},
		[5] = {x=1057.95,y=-3095.51,z=-39.9,a=359.02},
		[6] = {x=1055.58,y=-3095.53,z=-39.9,a=0.95},
		[7] = {x=1053.09,y=-3095.57,z=-39.9,a=347.64},
		[8] = {x=1053.07,y=-3102.46,z=-39.9,a=180.26},
		[9] = {x=1055.49,y=-3102.45,z=-39.9,a=180.46},
		[10] = {x=1057.93,y=-3102.55,z=-39.9,a=174.22},
		[11] = {x=1060.19,y=-3102.38,z=-39.9,a=189.44},
		[12] = {x=1062.71,y=-3102.53,z=-39.9,a=182.11},
		[13] = {x=1065.19,y=-3102.48,z=-39.9,a=176.23},
		[14] = {x=1067.46,y=-3102.62,z=-39.9,a=188.28},
		[15] = {x=1067.69,y=-3110.01,z=-39.9,a=173.63},
		[16] = {x=1065.13,y=-3109.88,z=-39.9,a=179.46},
		[17] = {x=1062.7,y=-3110.07,z=-39.9,a=174.32},
		[18] = {x=1060.24,y=-3110.26,z=-39.9,a=177.77},
		[19] = {x=1057.76,y=-3109.82,z=-39.9,a=183.88},
		[20] = {x=1055.52,y=-3109.76,z=-39.9,a=181.36},
		[21] = {x=1053.16,y=-3109.71,z=-39.9,a=177.0},
	},
	dropLocation = {x = 1048.224, y = -3097.071, z = -38.999, a = 274.810},
	warehouseObjects = {
		"prop_boxpile_05a",
		"prop_boxpile_04a",
		"prop_boxpile_06b",
		"prop_boxpile_02c",
		"prop_boxpile_02b",
		"prop_boxpile_01a",
		"prop_boxpile_08a",
	},
}