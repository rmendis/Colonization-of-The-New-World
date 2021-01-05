-- NewWorldScenario
-- Author: blkbutterfly74
-- DateCreated: 1/25/2018 7:15:01 AM
--------------------------------------------------------------

include "MapEnums"

local function OnGameTurnStarted( player )
	local currentTurn = Game.GetCurrentGameTurn();
	
	print ("OnGameTurnStarted: Turn " .. tostring(currentTurn));

	-- reset environment scores
	local aPlayers = PlayerManager.GetAliveMajors();
	for _, pPlayer in ipairs(aPlayers) do
		pPlayer:SetScoringScenario1(0);
	end

	local NO_IMPROVEMENT = -1;
	g_iW, g_iH = Map.GetGridSize();
	for i = 0, (g_iW * g_iH) - 1, 1 do
		pPlot = Map.GetPlotByIndex(i);
		local featureType = pPlot:GetFeatureType();
		local improvementType = pPlot:GetImprovementType();

		-- count unimproved rainforest, forest + marsh
		if (improvementType == NO_IMPROVEMENT) then
			if (featureType == g_FEATURE_JUNGLE or featureType == g_FEATURE_FOREST or featureType == g_FEATURE_MARSH) then
				local eOwner = pPlot:GetOwner();

				if (eOwner ~= nil and eOwner ~= -1) then
				local pPlayer = Players[eOwner];

					if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
						local score = pPlayer:GetScoringScenario1();
						pPlayer:SetScoringScenario1(score + 1);
					end
				end
			end
		end
	end
end
GameEvents.OnGameTurnStarted.Add(OnGameTurnStarted);

--------------------------------------------------------------

local function OnNationalParkAdded(ePlayer, arg1, arg2)
	print("National Park added");

	local pPlayer = Players[ePlayer];

	-- increment national parks count
	local score = pPlayer:GetScoringScenario2();
	pPlayer:SetScoringScenario2(score + 1);
end
Events.NationalParkAdded.Add(OnNationalParkAdded);

--------------------------------------------------------------

--[[
function OnGreatWorkCreated(playerID, creatorID, cityX, cityY, buildingID, iGreatWorkIndex)

	print("Great Work added ".. playerID);

	local pPlayer = Players[playerID];
	local score = pPlayer:GetScoringScenario3();
	pPlayer:SetScoringScenario3(score + 100);		-- artifacts = 100 VP
end
Events.GreatWorkCreated.Add(OnGreatWorkCreated);
--]]