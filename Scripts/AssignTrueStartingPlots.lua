-- AssignTrueStartingPlots
-- Author: blkbutterfly74
-- DateCreated: 3/17/2018 10:55:30 AM
------------------------------------------------------------------------------
include "MapEnums"
include "MapUtilities"

------------------------------------------------------------------------------
AssignTrueStartingPlots = {};
------------------------------------------------------------------------------
function AssignTrueStartingPlots.Create(args)
	local instance = {

		-- Core Process member methods
		__InitStartingData				= AssignTrueStartingPlots.__InitStartingData,
		__GetIndex						= AssignTrueStartingPlots.__GetIndex,
		__TryToSetPlayerStartingPlot	= AssignTrueStartingPlots.__TryToSetPlayerStartingPlot,
		__GetAdjacentPlots				= AssignTrueStartingPlots.__GetAdjacentPlots,

		tsls = args.TRUE_START_LOCATIONS,
		centerX = args.CENTER_X,
		centerY = args.CENTER_Y,
	}

	instance:__InitStartingData();

	return instance;
end

------------------------------------------------------------------------------
function AssignTrueStartingPlots:__InitStartingData()
	for _, pPlayer in ipairs(Players) do
		local pPlayerConfig = PlayerConfigurations[pPlayer:GetID()];

		if (pPlayerConfig ~= nil) then
			local leaderName = pPlayerConfig:GetLeaderTypeName();
			
			if (leaderName ~= nil) then
				local v = self.tsls[leaderName];

				if (leaderName ~= "LEADER_FREE_CITIES") then	-- ignore free cities "civ"
					assert((v ~= nil), "No TSL for " .. leaderName);

					local i = self:__GetIndex(v[1], v[2]);
					local pPlot = Map.GetPlotByIndex(i);

					self:__TryToSetPlayerStartingPlot(pPlayer, leaderName, pPlot);
				end
			end
		end
	end 
end

------------------------------------------------------------------------------
function AssignTrueStartingPlots:__GetAdjacentPlots(pPlot)
	local aPlots = {};

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), direction);
		if (adjacentPlot ~= nil) then
			table.insert(aPlots, adjacentPlot);
		end
	end

	return aPlots;
end

------------------------------------------------------------------------------
function AssignTrueStartingPlots:__TryToSetPlayerStartingPlot(pPlayer, leaderName, pPlot)
	local i = pPlot:GetIndex();

	if (pPlot:IsMountain()) then
		print("NOTE: Mountain block TSL for " .. leaderName .. " at index: " .. i ..". Trying adjacent plot");
	elseif (pPlot:IsLake()) then
		print("NOTE: Lake block TSL for " .. leaderName .. " at index: " .. i ..". Trying adjacent plot");
	-- hard code for Kupe
	elseif (pPlot:IsWater() and leaderName ~= "LEADER_KUPE") then
		print("Note: Water tile block for ", leaderName .. " at index: " .. i ..". Trying adjacent plot"); 
	elseif (pPlot:IsImpassable()) then
		print("NOTE: Impassible tile blocks TSL for " .. leaderName .. " at index: " .. i ..". Trying adjacent plot");

	-- assign TSL
	else	
		pPlayer:SetStartingPlot(pPlot);
		print("Assigning TSL for", leaderName .. " at index: " .. i);
		return true;
	end

	-- o/w try to recursively assign TSL to adjacent plots
	for _, aPlot in ipairs(self:__GetAdjacentPlots(pPlot)) do
		if (self:__TryToSetPlayerStartingPlot(pPlayer, leaderName, aPlot)) then break
		end
	end
	return true;
end

------------------------------------------------------------------------------
function AssignTrueStartingPlots:__GetIndex(r, theta)
	local iX = self.centerX + __Round(r * math.cos(math.rad(theta)));
	local iY = self.centerY + __Round(r * math.sin(math.rad(theta)));

	local width, _ = Map.GetGridSize();

	return (iY * width + iX);		-- plot index from polar coord (deg)
end

------------------------------------------------------------------------------
function __Round(n)
	return math.floor(n + 0.5);
end
