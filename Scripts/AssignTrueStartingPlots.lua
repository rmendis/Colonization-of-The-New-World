-- AssignTrueStartingPlots
-- Author: blkbutterfly74
-- DateCreated: 3/17/2018 10:55:30 AM
------------------------------------------------------------------------------
AssignTrueStartingPlots = {};
------------------------------------------------------------------------------
function AssignTrueStartingPlots.Create(args)
	local instance = {

		-- Core Process member methods
		__InitStartingData				= AssignTrueStartingPlots.__InitStartingData,
		__PlotIndex						= AssignTrueStartingPlots.__PlotIndex,

		tsls = args.TRUE_START_LOCATIONS,
		centerX = args.CENTER_X,
		centerY = args.CENTER_Y,
		width = args.WIDTH,
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
			local v = self.tsls[leaderName];

			if (v ~= nil) then
				local i = self:__PlotIndex(v[1], v[2]);
				local pPlot = Map.GetPlotByIndex(i);

				if (pPlayer:IsMajor() and (pPlot:IsLake() or pPlot:IsMountain())) then 
					error("Can't place TSL for major civ");	-- have to throw exception
				else	-- log error
					if (pPlot:IsMountain()) then
						print("Mountain block TSL for ", leaderName); 
					elseif (pPlot:IsLake()) then
						print("Lake block TSL for ", leaderName); 
					else	-- o/w assign TSL
						pPlayer:SetStartingPlot(pPlot);
					end
				end
									
				print("Assigning TSL for ", leaderName .. " at index: " .. i); 
			end
		end
	end 
end
------------------------------------------------------------------------------
function AssignTrueStartingPlots:__PlotIndex(r, theta)
	local iX = self.centerX + __Round(r * math.cos(math.rad(theta)));
	local iY = self.centerY + __Round(r * math.sin(math.rad(theta)));

	return (iY * self.width + iX);		-- plot index from polar coord (deg)
end
------------------------------------------------------------------------------
function __Round(n)
	return math.floor(n + 0.5);
end
