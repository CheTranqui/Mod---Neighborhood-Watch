function OnMsg.NewHour() -- in the final release this will be "OnMsg.NewDay()"
	NWVariableSweep()
	NWMainNotification()
end

function OnMsg.RocketLanded(rocket)
	NWVariableSweep()
	NWMainNotification()
end

function OnMsg.ColonistDied(colonist, reason)
	NWDeader = colonist
	NWDeaderReason = reason
	NWBringOutYourDead()
end

function NWBringOutYourDead()
	if g_NWVIPList[1] ~= nil then
		for k, v in ipairs(g_NWVIPList) do
			if v == NWDeader then
				table.remove(g_NWVIPList, k)
				NWVIPDeathNotification()
				if g_NWDeaderList == nil then
					g_NWDeaderList = {}
				end
				table.insert(g_NWDeaderList, NWDeader)
			break
			end
		end
	end
end

function NWVIPDeathNotification()
	if NWDeaderReason == "StatusEffect_Suffocating_Outside" then
		NWDeaderReasonChange = "Suffocation"
	else
		NWDeaderReasonChange = NWDeader.dying_reason
	end
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWVIPDeathNotice",
			T{"VIP has died!"},
			T{"<NWDeaderName> has died of <NWDeaderReason>"},
			"UI/Icons/Notifications/placeholder_2.tga",
			NWVIPCenterOnDeader,
			{   NWDeaderName = NWDeader.name,
				NWDeaderReason = NWDeaderReasonChange,
				expiration = 150000,
				priority = "Important",
			})
	end)
end

function NWVIPCenterOnDeader()
	ViewAndSelectObject(NWDeader)
end

function NWMainNotification()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWTrackVIP",
			T{"Neighborhood Watch"},
			T{"Click here to manage VIPs"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			NWTrackVIPColonistCheck,
			{
				expiration = 200000,
				priority = "Normal",
			})
	end)
end


function NWTrackVIPColonistCheck()
	if IsKindOfClasses(SelectedObj, "Colonist") then  -- probes object to confirm that a colonist is selected
-- need to check the table here to make sure that the selected colonist is not already accounted for in the table
		NWTempVIP = SelectedObj
		NWTempVIPName = NWTempVIP.name  -- borrows colonist name
		NWTrackVIPTempText = T{"Add selected colonist (<NWNewVIPName>) as VIP", NWNewVIPName = NWTempVIPName}
	else
		NWTrackVIPTempText = "Cannot award VIP status:   No colonist selected"
		NWTempVIP = nil
		NWTempVIPName = nil
	end  -- if statement
	NWShowThisColonistInfo() -- checks if NWVIPList has any entries or not
end

function NWCheckForEmptyList()
	if NWLivingVIPs == true then
		if g_NWVIPList == nil then
			g_NWVIPList = {}
			NWPopupLine1 = "No VIPs yet declared <newline>"
			NWPopupLine2 = "<newline>"
			NWPopupLine3 = "<newline>"
			NWPopupLine4 = "<newline>"
			NWPopupLine5 = "<newline>"
		else
		NWGetFirstVIP()
		end
	else -- if NWLivingVIPs == false
		if g_NWDeaderList == nil then
			g_NWDeaderList = {}
			NWPopupLine1 = "No VIPs have yet fallen <newline>"
			NWPopupLine2 = "<newline>"
			NWPopupLine3 = "<newline>"
			NWPopupLine4 = "<newline>"
			NWPopupLine5 = "<newline>"
		else
		NWGetFirstVIP()
		end
	end
end

function NWGetFirstVIP()
	NWNewListKey = NWListKey
	if NWLivingVIPs == true then
		if g_NWVIPList[NWNewListKey] ~= nil then
			NWVIP = g_NWVIPList[NWNewListKey]
			NWVIP1 = NWVIP
			NWPopupLine1 = NWGetVIPStats()
		else
			NWPopupLine1 = "VIP not yet declared <newline>"
		end
	else
		if g_NWDeaderList[NWNewListKey] ~= nil then
			NWVIP = g_NWDeaderList[NWNewListKey]
			NWVIP1 = NWVIP
			NWPopupLine1 = NWGetVIPStats()
		else
			NWPopupLine1 = "No fallen VIP to honor <newline>"
		end
	end
	NWGetSecondVIP()
end

function NWGetSecondVIP()
	NWNewListKey = NWListKey + 1
	if NWLivingVIPs == true then
		if g_NWVIPList[NWNewListKey] ~= nil then
			NWVIP = g_NWVIPList[NWNewListKey]
			NWVIP2 = NWVIP
			NWPopupLine2 = NWGetVIPStats()
		else
		NWPopupLine2 = ""
		end
	else
		if g_NWDeaderList[NWNewListKey] ~= nil then
			NWVIP = g_NWDeaderList[NWNewListKey]
			NWVIP2 = NWVIP
			NWPopupLine2 = NWGetVIPStats()
		else
		NWPopupLine2 = ""
		end
	end
	NWListKey = NWNewListKey
	NWGetThirdVIP()
end

function NWGetThirdVIP()
	NWNewListKey = NWListKey + 1
	if NWLivingVIPs == true then
		if g_NWVIPList[NWNewListKey] ~= nil then
			NWVIP = g_NWVIPList[NWNewListKey]
			NWVIP3 = NWVIP
			NWPopupLine3 = NWGetVIPStats()
		else
		NWPopupLine3 = ""
		end
	else
		if g_NWDeaderList[NWNewListKey] ~= nil then
			NWVIP = g_NWDeaderList[NWNewListKey]
			NWVIP3 = NWVIP
			NWPopupLine3 = NWGetVIPStats()
		else
		NWPopupLine3 = ""
		end
	end
	NWListKey = NWNewListKey
	NWGetFourthVIP()
end

function NWGetFourthVIP()
	NWNewListKey = NWListKey + 1
	if NWLivingVIPs == true then
		if g_NWVIPList[NWNewListKey] ~= nil then
			NWVIP = g_NWVIPList[NWNewListKey]
			NWVIP4 = NWVIP
			NWPopupLine4 = NWGetVIPStats()
		else
		NWPopupLine4 = ""
		end
	else
		if g_NWDeaderList[NWNewListKey] ~= nil then
			NWVIP = g_NWDeaderList[NWNewListKey]
			NWVIP4 = NWVIP
			NWPopupLine4 = NWGetVIPStats()
		else
		NWPopupLine4 = ""
		end
	end
	NWListKey = NWNewListKey
	NWGetFifthVIP()
end

function NWGetFifthVIP()
	NWNewListKey = NWListKey + 1
	if NWLivingVIPs == true then
		if g_NWVIPList[NWNewListKey] ~= nil then
			NWVIP = g_NWVIPList[NWNewListKey]
			NWVIP5 = NWVIP
			NWPopupLine5 = NWGetVIPStats()
		else
		NWPopupLine5 = ""
		end
	else
		if g_NWDeaderList[NWNewListKey] ~= nil then
			NWVIP = g_NWDeaderList[NWNewListKey]
			NWVIP5 = NWVIP
			NWPopupLine5 = NWGetVIPStats()
		else
		NWPopupLine5 = ""
		end
	end
	NWListKey = NWNewListKey
	NWGetVIPPopupString()
end


function NWGetVIPPopupString()
-- provides the format for VIP presentation within NWTrackVIPPopup
	NWFirstFourVIPDesc = T{"<NWPL1> <NWPL2> <NWPL3> <NWPL4> <NWPL5>", NWPL1 = NWPopupLine1, NWPL2 = NWPopupLine2, NWPL3 = NWPopupLine3, NWPL4 = NWPopupLine4, NWPL5 = NWPopupLine5}
	return NWFirstFourVIPDesc
end

function NWGetVIPStats()
	if NWVIP == nil then
	NWVIPInfoString = "VIP not yet declared"
	else
		if NWLivingVIPs == true then
			NWAgeCheck = "Age:"
			NWVIPAgeDeclared = NWVIP.age
			if NWVIP.dome == false then
				NWVIPDomeDeclared = "is domeless."
			else
				NWVIPDomeDeclared = T{"lives in <NWVIPDomeHome>.", NWVIPDomeHome = NWVIP.dome.name}
			end
			if NWVIP.workplace == false then
				NWVIPWorkDeclared = "Job: unemployed."
			else
				NWVIPWorkDeclared = T{"Job:  Shift <NWVIPWorkShift> at the local <NWVIPWorkBuilding>.", NWVIPWorkShift = NWVIP.workplace_shift, NWVIPWorkBuilding = NWVIP.workplace.palette}
			end

		else -- NWLivingVIPs == false
			if NWVIP.age > NWVIP.death_age or NWVIP.age == NWVIP.death_age or NWVIP.dying == true then
				NWAgeCheck = "died at age:"
				if NWVIP.dying_reason == "StatusEffect_Suffocating_Outside" then
					NWDeadReasonChange = "Suffocation"
				else
					NWDeadReasonChange = NWVIP.dying_reason
				end
			NWVIPAgeDeclared = T{"<NWDeadAge> of <NWDeadReason>", NWDeadAge = NWVIP.death_age, NWDeadReason = NWDeadReasonChange}
			elseif NWVIP.age == NWVIP.death_age then
				NWAgeCheck = "died at age:"
				NWVIPAgeDeclared = NWVIP.death_age
			end
			NWVIPWorkDeclared = ""
			NWVIPDomeDeclared = ""
		end
	NWVIPSpecDeclared = NWVIP.specialist
	NWVIPInfoString = T{"<newline><newline> <NWVIPName> <NWVIPDome>  <NWVIPWork>  <NWAge> <NWVIPAge>. Spec: <NWVIPSpec>.", NWVIPName = NWVIP.name, NWVIPDome = NWVIPDomeDeclared, NWVIPWork = NWVIPWorkDeclared, NWAge = NWAgeCheck, NWVIPAge = NWVIPAgeDeclared, NWVIPSpec = NWVIPSpecDeclared}
	end
	return NWVIPInfoString
end


function NWTrackVIPPopup()
	IncomingListKey = NWListKey
	NWLivingVIPs = true
	NWCheckForEmptyList()
	NWFirstFourVIPImport = NWGetVIPPopupString()
	CreateRealTimeThread(function()
        params = {
			title = T{"VIP Management"},
            text = T{"Martian VIPs:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 VIPs' info
            choice1 = T{"Cycle through these VIPs"}, -- view and select each vip in order
            choice2 = T{"Show Next Page of VIPs"},
			choice3 = T{"View Records of the Honored Fallen"},
			choice4 = T{"Close"},
            image = "UI/Messages/research.tga",
        } -- params
        local choice = WaitPopupNotification(false, params)
        if choice == 1 then
			NWZoomIndex = 1 -- starts the NWZoomIndex at the 1st VIP listed here.
			NWCycleTheseVIPs()  -- opens a notification icon to cycle through the listed VIPs
		elseif choice == 2 then
			NWNewListKey = IncomingListKey + 5
			NWListKey = NWNewListKey
			NWTrackVIPPopup2()  -- opens a new popup with next 4 colonists
		elseif choice == 3 then
			NWListKey = 1
			NWObituariesPopup()  -- shows dead VIPs
		elseif choice == 4 then
			NWVariableSweep()  -- closes window, frees up variables
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWTrackVIPPopup2()
	IncomingListKey = NWListKey
	NWLivingVIPs = true
	NWCheckForEmptyList()
	NWFirstFourVIPImport = NWGetVIPPopupString()
	CreateRealTimeThread(function()
        params = {
			title = T{"VIP Management"},
            text = T{"Martian VIPs:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 VIPs' info
            choice1 = T{"Cycle through these VIPs"}, -- view and select each vip in order
            choice2 = T{"Show Next Page of VIPs"},
			choice3 = T{"View Records of the Honored Fallen"},
			choice4 = T{"Close"},
            image = "UI/Messages/research.tga",
        } -- params
        local choice = WaitPopupNotification(false, params)
        if choice == 1 then
			NWZoomIndex = 1 -- starts the NWZoomIndex at the 1st VIP listed here.
			NWCycleTheseVIPs()  -- opens a notification icon to cycle through the listed VIPs
		elseif choice == 2 then
			NWNewListKey = IncomingListKey + 5
			NWListKey = NWNewListKey
			NWTrackVIPPopup()  -- opens a new popup with next 4 colonists
		elseif choice == 3 then
			NWListKey = 1
			NWObituariesPopup()  -- shows dead VIPs
		elseif choice == 4 then
			NWVariableSweep()  -- closes window, frees up variables
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWCycleTheseVIPs()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWCycleVIPs",
			T{"View VIPs"},
			T{"Click here to cycle through VIPs"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			NWZoomIndexer,
			{
				expiration = 500000,
				priority = "Normal",
			})
	end)
end

function NWObituariesPopup()
	IncomingListKey = NWListKey
	NWLivingVIPs = false
	NWCheckForEmptyList()
	NWFirstFourVIPImport = NWGetVIPPopupString()
	CreateRealTimeThread(function()
        params = {
			title = T{"Martian Historical Records"},
            text = T{"The Honored Fallen:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 dead VIPs info
            choice1 = T{"Show Next Page of Fallen Martians"}, -- view and select each vip in order
            choice2 = T{"View List of Current VIPs"},
			choice3 = T{"Close"},
            image = "UI/Messages/research.tga",
        } -- params
        local choice = WaitPopupNotification(false, params)
        if choice == 1 then
			NWNewListKey = IncomingListKey + 5 -- forwards our list key to the next set of 5.
			NWListKey = NWNewListKey
			NWObituariesPopup2()  -- opens next page of deaders
		elseif choice == 2 then
			NWListKey = 1
			NWTrackVIPPopup()  -- opens up first page of living VIPs
		elseif choice == 3 then
			NWVariableSweep()  -- closes window, frees up variables
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWObituariesPopup2()
	IncomingListKey = NWListKey
	NWLivingVIPs = false
	NWCheckForEmptyList()
	NWFirstFourVIPImport = NWGetVIPPopupString()
	CreateRealTimeThread(function()
        params = {
			title = T{"Martian Historical Records"},
            text = T{"The Honored Fallen:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 dead VIPs info
            choice1 = T{"Show Next Page of Fallen Martians"}, -- view and select each vip in order
            choice2 = T{"View List of Current VIPs"},
			choice3 = T{"Close"},
            image = "UI/Messages/research.tga",
        } -- params
        local choice = WaitPopupNotification(false, params)
        if choice == 1 then
			NWNewListKey = IncomingListKey + 5 -- forwards our list key to the next set of 5.
			NWListKey = NWNewListKey
			NWObituariesPopup()  -- opens next page of deaders
		elseif choice == 2 then
			NWListKey = 1
			NWTrackVIPPopup()  -- opens up first page of living VIPs
		elseif choice == 3 then
			NWVariableSweep()  -- closes window, frees up variables
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWZoomIndexer()
	if NWZoomIndex == 2 then
		NWZoomSecond()
	elseif NWZoomIndex == 3 then
		NWZoomThird()
	elseif NWZoomIndex == 4 then
		NWZoomFourth()
	elseif NWZoomIndex == 5 then
		NWZoomFifth()
	else
	NWZoomIndex = 1
	NWZoomFirst()
	end
	NWNewZoomIndex = NWZoomIndex + 1
	NWZoomIndex = NWNewZoomIndex
end
	
function NWZoomFirst()	
	ViewAndSelectObject(NWVIP1)
end

function NWZoomSecond()	
	ViewAndSelectObject(NWVIP2)
end

function NWZoomThird()	
	ViewAndSelectObject(NWVIP3)
end

function NWZoomFourth()	
	ViewAndSelectObject(NWVIP4)
end

function NWZoomFifth()	
	ViewAndSelectObject(NWVIP5)
end

function NWShowThisColonistInfo()
	NWVIP = NWTempVIP
	NWGetThisColonistStats = NWGetVIPStats()
	if NWGetThisColonistStats == "VIP not yet declared" then
		NWGetThisColonistStats = "No colonist selected"
	end
	if NWTempVIPName == nil then 
		NWImportTrackVIPC1Text = "Select a colonist to add them as a VIP"
		NWShowThisColRenameCheck = "Cannot rename colonist - none selected"
	else
		NWImportTrackVIPC1Text = NWTrackVIPTempText
		NWShowThisColRenameCheck = "Rename selected colonist"
	end
	CreateRealTimeThread(function()
       params = {
			title = T{"A Potential VIP:"},
	        text = T{"A Potential VIP:  <newline> <NWThisColonistStatShow>", NWThisColonistStatShow = NWGetThisColonistStats}, -- displays colonists' info
	        choice1 = T{"<NWShowThisColonistC1Text>", NWShowThisColonistC1Text = NWImportTrackVIPC1Text}, -- choice1 = add this colonist to the table
--			choice2 = T{"<NWShowThisColRenameChoice>", NWShowThisColRenameChoice = NWShowThisColRenameCheck},
            choice2 = T{"View List of Current VIPs"},  -- shows VIP lists
			choice3 = T{"View Records of the Honored Fallen"},  -- Shows obituaries
			choice4 = T{"Close"},
			image = "UI/Messages/research.tga",
       } -- close params
       local choice = WaitPopupNotification(false, params)
       if choice == 1 then
			NWTrackVIPAdd()  -- adds colonist to table
--		elseif choice == 2 then
--			NWRenameChosenColonist() -- Opens window to rename current colonist
		elseif choice == 2 then
			NWListKey = 1
			NWTrackVIPPopup() -- opens living VIP list
--			NWVIPCycle()  create a notification that when clicked cycles through VIPs
		elseif choice == 3 then
			NWListKey = 1
			NWObituariesPopup()  -- opens deaders list
		elseif choice == 4 then
			NWVariableSweep()
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWRenameChosenColonist()
	NWVIP:ShowRenameUI()
end

function NWShowNextFourVIPs()
	NWTestVar = "Testing, NWShowNextFourVIPs"
	return NWTestVar
end

function NWTrackVIPAdd()
	if g_NWVIPList[1] == nil then
		table.insert(g_NWVIPList, NWTempVIP)
	else
		for k, v in ipairs(g_NWVIPList) do
			if v == NWTempVIP then
				NWConfirmExisting()
			else
				table.insert(g_NWVIPList, NWTempVIP)
				NWConfirmAddition()
			break
			end
		end
	end
end

function NWConfirmExisting()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWTrackVIP",
			T{"<NWNewVIPName> is already a VIP!"},
			T{"Click here to manage VIPs"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			NWTrackVIPColonistCheck,
			{   NWNewVIPName = NWTempVIP.name,
				expiration = 100000,
				priority = "Normal",
			})
	end)
end

function NWConfirmAddition()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
--	NW_mod_dir = debug.getinfo(1, "S").source:sub(2, -27)
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWTrackVIP",
			T{"<NWNewVIPName> is now a VIP!"},
			T{"Click here to manage VIPs"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			NWTrackVIPColonistCheck,
			{   NWNewVIPName = NWTempVIP.name,
				expiration = 100000,
				priority = "Normal",
			})
	end)
end

function NWVariableSweep()
	NWVIP = nil
	NWPopupLine1 = nil
	NWPopupLine2 = nil
	NWPopupLine3 = nil
	NWPopupLine4 = nil
	NWTempVIP = nil
	NWTempVIPName = nil
	NWSelectedVIP = nil
	NWSelectedVIPLine = nil
	NWTrackVIPC1Text = nil
	NWTrackVIPTempText = nil
	NWFirstFourVIPDesc = nil
	NWFirstFourVIPs = nil
	NWVIPInfoString = nil
	NWAgeCheck = nil
	NWVIPAgeDeclared = nil
	NWVIPWorkDeclared = nil
	NWVIPDomeDeclared = nil
	NWVIPName = nil
	NWVIPDome = nil
	NWVIPWork = nil
	NWAge = nil
	NWVIPAge = nil
	NWVIPName = nil
	NWListKey = 0
end

function OnMsg.PersistSave(data)
	data["g_NWVIPListSave"] = g_NWVIPList
	data["g_NWDeaderListSave"] = g_NWDeaderList
end

function OnMsg.PersistLoad(data)
	g_NWVIPList = data["g_NWVIPListSave"]
	g_NWDeaderList = data["g_NWDeaderListSave"]
end
