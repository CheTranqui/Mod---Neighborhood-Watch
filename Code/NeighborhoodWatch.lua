NBWatch = {}
NBWatch.StringIDBase = 987234920

function OnMsg.NewMapLoaded()
	NWColonistsHaveArrived = false
end

function OnMsg.SelectionChange()
	if IsKindOfClasses(SelectedObj, "Colonist") then
		NWVariableSweep()
		NWColonistArrivedCheck()
	end
end

function NWColonistArrivedCheck()
	if UICity.labels.Colonist ~= nil then
		NWMainNotification()
	end
	if NWColonistsHaveArrived == true then
		NWColonistsHaveArrived = false
		NWMainNotification()
	end
end

function OnMsg.ColonistArrived()
	NWColonistsHaveArrived = true
	NWVariableSweep()
	NWColonistArrivedCheck()
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
		NWDeaderReasonChange = T{NBWatch.StringIDBase + 1, "Suffocation"}
	elseif NWDeaderReason == "StatusEffect_Suffocating" then
		NWDeaderReasonChange = T{NBWatch.StringIDBase + 1, "Suffocation"}		
	else
		NWDeaderReasonChange = NWDeader.dying_reason
	end
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWVIPDeathNotice",
			T{NBWatch.StringIDBase + 2, "VIP has died!"},
			T{NBWatch.StringIDBase + 3, "<NWDeaderName> has died of <NWDeaderReason>"},
			"UI/Icons/Notifications/placeholder_2.tga",
			NWVIPCenterOnDeader,
			{   NWDeaderName = NWDeader.name,
				NWDeaderReason = NWDeaderReasonChange,
				expiration = 75000,
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
			T{NBWatch.StringIDBase + 4, "Neighborhood Watch"},
			T{NBWatch.StringIDBase + 5, "Click here to manage VIPs"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			NWTrackVIPColonistCheck,
			{
				expiration = 100000,
				priority = "Normal",
			})
	end)
end

function NWTrackVIPColonistCheck()
	if IsKindOfClasses(SelectedObj, "Colonist") then  -- probes object to confirm that a colonist is selected
-- need to check the table here to make sure that the selected colonist is not already accounted for in the table
		NWColonistSelected = true
		NWTempVIP = SelectedObj
		NWVIP = NWTempVIP
		NWTempVIPName = NWTempVIP.name  -- borrows colonist name
		NWTrackVIPTempText = T{NBWatch.StringIDBase + 6, "Add selected colonist (<NWNewVIPName>) as VIP", NWNewVIPName = NWTempVIPName}
	else
		NWColonistSelected = false
		NWTrackVIPTempText = T{NBWatch.StringIDBase + 7, "Cannot award VIP status:   No colonist selected"}
		NWTempVIP = nil
		NWTempVIPName = nil
	end  -- if statement
	NWShowThisColonistInfo() -- checks if NWVIPList has any entries or not
end

function NWCheckForEmptyList()
	if NWLivingVIPs == true then
		if g_NWVIPList == nil then
			g_NWVIPList = {}
			NWPopupLine1 = T{NBWatch.StringIDBase + 8, "No VIPs yet declared <newline>"}
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
			NWPopupLine1 = T{NBWatch.StringIDBase + 9, "No VIPs have yet fallen <newline>"}
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
			NWPopupLine1 = T{NBWatch.StringIDBase + 10, "VIP not yet declared <newline>"}
		end
	else
		if g_NWDeaderList[NWNewListKey] ~= nil then
			NWVIP = g_NWDeaderList[NWNewListKey]
			NWVIP1 = NWVIP
			NWPopupLine1 = NWGetVIPStats()
		else
			NWPopupLine1 = T{NBWatch.StringIDBase + 11, "No fallen VIP to honor <newline>"}
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
	NWVIPInfoString = T{NBWatch.StringIDBase + 12, "VIP not yet declared"}
	else
		if NWLivingVIPs == true then
			NWAgeCheck = T{NBWatch.StringIDBase + 13, "Age:"}
			NWVIPAgeDeclared = NWVIP.age
			if NWVIP.dome == false then
				NWVIPDomeDeclared = T{NBWatch.StringIDBase + 14, "is domeless."}
			else
				NWVIPDomeDeclared = T{NBWatch.StringIDBase + 15, "lives in <NWVIPDomeHome>.", NWVIPDomeHome = NWVIP.dome.name}
			end
			if NWVIP.workplace == false then
				NWVIPWorkDeclared = T{NBWatch.StringIDBase + 16, "Job: unemployed."}
			else
				NWVIPWorkDeclared = T{NBWatch.StringIDBase + 17, "Job: <NWVIPWorkBuilding>.", NWVIPWorkBuilding = NWVIP.workplace.entity}
			end

		else -- NWLivingVIPs == false
			if NWVIP.age > NWVIP.death_age or NWVIP.age == NWVIP.death_age or NWVIP.dying == true then
				NWAgeCheck = T{NBWatch.StringIDBase + 18, "died at age:"}
				if NWVIP.dying_reason == "StatusEffect_Suffocating_Outside" then
					NWDeadReasonChange = T{NBWatch.StringIDBase + 1, "Suffocation"}
				else
					NWDeadReasonChange = NWVIP.dying_reason
				end
			NWVIPAgeDeclared = T{NBWatch.StringIDBase + 19, "<NWDeadAge> of <NWDeadReason>", NWDeadAge = NWVIP.death_age, NWDeadReason = NWDeadReasonChange}
			elseif NWVIP.age == NWVIP.death_age then
				NWAgeCheck = T{NBWatch.StringIDBase + 18, "died at age:"}
				NWVIPAgeDeclared = NWVIP.death_age
			end
			NWVIPWorkDeclared = ""
			NWVIPDomeDeclared = ""
		end
	NWVIPSpecDeclared = NWVIP.specialist
	NWVIPInfoString = T{NBWatch.StringIDBase + 20, "<newline><newline> <NWVIPName> <NWVIPDome>  <NWVIPWork>  <NWAge> <NWVIPAge>. Spec: <NWVIPSpec>.", NWVIPName = NWVIP.name, NWVIPDome = NWVIPDomeDeclared, NWVIPWork = NWVIPWorkDeclared, NWAge = NWAgeCheck, NWVIPAge = NWVIPAgeDeclared, NWVIPSpec = NWVIPSpecDeclared}
	end
	return NWVIPInfoString
end


function NWTrackVIPPopup()
	Sleep(5)
	IncomingListKey = NWListKey
	NWLivingVIPs = true
	NWCheckForEmptyList()
	NWFirstFourVIPImport = NWGetVIPPopupString()
	CreateRealTimeThread(function()
        params = {
			title = T{NBWatch.StringIDBase + 21, "VIP Management"},
            text = T{NBWatch.StringIDBase + 22, "Martian VIPs:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 VIPs' info
            choice1 = T{NBWatch.StringIDBase + 23, "Cycle through these VIPs"}, -- view and select each vip in order
            choice2 = T{NBWatch.StringIDBase + 24, "Show Next Page of VIPs"},
			choice3 = T{NBWatch.StringIDBase + 25, "View Records of the Honored Fallen"},
			choice4 = T{NBWatch.StringIDBase + 26, "Close"},
            image = "UI/Messages/colonists.tga",
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
	Sleep(5)
	IncomingListKey = NWListKey
	NWLivingVIPs = true
	NWCheckForEmptyList()
	NWFirstFourVIPImport = NWGetVIPPopupString()
	CreateRealTimeThread(function()
		Sleep(5)
        params = {
			title = T{NBWatch.StringIDBase + 21, "VIP Management"},
            text = T{NBWatch.StringIDBase + 22, "Martian VIPs:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 VIPs' info
            choice1 = T{NBWatch.StringIDBase + 23, "Cycle through these VIPs"}, -- view and select each vip in order
            choice2 = T{NBWatch.StringIDBase + 24, "Show Next Page of VIPs"},
			choice3 = T{NBWatch.StringIDBase + 25, "View Records of the Honored Fallen"},
			choice4 = T{NBWatch.StringIDBase + 26, "Close"},
            image = "UI/Messages/colonists.tga",
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
				expiration = 200000,
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
		Sleep(5)
        params = {
			title = T{NBWatch.StringIDBase + 27, "Martian Historical Records"},
            text = T{NBWatch.StringIDBase + 28, "The Honored Fallen:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 dead VIPs info
            choice1 = T{NBWatch.StringIDBase + 29, "Show Next Page of Fallen Martians"}, -- view and select each vip in order
            choice2 = T{NBWatch.StringIDBase + 30, "View List of Current VIPs"},
			choice3 = T{NBWatch.StringIDBase + 31, "Revoke VIP Status and Clear Lists"},
			choice4 = T{NBWatch.StringIDBase + 26, "Close"},
            image = "UI/Messages/death.tga",
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
			NWRevokeVIPPopup()
		elseif choice == 4 then
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
		Sleep(5)
        params = {
			title = T{NBWatch.StringIDBase + 27, "Martian Historical Records"},
            text = T{NBWatch.StringIDBase + 28, "The Honored Fallen:  <newline> <NWFirstFourVIPs>", NWFirstFourVIPs = NWFirstFourVIPImport}, -- displays up to 5 dead VIPs info
            choice1 = T{NBWatch.StringIDBase + 29, "Show Next Page of Fallen Martians"}, -- view and select each vip in order
            choice2 = T{NBWatch.StringIDBase + 30, "View List of Current VIPs"},
			choice3 = T{NBWatch.StringIDBase + 31, "Revoke VIP Status and Clear Lists"},
			choice4 = T{NBWatch.StringIDBase + 26, "Close"},
            image = "UI/Messages/death.tga",
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
			NWRevokeVIPPopup()
		elseif choice == 4 then
			NWVariableSweep()  -- closes window, frees up variables
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWRevokeVIPPopup()
	NWVIP = NWTempVIP
	CreateRealTimeThread(function()
		Sleep(5)
        params = {
			title = T{NBWatch.StringIDBase + 21, "VIP Management:"},
            text = T{NBWatch.StringIDBase + 32, "Choose from the options below to remove VIP status from individuals or from the records on a whole."},
            choice1 = T{NBWatch.StringIDBase + 33, "Removes this colonist (<PotentialVIPNameCheck>) from the list of VIPs", PotentialVIPNameCheck = NWVIP.name}, -- view and select each vip in order
            choice2 = T{NBWatch.StringIDBase + 34, "Reset list of VIPs only (leave the records of the dead)"},
			choice3 = T{NBWatch.StringIDBase + 35, "Reset both the lists of living VIPs and Honored Fallen"},
			choice4 = T{NBWatch.StringIDBase + 26, "Close"},
            image = "UI/Messages/statue.tga",
        } -- params
        local choice = WaitPopupNotification(false, params)
        if choice == 1 then
			NWRevokeOneVIP()  -- opens next page of deaders
		elseif choice == 2 then
			NWRevokeAllVIP()  -- opens up first page of living VIPs
		elseif choice == 3 then
			NWRevokeAllVIP()
			NWRevokeDeaders()
		elseif choice == 4 then
			NWVariableSweep()  -- closes window, frees up variables
        end -- if statement
    end ) -- CreateRealTimeThread
end -- function end

function NWRevokeOneVIP()
	for k, v in ipairs(g_NWVIPList) do
		if v == NWVIP then
			table.remove(g_NWVIPList, k)
			NWRevokeVIPNotification()
		break
		end
	end
end


function NWRevokeVIPNotification()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWRevokeVIPNotification",
			T{NBWatch.StringIDBase + 36, "VIP status has been revoked"},
			T{NBWatch.StringIDBase + 37, "<NWRevokedVIPName> is no longer a VIP"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			false,
			{   NWRevokedVIPName = NWVIP.name,
				expiration = 25000,
				priority = "Normal",
			})
	end)
end

function NWRevokeAllVIP()
	for k in pairs (g_NWVIPList) do
		g_NWVIPList[k] = nil
	end
	NWRevokeListDone = T{NBWatch.StringIDBase + 38, "VIP List has"}
	NWRevokeAllConfirmation()
	NWVariableSweep()
end

function NWRevokeAllConfirmation()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWTrackVIP",
			T{NBWatch.StringIDBase + 4, "Neighborhood Watch"},
			T{NBWatch.StringIDBase + 39, "<NWRevokeListConfirmation> been reset"},
			NW_mod_dir.."UI/NWVIPNotificationIcon.tga",
			NWTrackVIPColonistCheck,
			{
				NWRevokeListConfirmation = NWRevokeListDone,
				expiration = 25000,
				priority = "Normal",
			})
	end)
end

function NWRevokeDeaders()
	for k in pairs (g_NWDeaderList) do
		g_NWDeaderList[k] = nil
	end
	NWRevokeListDone = T{NBWatch.StringIDBase + 40, "Both lists have"}
	NWRevokeAllConfirmation()
	NWVariableSweep()
end

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
	NWCheckForEmptyList()
	NWVIP = NWTempVIP
	NWLivingVIPs = true
	if NWColonistSelected then
		NWGetThisColonistStats = NWGetVIPStats()
	else
		NWGetThisColonistStats = T{NBWatch.StringIDBase + 41, "No colonist selected.<newline><newline>Click on a colonist to select them, then reopen this dialogue to add them as a VIP."}
	end
	if NWTempVIPName == nil then 
		NWImportTrackVIPC1Text = T{NBWatch.StringIDBase + 42, "Select a colonist to add them as a VIP"}
--		NWShowThisColRenameCheck = T{NBWatch.StringIDBase + 43, "Cannot rename colonist - none selected"}
	else
		NWImportTrackVIPC1Text = NWTrackVIPTempText
--		NWShowThisColRenameCheck = T{NBWatch.StringIDBase + 44, "Rename selected colonist"}
	end
	CreateRealTimeThread(function()
       params = {
			title = T{NBWatch.StringIDBase + 45, "A Potential VIP:"},
	        text = T{NBWatch.StringIDBase + 46, "A Potential VIP:  <newline> <NWThisColonistStatShow>", NWThisColonistStatShow = NWGetThisColonistStats}, -- displays colonists' info
	        choice1 = T{"<NWShowThisColonistC1Text>", NWShowThisColonistC1Text = NWImportTrackVIPC1Text}, -- choice1 = add this colonist to the table
--			choice2 = T{"<NWShowThisColRenameChoice>", NWShowThisColRenameChoice = NWShowThisColRenameCheck},
            choice2 = T{NBWatch.StringIDBase + 30, "View List of Current VIPs"},  -- shows VIP lists
			choice3 = T{NBWatch.StringIDBase + 25, "View Records of the Honored Fallen"},  -- Shows obituaries
			choice4 = T{NBWatch.StringIDBase + 26, "Close"},
			image = "UI/Messages/colonists.tga",
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

function NWTrackVIPAdd()
	if g_NWVIPList[1] == nil then
		g_NWVIPList = {}
		table.insert(g_NWVIPList, NWVIP)
		NWConfirmAddition()
	else
		for k, v in ipairs(g_NWVIPList) do
			if v == NWVIP then
				NWConfirmExisting()
				NWFoundPotentialVIP = true
			break
			end
		end
		if NWFoundPotentialVIP == false then
			table.insert(g_NWVIPList, NWVIP)
			NWConfirmAddition()
		end
		NWFoundPotentialVIP = false
	end
end

function NWConfirmExisting()
	NW_mod_dir = Mods["gzhD4pQ"]:GetModRootPath()
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification("NWTrackVIP",
			T{NBWatch.StringIDBase + 47, "<NWNewVIPName> is already a VIP!"},
			T{NBWatch.StringIDBase + 5, "Click here to manage VIPs"},
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
			T{NBWatch.StringIDBase + 48, "<NWNewVIPName> is now a VIP!"},
			T{NBWatch.StringIDBase + 5, "Click here to manage VIPs"},
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
	NWVIP1 = nil
	NWVIP2 = nil
	NWVIP3 = nil
	NWVIP4 = nil
	NWVIP5 = nil
	NWVIPInfoString = nil
	NWPopupLine1 = nil
	NWPopupLine2 = nil
	NWPopupLine3 = nil
	NWPopupLine4 = nil
	NWPopupLine5 = nil	
end

function OnMsg.PersistSave(data)
	data["g_NWVIPListSave"] = g_NWVIPList
	data["g_NWDeaderListSave"] = g_NWDeaderList
end

function OnMsg.PersistLoad(data)
	g_NWVIPList = data["g_NWVIPListSave"]
	g_NWDeaderList = data["g_NWDeaderListSave"]
end
