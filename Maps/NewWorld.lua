-- NewWorld
-- Author: blkbutterfly74
-- DateCreated: 1/22/2018 9:55:11 AM
-- Creates a map of the New World instructed by Conquest of The New World scenario for Civ V
-- based off AEP ("United Nations") Earth map script
-----------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"
include "MountainsCliffs"
include "RiversLakes"
include "FeatureGenerator"
include "TerrainGenerator"
include "NaturalWonderGenerator"
include "ResourceGenerator"
include "AssignTrueStartingPlots"

local earth = nil;

-- north pole
local g_CenterX = 110;
local g_CenterY = 68;

local g_iE = 70.6;			-- approx. distance to equator from north pole (measured from image of map)

-- TSLs in polar coords (deg) from N.P.
local g_TSLs = {
	LEADER_MONTEZUMA = {56, 174},
	LEADER_MINOR_CIV_LA_VENTA = {57, 178},
	-- LEADER_MINOR_CIV_PALENQUE cannot be placed cos of proximity
	LEADER_T_ROOSEVELT = {39.8, -162.5},
	LEADER_T_ROOSEVELT_ROUGHRIDER = {39.8, -162.5},
	LEADER_PEDRO = {99.6, -146.5},
	LEADER_VICTORIA = {31, -91.8},
	LEADER_CATHERINE_DE_MEDICI = {35, -91.6},
	LEADER_CATHERINE_DE_MEDICI_ALT = {35, -91.6},
	LEADER_PHILIP_II = {39.2, -95.9},
	LEADER_MINOR_CIV_AMSTERDAM = {30.1, -84.3}, 
	--LEADER_MINOR_CIV_BRUSSELS cannot be placed cos of proximity
	LEADER_MINOR_CIV_BUENOS_AIRES = {102.9, -154.7},
	--LEADER_MINOR_CIV_GENEVA = {36.1, -85.2},
	--LEADER_MINOR_CIV_LISBON = {42.4, -98.1}, replaced by Portugal
	LEADER_MINOR_CIV_TORONTO = {37.1, -166},
	LEADER_MINOR_CIV_ARMAGH = {30.4, -99.5},
	--LEADER_MINOR_CIV_GRANADA = {41, -92.7},
	LEADER_LADY_SIX_SKY = {61.4, -173.5},
	LEADER_SIMON_BOLIVAR = {68, -162.9},
	LEADER_MINOR_CIV_CAGUANA = {56.6, -159.3},
	LEADER_JOAO_III = {42.4, -98.1},
};

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local g_iNumTotalLandTiles = 0; 
local landStrips = {
		{78, 103, 103},
		{79, 102, 102},
		{80, 101, 101},
		{81, 100, 100},
		{82, 99, 99},
		{83, 97, 99},
		{83, 101, 103},
		{83, 102, 103},
		{84, 72, 77},
		{84, 98, 104},
		{85, 71, 78},
		{85, 98, 104},
		{86, 64, 79},
		{86, 97, 103},
		{86, 106, 106},
		{87, 62, 64},
		{87, 68, 81},
		{87, 83, 85},
		{87, 88, 89},
		{87, 95, 104},
		{88, 60, 62},
		{88, 65, 104},
		{89, 64, 103},
		{90, 61, 105},
		{91, 59, 104},
		{91, 109, 109},
		{92, 56, 103},
		{93, 55, 102},
		{93, 110, 110},
		{94, 54, 99},
		{95, 54, 98},
		{96, 53, 97},
		{97, 53, 95},
		{98, 52, 94},
		{98, 97, 97},
		{99, 52, 56},
		{99, 58, 92},
		{99, 97, 98}, 
		{100, 52, 54},
		{100, 60, 92},
		{100, 94, 95},
		{100, 97, 97},
		{101, 52, 53},
		{101, 61, 92},
		{101, 94, 96},
		{101, 99, 100},
		{102, 52, 53},
		{102, 62, 92},
		{102, 94, 96},
		{102, 98, 98},
		{102, 100, 100},
		{103, 51, 53},
		{103, 63, 91},
		{104, 50, 53},
		{104, 62, 93},
		{104, 95, 96},
		{104, 98, 98},
		{104, 100, 100},
		{105, 50, 54},
		{105, 61, 84},
		{105, 87, 94},
		{105, 96, 96},
		{106, 42, 43},
		{106, 49, 55},
		{106, 61, 83},
		{106, 88, 92},
		{106, 100, 102},
		{107, 49, 55},
		{107, 62, 83},
		{107, 91, 91},
		{107, 94, 95},
		{107, 97, 97},
		{107, 99, 103},
		{108, 49, 51},
		{108, 54, 55},
		{108, 62, 82},
		{108, 88, 89},
		{108, 91, 92},
		{108, 94, 95},
		{108, 99, 103},
		{109, 49, 51},
		{109, 55, 55},
		{109, 63, 82},
		{109, 94, 96},
		{110, 48, 51},
		{110, 62, 81},
		{110, 90, 90},
		{110, 92, 92},
		{110, 94, 95},
		{110, 99, 106},
		{111, 47, 51},
		{111, 56, 56},
		{111, 62, 81},
		{111, 85, 88},
		{111, 90, 91},
		{111, 93, 95},
		{111, 100, 106},
		{112, 47, 51},
		{112, 56, 57},
		{112, 61, 82},
		{112, 84, 87},
		{112, 90, 94},
		{112, 99, 107},
		{113, 46, 47},
		{113, 50, 51},
		{113, 57, 57},
		{113, 60, 87},
		{113, 89, 93},
		{113, 99, 107},
		{114, 46, 46},
		{114, 57, 57},
		{114, 59, 61},
		{114, 65, 87},
		{114, 89, 93},
		{114, 97, 106},
		{115, 46, 46},
		{115, 57, 57},
		{115, 66, 86},
		{115, 89, 90},
		{115, 92, 92},
		{115, 96, 106},
		{116, 45, 46},
		{116, 57, 57},
		{116, 59, 59},
		{116, 61, 61},
		{116, 67, 87},
		{116, 95, 105},
		{117, 36, 36},
		{117, 46, 47},
		{117, 56, 57},
		{117, 59, 59},
		{117, 72, 87},
		{117, 94, 105},
		{118, 35, 36},
		{118, 38, 40},
		{118, 47, 47},
		{118, 54, 54},
		{118, 56, 57},
		{118, 74, 78},
		{118, 80, 86},
		{118, 94, 104},
		{119, 35, 41},
		{119, 46, 47},
		{119, 54, 54},
		{119, 56, 57},
		{119, 59, 59},
		{119, 73, 73},
		{119, 76, 79},
		{119, 81, 85},
		{119, 93, 103},
		{120, 34, 42},
		{120, 46, 47},
		{120, 56, 56},
		{120, 58, 58},
		{120, 77, 79},
		{120, 82, 85},
		{120, 93, 103},
		{121, 33, 48},
		{121, 76, 78},
		{121, 82, 85},
		{121, 92, 101},
		{122, 33, 49},
		{122, 55, 55},
		{122, 58, 58},
		{122, 78, 79},
		{122, 85, 85},
		{122, 93, 95},
		{123, 32, 50},
		{123, 56, 56},
		{123, 79, 79},
		{123, 81, 83},
		{123, 93, 93},
		{123, 101, 102},
		{124, 31, 50},
		{124, 56, 57},
		{124, 82, 83},
		{124, 101, 104},
		{125, 30, 51},
		{125, 57, 57},
		{125, 82, 83},
		{125, 102, 104},
		{126, 30, 51},
		{126, 57, 57},
		{126, 82, 82},
		{127, 30, 52},
		{128, 30, 52},
		{128, 57, 57},
		{129, 30, 51},
		{129, 58, 58},
		{130, 30, 52},
		{130, 107, 107},
		{131, 30, 52},
		{131, 106, 108},
		{132, 30, 52},
		{132, 107, 107},
		{133, 4, 4},
		{133, 6, 6},
		{133, 30, 53},
		{133, 104, 104},
		{133, 107, 108},
		{134, 3, 5},
		{133, 7, 7},
		{134, 30, 54},
		{134, 59, 59},
		{134, 104, 105},
		{134, 107, 109},
		{134, 112, 113},
		{135, 2, 8},
		{135, 10, 15},
		{135, 28, 54},
		{135, 57, 57},
		{135, 104, 105},
		{135, 107, 109},
		{135, 112, 113},
		{136, 3, 8},
		{136, 11, 17},
		{136, 19, 55},
		{136, 106, 109},
		{136, 111, 113},
		{137, 2, 54},
		{137, 111, 113},
		{138, 2, 54},
		{138, 107, 113},
		{139, 2, 54},
		{139, 107, 113},
		{140, 2, 54},
		{140, 107, 113},
		{141, 2, 2},
		{141, 4, 54},
		{141, 108, 113},
		{142, 3, 54},
		{142, 104, 105},
		{142, 108, 113},
		{143, 3, 3},
		{143, 5, 55},
		{143, 104, 111},
		{144, 5, 56},
		{144, 103, 110},
		{145, 3, 56},
		{145, 103, 109},
		{146, 3, 6},
		{146, 8, 56},
		{146, 103, 108},
		{147, 3, 5},
		{147, 8, 10},
		{147, 12, 57},
		{147, 104, 107},
		{148, 4, 5},
		{148, 9, 10},
		{148, 13, 57},
		{149, 4, 5},
		{149, 10, 11},
		{149, 13, 57},
		{150, 4, 5},
		{150, 11, 11},
		{150, 14, 15},
		{150, 17, 57},
		{151, 5, 6},
		{151, 16, 16},
		{151, 18, 57},
		{152, 6, 6},
		{152, 18, 57},
		{153, 19, 57},
		{154, 7, 7},
		{154, 21, 57},
		{155, 7, 7},
		{155, 21, 58},
		{156, 22, 58},
		{157, 23, 58},
		{158, 24, 59},
		{159, 0, 0},
		{159, 24, 60},
		{160, 0, 1},
		{160, 26, 61},
		{161, 0, 2},
		{161, 13, 13},
		{161, 28, 62},
		{162, 0, 2},
		{162, 14, 14},
		{162, 30, 63},
		{163, 0, 3},
		{163, 30, 63},
		{164, 0, 3},
		{164, 15, 15},
		{164, 31, 63},
		{165, 0, 2},
		{165, 4, 4},
		{165, 35, 64},
		{166, 0, 2},
		{166, 4, 5},
		{166, 36, 40},
		{166, 43, 65},
		{167, 0, 1},
		{167, 5, 6},
		{167, 40, 40},
		{167, 44, 66},
		{168, 0, 0},
		{168, 6, 6},
		{168, 8, 8},
		{168, 46, 66},
		{169, 0, 0},
		{169, 7, 7},
		{169, 48, 64},
		{170, 7, 8},
		{170, 49, 57},
		{171, 8, 8},
		{171, 50, 56},
		{172, 9, 10},
		{173, 10, 10},
		{173, 13, 13}};

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Earth Ocean Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	
	plotTypes = GeneratePlotTypes();
	terrainTypes = GenerateTerrainTypesEarth(plotTypes, g_iW, g_iH, g_iFlags, true);

	for i = 0, (g_iW * g_iH) - 1, 1 do
		pPlot = Map.GetPlotByIndex(i);
		if (plotTypes[i] == g_PLOT_TYPE_HILLS) then
			terrainTypes[i] = terrainTypes[i] + 1;
		end
		TerrainBuilder.SetTerrainType(pPlot, terrainTypes[i]);
	end

	-- Temp
	AreaBuilder.Recalculate();
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());

	-- Place lakes before rivers to allow them to act as sources for rivers
	local numLargeLakes = GameInfo.Maps[Map.GetMapSize()].Continents;
	AddLakes(numLargeLakes);

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();

	AddFeatures();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);
	
	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};

	local nwGen = NaturalWonderGenerator.Create(args);

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();
	
	local resourcesConfig = MapConfiguration.GetValue("resources");
	local args = {
		resources = resourcesConfig,
		LuxuriesPerRegion = 7,
	}
	local resGen = ResourceGenerator.Create(args);

	print("Setting true start locations.");

	local args = {
		TRUE_START_LOCATIONS = g_TSLs,
		CENTER_X = g_CenterX,
		CENTER_Y = g_CenterY,
		WIDTH = g_iW,
	};
	local true_start_locations = AssignTrueStartingPlots.Create(args);

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

-- Input a Hash; Export width, height, and wrapX
function GetMapInitData(MapSize)
	local Width = 114;
	local Height = 97;
	return {Width = Width, Height = Height, WrapX = false}
end

-------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Generating Plot Types");
	local plotTypes = {};

	-- Start with it all as water
	for x = 0, g_iW - 1 do
		for y = 0, g_iH - 1 do
			local i = y * g_iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			plotTypes[i] = g_PLOT_TYPE_OCEAN;
			TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
		end
	end

	-- Each land strip is defined by: Y, X Start, X End
	local xOffset = 0;
	local yOffset = -76;
		
	for i, v in ipairs(landStrips) do
		local y = g_iH - (v[1] + yOffset);   -- inverted 
		local xStart = v[2] + xOffset;
		local xEnd = v[3] + xOffset; 
		for x = xStart, xEnd do
			local i = y * g_iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			plotTypes[i] = g_PLOT_TYPE_LAND;
			TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_SNOW);  -- temporary setting so can calculate areas
			g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
		end
	end
		
	AreaBuilder.Recalculate();

	--	world_age
	local world_age_new = 5;
	local world_age_normal = 3;
	local world_age_old = 2;

	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 2) then
		world_age = world_age_normal;
	elseif (world_age == 3) then
		world_age = world_age_old;
	else
		world_age = 2 + TerrainBuilder.GetRandomNumber(4, "Random World Age - Lua");
	end
	
	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 10;
	args.blendFract = 1;
	args.extra_mountains = 4;
	plotTypes = ApplyTectonics(args, plotTypes);

	return plotTypes;
end

function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
	local invert_heights = args.invert_heights or false;
	local polar = args.polar or true;
	local ridge_flags = args.ridge_flags or g_iFlags;

	local fracFlags = {};
	
	if(invert_heights) then
		fracFlags.FRAC_INVERT_HEIGHTS = true;
	end
	
	if(polar) then
		fracFlags.FRAC_POLAR = true;
	end
	
	if(rift_grain > 0 and rift_grain < 4) then
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 6, 5);	
	end

	-- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
	-- Without fractal variation, the tectonics come out too regular.
	--
	--[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I 
	added some minor randomness and the slope might be a little tricky. It was 
	intended as a 'whole world' modifier to the fractal class. You can modify 
	the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	-- Blend a bit of ridge into the fractal.
	-- This will do things like roughen the coastlines and build inland seas. - Brian

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	
	local args = {rainfall = rainfall, iJunglePercent = 40, iMarshPercent = 7, iForestPercent = 40}	-- no rainforest
	local featuregen = FeatureGenerator.Create(args);

	featuregen:AddFeatures();
end

------------------------------------------------------------------------------
function GenerateTerrainTypesEarth(plotTypes, iW, iH, iFlags, bNoCoastalMountains)
	print("Generating Terrain Types");
	local terrainTypes = {};

	local fracXExp = -1;
	local fracYExp = -1;
	local grain_amount = 3;

	earth = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
									
	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			if (plotTypes[index] == g_PLOT_TYPE_OCEAN) then
				if (IsAdjacentToLand(plotTypes, iX, iY)) then
					terrainTypes[index] = g_TERRAIN_TYPE_COAST;
				else
					terrainTypes[index] = g_TERRAIN_TYPE_OCEAN;
				end
			end
		end
	end

	if (bNoCoastalMountains == true) then
		plotTypes = RemoveCoastalMountains(plotTypes, terrainTypes);
	end

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			local _lat = _GetRadialLatitudeAtPlot(earth, iX, iY);
			local lat = math.abs(_lat);
			local iAzimuth = Azimuth(iX, iY, g_CenterX, g_CenterY);
			local earthVal = earth:GetHeight(iX, iY);

			-- 12% snow
			local iSnowTop = earth:GetHeight(100);	
			local iSnowBottom = earth:GetHeight(88);
				
			-- 10% tundra							
			local iTundraTop = iSnowBottom;										
			local iTundraBottom = earth:GetHeight(78);

										  
											 

			local iPlainsTop = iTundraBottom;
			local iPlainsBottom = earth:GetHeight(53);

			local iGrassTop = iPlainsBottom;
			local iGrassBottom = earth:GetHeight(33);

			-- 33% desert
			local iDesertTop = iGrassBottom;
			local iDesertBottom = earth:GetHeight(0);

			-- antarctica and north pole
			if (_lat < -0.7 or _lat > 0.83) then
				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW_MOUNTAIN;
				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW;
				end

			-- arctic circle and patagonia
			elseif (_lat > 0.73 or _lat < -0.66) then
				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW_MOUNTAIN;

					if ((earthVal >= iTundraBottom) and (earthVal <= iTundraTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
					end
				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW;

					if ((earthVal >= iTundraBottom) and (earthVal <= iTundraTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA;
					end
				end

			-- Australia, Sahara & Arabia
			elseif ((_lat < -0.11 and _lat > -0.48 and iAzimuth > 22 and iAzimuth < 64)
					or (_lat < 0.41 and _lat > 0.13 and iAzimuth > -109 and iAzimuth < -31)) then
			 
				iGrassTop = earth:GetHeight(100);
				iGrassBottom = earth:GetHeight(97);
				
				iPlainsTop = iGrassBottom;
				iPlainsBottom = earth:GetHeight(90);

				iDesertTop = iPlainsBottom;
				iDesertBottom = earth:GetHeight(0);

				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					if ((earthVal >= iDesertBottom) and (earthVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					elseif ((earthVal >= iGrassBottom) and (earthVal <= iGrassTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;
					end
				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then			
					if ((earthVal >= iDesertBottom) and (earthVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					elseif ((earthVal >= iGrassBottom) and (earthVal <= iGrassTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
					end
				end

			-- grassland not found further north than 60 deg.
			elseif (lat > 0.66) then
				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW_MOUNTAIN;

					if ((earthVal >= iTundraBottom) and (earthVal <= iTundraTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					end

				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_SNOW;
				
					if ((earthVal >= iTundraBottom) and (earthVal <= iTundraTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					end
				end
			
			-- tropics
			elseif (lat < 0.26) then
				-- rainforest
				iGrassTop = earth:GetHeight(100);
				iGrassBottom = earth:GetHeight(30);
																		
				iPlainsTop = iGrassBottom;
				iPlainsBottom = earth:GetHeight(5);

				iDesertTop = iPlainsBottom;

				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;

					if ((earthVal >= iGrassBottom) and (earthVal <= iGrassTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					end

				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
		
					if ((earthVal >= iGrassBottom) and (earthVal <= iGrassTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					end
				end

			-- central eurasia and north america
			elseif (lat > 0.44) then
				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;

					if ((earthVal >= iSnowBottom) and (earthVal <= iSnowTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_SNOW_MOUNTAIN;
					elseif ((earthVal >= iTundraBottom) and (earthVal <= iTundraTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA_MOUNTAIN;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					end

				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
				
					if ((earthVal >= iSnowBottom) and (earthVal <= iSnowTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_SNOW;
					elseif ((earthVal >= iTundraBottom) and (earthVal <= iTundraTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_TUNDRA;
					elseif ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					end
				end

			-- rest of world
			else
				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;

					if ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					elseif ((earthVal >= iDesertBottom) and (earthVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;
					end

				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
				
					if ((earthVal >= iPlainsBottom) and (earthVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					elseif ((earthVal >= iDesertBottom) and (earthVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
					end
				end

			end
		end
	end

	local bExpandCoasts = true;

	if bExpandCoasts == false then
		return
	end

	print("Expanding coasts");
	for iI = 0, 2 do
		local shallowWaterPlots = {};
		for iX = 0, iW - 1 do
			for iY = 0, iH - 1 do
				local index = (iY * iW) + iX;
				if (terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) then
					-- Chance for each eligible plot to become an expansion is 1 / iExpansionDiceroll.
					-- Default is two passes at 1/4 chance per eligible plot on each pass.
					if (IsAdjacentToShallowWater(terrainTypes, iX, iY) and TerrainBuilder.GetRandomNumber(4, "add shallows") == 0) then
						table.insert(shallowWaterPlots, index);
					end
				end
			end
		end
		for i, index in ipairs(shallowWaterPlots) do
			terrainTypes[index] = g_TERRAIN_TYPE_COAST;
		end
	end
	
	return terrainTypes; 
end

-- override: circular poles
function FeatureGenerator:AddIceAtPlot(plot, iX, iY)
	local _lat = _GetRadialLatitudeAtPlot(earth, iX, iY);
	local lat = math.abs(_lat);
	
	-- more south polar ice
	if (_lat > 0.66 or _lat < - 0.6) then
		local iScore = TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");

		iScore = iScore + lat * 100;

		if(IsAdjacentToLandPlot(iX,iY) == true) then
			iScore = iScore / 2.0;
		end

		local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_ICE);
		iScore = iScore + 10.0 * iAdjacent;

		if(iScore > 130) then
			TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
			   
		end
	end
	
	return false;
end

-- override: for a radial equator 
------------------------------------------------------------------------------
function FeatureGenerator:AddJunglesAtPlot(plot, iX, iY)
	local lat = GetRadialLatitudeAtPlot(earth, iX, iY);

	--Jungle Check. First see if it can place the feature.	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JUNGLE)) then
		if(math.ceil(self.iJungleCount * 100 / self.iNumLandPlots) <= self.iJungleMaxPercent) then
			if(lat < 0.26) then		-- tropics 
																			 
																		  

																						 

																						
				--Weight based on adjacent plots if it has more than 3 start subtracting
				local iScore = 300;
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JUNGLE);

				if(iAdjacent == 0 ) then
					iScore = iScore;
				elseif(iAdjacent == 1) then
					iScore = iScore + 50;
				elseif (iAdjacent == 2 or iAdjacent == 3) then
					iScore = iScore + 150;
				elseif (iAdjacent == 4) then
					iScore = iScore - 50;
				else
					iScore = iScore - 200;
				end

				if(TerrainBuilder.GetRandomNumber(300, "Resource Placement Score Adjust") <= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
					local terrainType = plot:GetTerrainType();

					if(terrainType == g_TERRAIN_TYPE_PLAINS_HILLS or terrainType == g_TERRAIN_TYPE_GRASS_HILLS) then
						TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS_HILLS);
					else
						TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS);
					end

					self.iJungleCount = self.iJungleCount + 1;
					return true;
				end
			end
		end
	end

	return false
end

------------------------------------------------------------------------------
function FeatureGenerator:AddReefAtPlot(plot, iX, iY)
	local lat = GetRadialLatitudeAtPlot(earth, iX, iY);

	--Reef Check. First see if it can place the feature.
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_REEF) and lat < 0.38) then		-- northern most reefs
		self.iNumReefablePlots = self.iNumReefablePlots + 1;
		if(math.ceil(self.iReefCount * 100 / self.iNumReefablePlots) <= self.iReefMaxPercent) then
																						  

				--Weight based on adjacent plots
															  
				local iScore  = 3 * g_iE * lat;
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_REEF);

				if(iAdjacent == 0 ) then
					iScore = iScore + 100;
				elseif(iAdjacent == 1) then
					iScore = iScore + 125;
				elseif (iAdjacent == 2) then
					iScore = iScore  + 150;
				elseif (iAdjacent == 3 or iAdjacent == 4) then
					iScore = iScore + 175;
				else
					iScore = iScore + 10000;
				end

				if(TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust") >= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_REEF);
					self.iReefCount = self.iReefCount + 1;
				end
		end
	end
end
------------------------------------------------------------------------------

-- bugfix/patch - remember pythagoras?
function __GetPlotDistance(iX1, iY1, iX0, iY0)
	return math.sqrt((iX1-iX0)^2 + (iY1-iY0)^2);
end

-- the angle of (iX1, iY1) relative to (iX0, iY0) in degrees
function Azimuth(iX1, iY1, iX0, iY0)
	return math.deg(_Azimuth(iX1, iY1, iX0, iY0));
end

-- the angle of (iX1, iY1) relative to (iX0, iY0)
function _Azimuth(iX1, iY1, iX0, iY0)
	return math.atan2(iY1-iY0, iX1-iX0);
end

----------------------------------------------------------------------------------
-- LATITUDE LOOKUP
----------------------------------------------------------------------------------
function _GetRadialLatitudeAtPlot(variationFrac, iX, iY)
	local iZ = __GetPlotDistance(iX, iY, g_CenterX, g_CenterY);		-- radial distance from center

	if (iZ < 2*g_iE) then
		-- Terrain bands are governed by latitude (in rad).
		local _lat = 1/2 - iZ/(2*g_iE);

		-- Returns a latitude value between 0.0 (tropical) and +/-1.0 (polar).
		local lat = 2 * _lat;
	
		-- Adjust latitude using variation fractal, to roughen the border between bands:
		-- lessen the variation at south pole
		lat = lat + (128 - variationFrac:GetHeight(iX, iY))/(255.0 * 5.0) * (1 - iZ/(2*g_iE));

		-- Limit to the range [-1, 1]:
		lat = math.clamp(lat, -1, 1);
	
		return lat;
	else
		-- off the map (south pole) 
		return -1;
	end
end

-- Returns a latitude value between 0.0 (tropical) and 1.0 (polar).
function GetRadialLatitudeAtPlot(variationFrac, iX, iY)
	return math.abs(_GetRadialLatitudeAtPlot(variationFrac, iX, iY));
end