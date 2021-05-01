-- WorldRankings
-- Author: blkbutterfly74
-- DateCreated: 2/3/2018 2:05:38 PM
-- ===========================================================================
--	Contains scaffolding for WorldRankings and other Right Anchored screens
-- ===========================================================================
include("WorldRankings");

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
SIZE_HEADER_MAX_Y = 310;
SIZE_SCORE_ITEM_DETAILS = 150;

-- ===========================================================================
--	SCREEN VARIABLES
-- ===========================================================================
local m_GenericIM:table = InstanceManager:new("ScoreInstance", "ButtonBG", Controls.GenericViewStack);
local m_GenericTeamIM:table = InstanceManager:new("ScoreTeamInstance", "ButtonFrame", Controls.GenericViewStack);

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function ViewScore()
	ResetState(ViewScore);
	Controls.ScoreView:SetHide(false);

	ChangeActiveHeader("VICTORY_SCORE", m_GenericHeaderIM, Controls.ScoreViewHeader);
	local subTitle:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_CONDITION", Game.GetMaxGameTurns());
	PopulateGenericHeader(RealizeScoreStackSize, SCORE_TITLE, subTitle, SCORE_DETAILS, ICON_GENERIC);

	-- Gather data
	local scoreData:table = GatherScoreData();

	-- Sort teams
	table.sort(scoreData, function(a, b) return a.TeamScore > b.TeamScore; end);

	g_ScoreIM:ResetInstances();
	g_ScoreTeamIM:ResetInstances();

	for i, teamData in ipairs(scoreData) do
		if #teamData.PlayerData > 1 then
			-- Sort players before displaying
			table.sort(teamData.PlayerData, function(a, b) return a.PlayerScore> b.PlayerScore; end);

			-- Display as team
			PopulateScoreTeamInstance(g_ScoreTeamIM:GetInstance(), teamData);
		elseif #teamData.PlayerData > 0 and teamData.PlayerData[1].PlayerID < 9 then
			-- Display as single civ
			PopulateScoreInstance(g_ScoreIM:GetInstance(), teamData.PlayerData[1]);
		end
	end

	RealizeScoreStackSize();
end

-- ===========================================================================
--	OVERRIDE
-- ===========================================================================
function ViewGeneric(victoryType:string)
	ResetState(function() ViewGeneric(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
	PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, ICON_GENERIC);

	local genericData:table = GatherGenericData();

	table.sort(genericData, function(a, b) return a.TeamScore > b.TeamScore; end);

	m_GenericIM:ResetInstances();
	m_GenericTeamIM:ResetInstances();

	for i, teamData in ipairs(genericData) do
		if #teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(m_GenericTeamIM:GetInstance(), teamData, victoryType);
		elseif #teamData.PlayerData > 0 and teamData.PlayerData[1].PlayerID < 9 then
			PopulateGenericInstance(m_GenericIM:GetInstance(), teamData.PlayerData[1], victoryType, false);
		end
	end

	RealizeGenericStackSize();
end

function GatherGenericData()
	local data:table = {};

	local iBuildingIndex = GameInfo.Buildings["BUILDING_SANCTUARY"].Index;

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			local teamData:table = { TeamID = teamID, PlayerData = {}, TeamScore = 0 };

			-- Add players
			for i, playerID in ipairs(team) do
				if IsAliveAndMajor(playerID) then
					local pPlayer:table = Players[playerID];
					local playerData:table = { PlayerID = playerID, PlayerScore = Players[playerID]:GetStats():GetNumBuildingsOfType(iBuildingIndex) };
					teamData.TeamScore = teamData.TeamScore + playerData.PlayerScore;
					table.insert(teamData.PlayerData, playerData);
				end
			end

			-- Only add teams with at least one living, major player
			if #teamData.PlayerData > 0 then
				table.insert(data, teamData);
			end
		end
	end

	return data;
end

function PopulateGenericInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);

	instance.Score:SetText(playerData.PlayerScore .. "/15");
	
	instance.ButtonBG:SetSizeY(SIZE_SCORE_ITEM_DEFAULT);
	instance.Details:SetHide(true);
end

-- ===========================================================================
-- OVERRIDES
-- ===========================================================================
function ShouldShowOverall()
	return false;
end

function ForceShowScore()
	return true;
end