ESX = nil

local name = ''
local exit = ''
local label = '?'
local inside = ''
local outside = ''
local ipl = ''
local isRoom = ''
local roommenu = ''
local price = '?'
local entering = ''
local entrer = ''
local isSingle = ''
local debug = true -- debug mode
local VisiterOrNot = false
local IsOpenMenu = false
local selectedItemIndex = 1
local changeIndex = 0
local items = { "Retour", "Low", "Middle", "Modern", "High", "Luxe", "Motel", "Entrepot (grand)", "Entrepot (moyen)", "Entrepot (petit)" }
local zones = { 
	['AIRP'] = "Los Santos International Airport",
	['ALAMO'] = "Alamo Sea", 
	['ALTA'] = "Alta", 
	['ARMYB'] = "Fort Zancudo", 
	['BANHAMC'] = "Banham Canyon Dr", 
	['BANNING'] = "Banning", 
	['BEACH'] = "Vespucci Beach", 
	['BHAMCA'] = "Banham Canyon", 
	['BRADP'] = "Braddock Pass", 
	['BRADT'] = "Braddock Tunnel", 
	['BURTON'] = "Burton", 
	['CALAFB'] = "Calafia Bridge", 
	['CANNY'] = "Raton Canyon", 
	['CCREAK'] = "Cassidy Creek", 
	['CHAMH'] = "Chamberlain Hills", 
	['CHIL'] = "Vinewood Hills", 
	['CHU'] = "Chumash", 
	['CMSW'] = "Chiliad Mountain State Wilderness", 
	['CYPRE'] = "Cypress Flats", 
	['DAVIS'] = "Davis", 
	['DELBE'] = "Del Perro Beach", 
	['DELPE'] = "Del Perro", 
	['DELSOL'] = "La Puerta", 
	['DESRT'] = "Grand Senora Desert", 
	['DOWNT'] = "Downtown", 
	['DTVINE'] = "Downtown Vinewood", 
	['EAST_V'] = "East Vinewood", 
	['EBURO'] = "El Burro Heights", 
	['ELGORL'] = "El Gordo Lighthouse", 
	['ELYSIAN'] = "Elysian Island", 
	['GALFISH'] = "Galilee", 
	['GOLF'] = "GWC and Golfing Society", 
	['GRAPES'] = "Grapeseed", 
	['GREATC'] = "Great Chaparral", 
	['HARMO'] = "Harmony", 
	['HAWICK'] = "Hawick", 
	['HORS'] = "Vinewood Racetrack", 
	['HUMLAB'] = "Humane Labs and Research", 
	['JAIL'] = "Bolingbroke Penitentiary", 
	['KOREAT'] = "Little Seoul", 
	['LACT'] = "Land Act Reservoir", 
	['LAGO'] = "Lago Zancudo", 
	['LDAM'] = "Land Act Dam", 
	['LEGSQU'] = "Legion Square", 
	['LMESA'] = "La Mesa", 
	['LOSPUER'] = "La Puerta", 
	['MIRR'] = "Mirror Park", 
	['MORN'] = "Morningwood", 
	['MOVIE'] = "Richards Majestic", 
	['MTCHIL'] = "Mount Chiliad", 
	['MTGORDO'] = "Mount Gordo", 
	['MTJOSE'] = "Mount Josiah", 
	['MURRI'] = "Murrieta Heights", 
	['NCHU'] = "North Chumash", 
	['NOOSE'] = "N.O.O.S.E", 
	['OCEANA'] = "Pacific Ocean", 
	['PALCOV'] = "Paleto Cove", 
	['PALETO'] = "Paleto Bay", 
	['PALFOR'] = "Paleto Forest", 
	['PALHIGH'] = "Palomino Highlands", 
	['PALMPOW'] = "Palmer-Taylor Power Station", 
	['PBLUFF'] = "Pacific Bluffs", 
	['PBOX'] = "Pillbox Hill", 
	['PROCOB'] = "Procopio Beach", 
	['RANCHO'] = "Rancho", 
	['RGLEN'] = "Richman Glen", 
	['RICHM'] = "Richman", 
	['ROCKF'] = "Rockford Hills", 
	['RTRAK'] = "Redwood Lights Track", 
	['SANAND'] = "San Andreas", 
	['SANCHIA'] = "San Chianski Mountain Range", 
	['SANDY'] = "Sandy Shores", 
	['SKID'] = "Mission Row", 
	['SLAB'] = "Stab City", 
	['STAD'] = "Maze Bank Arena", 
	['STRAW'] = "Strawberry", 
	['TATAMO'] = "Tataviam Mountains", 
	['TERMINA'] = "Terminal", 
	['TEXTI'] = "Textile City", 
	['TONGVAH'] = "Tongva Hills", 
	['TONGVAV'] = "Tongva Valley", 
	['VCANA'] = "Vespucci Canals", 
	['VESP'] = "Vespucci", 
	['VINE'] = "Vinewood",
	['WINDF'] = "Ron Alternates Wind Farm", 
	['WVINE'] = "West Vinewood",
	['ZANCUDO'] = "Zancudo River",
	['ZP_ORT'] = "Port of South Los Santos", 
	['ZQ_UAR'] = "Davis Quartz" 
}

RMenu.Add('propriete', 'main', RageUI.CreateMenu("Propriété", " "))
RMenu:Get('propriete', 'main'):SetSubtitle("~b~Création de propriété")
RMenu:Get('propriete', 'main').EnableMouse = false
RMenu:Get('propriete', 'main').Closed = function()
end;

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSh4587poiaredObj4587poiect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RageUI.CreateWhile(1.0, RMenu:Get('propriete', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('propriete', 'main'), true, true, true, function()
        if not IsOpenMenu then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            PedPosition = pos
            IsOpenMenu = true
        end
        RageUI.Button("Placer une entrée", nil, {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]
				local PlayerCoord = {x = pos.x, y = pos.y, z = pos.z-1}                  
				local Out = {x = pos.x, y = pos.y, z = pos.z}

				entering = json.encode(PlayerCoord)
				outside  = json.encode(Out)

                ESX.ShowNotification('Position de la porte '..pos.. ', Adresse '..current_zone.. '')
                ESX.ShowNotification('Position de la sortie '..pos..'')
			end
        end)
		RageUI.Checkbox("Visiter | Apercu", "~g~On~w~ pour vous rendre sur place, ~r~Off~w~ pour avoir un appercu", VisiterOrNot, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
			VisiterOrNot = Checked;
		end)
		RageUI.List("Interieur", items, selectedItemIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
			selectedItemIndex = Index;
            if changeIndex ~= selectedItemIndex then
                local n = math.random(0,2000)
				changeIndex = selectedItemIndex
                if VisiterOrNot then
                    Destroy()
                end
		    	if selectedItemIndex == 1 then 
                    Destroy()
				elseif selectedItemIndex == 2 then 

		    		if VisiterOrNot == false then 
                        Cam('Low')
					else
						name = 'LowEndApartment'..n
						ipl = '[]'
						inside = '{"x":266.0773,"y":-1007.3900,"z":-101.008}'
						exit = '{"x":266.0773,"y":-1007.3900,"z":-101.008}'
					    isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), 265.6031, -1002.9244, -99.0086)		
					end		
                     
				elseif selectedItemIndex == 3 then 
					
		    		if VisiterOrNot == false then 
                        Cam('Middle')
					else
						name = 'Middle'..n
						ipl = '[]'
						inside = '{"x":-603.4308,"y":58.9184,"z":97.2001}'
						exit = '{"x":-603.4308,"y":58.9184,"z":97.2001}'
					    isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), -616.8566, 59.3575, 98.2000)		
					end	

		    	elseif selectedItemIndex == 4 then 

		    		if VisiterOrNot == false then 
		    			Cam('Modern')
					else
						name = 'Modern'..n
						ipl = '["apa_v_mp_h_01_a"]'
						inside = '{"x":-786.87,"y":315.7497,"z":186.91}'
						exit = '{"x":-786.87,"y":315.7497,"z":186.91}'
						isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), -788.3881, 320.2430, 187.3132)		
					end			

		        elseif selectedItemIndex == 5 then 

		    		if VisiterOrNot == false then 
		    			Cam('High')
					else
						name = 'High'..n
						ipl = '[]'
						inside = '{"x":-1451.6394,"y":-523.5562,"z":55.9290}'
						exit = '{"x":-1451.6394,"y":-523.5562,"z":55.9290}'
						isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), -1459.1700, -520.5855, 56.9247)		
					end		

		    	elseif selectedItemIndex == 6 then 

                    if VisiterOrNot == false then 
                        Cam('Luxe')
                    else
                        name = 'luxe'..n
                        ipl = '[]'
                        inside = '{"x":-681.6273,"y":591.9663,"z":144.3930}'	
                        exit = '{"x":-681.6273,"y":591.9663,"z":144.3930}'				
                        isSingle = 1
                        isRoom = 1
                        isGateway = 0
                        SetEntityCoords(GetPlayerPed(-1), -674.4503, 595.6156, 145.3796)		
                    end		
 
		        elseif selectedItemIndex == 7 then 
		    		
                    if VisiterOrNot == false then 
                        Cam('Motel')   
                    else
                        name = 'Hotel'..n
                        ipl = '["hei_hw1_blimp_interior_v_motel_mp_milo_"]'
                        inside = '{"x":151.3258,"y":-1007.7642,"z":-100.0000}'
                        exit = '{"x":151.3258,"y":-1007.7642,"z":-100.0000}'
                        isSingle = 1
                        isRoom = 1
                        isGateway = 0
                        SetEntityCoords(GetPlayerPed(-1), 151.0994, -1007.8073, -98.9999)		
                    end		
 
		        elseif selectedItemIndex == 8 then 

		    	    if VisiterOrNot == false then 
		    	    	Cam('Entrepot1')
					else
						name = 'Grandentrepot'..n
						ipl = '[]'
						inside = '{"x":998.1795"y":-3091.9169,"z":-39.9999}'
						exit   = '{"x":998.1795"y":-3091.9169,"z":-39.9999}'
						isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), 1026.8707, -3099.8710, -38.9998)		
					end	

		        elseif selectedItemIndex == 9 then 	

		    	    if VisiterOrNot == false then 
                       Cam('Entrepot2')
					else
						name = 'EntrepotMoyen'..n
						ipl = '[]'
						inside = '{"x":1072.5505,"y":-3102.5522,"z":-39.9999}'
						exit   = '{"x":1072.5505,"y":-3102.5522,"z":-39.9999}'
						isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), 1072.8447, -3100.0390, -38.9999)		
					end	

		        elseif selectedItemIndex == 10 then    

		    	    if VisiterOrNot == false then 
                        Cam('Entrepot3')
					else
						name = 'Petitentrepot'..n
						ipl = '[]'
						inside = '{"x":1104.6102,"y":-3099.4333,"z":-39.9999}'
						exit   = '{"x":1104.6102,"y":-3099.4333,"z":-39.9999}'
						isSingle = 1
					    isRoom = 1
					    isGateway = 0
						SetEntityCoords(GetPlayerPed(-1), 1104.7231, -3100.0690, -38.9999)		
					end	  
		    	end	
			end
		end)
        RageUI.Button("Placer le coffre", nil, {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local CoffreCoord = {x = pos.x, y = pos.y, z = pos.z-1} 
				roommenu = json.encode(CoffreCoord)
                ESX.ShowNotification('Position du coffre '..pos.. '')
			end
        end)
        RageUI.Button("Entrer un label", nil, { RightLabel = "/ "..label.." \\" }, true, function(Hovered, Active, Selected)
            if (Selected) then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
		        while (UpdateOnscreenKeyboard() == 0) do
		            DisableAllControlActions(0);
		           Citizen.Wait(1)
		        end
		        if (GetOnscreenKeyboardResult()) then
		            label = GetOnscreenKeyboardResult()
		            if label == nil or label == "?" then
		               ESX.ShowNotification('~r~Vous devez entrer un label valide')
		            end     
		        end 
			end
        end)
        RageUI.Button("Prix", nil, { RightLabel = "/ "..price.." \\" }, true, function(Hovered, Active, Selected)
            if (Selected) then
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 100)
		        while (UpdateOnscreenKeyboard() == 0) do
		            DisableAllControlActions(0);
		           Citizen.Wait(1)
		        end
		        if (GetOnscreenKeyboardResult()) then
                    price = GetOnscreenKeyboardResult()
		            if tonumber(price) == nil or price == "?" then
                       ESX.ShowNotification('~r~Vous devez entrer un nombre valide')
                       price = "?"
		            end     
		        end
			end
        end)
        RageUI.Button("Annuler", nil, { Color = {BackgroundColor = {169, 11, 11}} }, true, function(Hovered, Active, Selected)
            if (Selected) then
                if PedPosition ~= nil then
                    SetEntityCoords(PlayerPedId(), PedPosition.x, PedPosition.y, PedPosition.z)
                end
                IsOpenMenu = false
                Destroy()
                Citizen.Wait(50)
                RageUI.Visible(RMenu:Get('propriete', 'main'), false)
                ESX.ShowNotification('Création de propriété annulé')
			end
        end)
        RageUI.Button("Valider", nil, { Color = {BackgroundColor = {47, 180, 18}} }, true, function(Hovered, Active, Selected)
			if (Selected) then
                if entering == "" then
                    ESX.ShowNotification('~r~Vous n\'avez aucune entrée assingné')
                elseif roommenu == "" then
                    ESX.ShowNotification('~r~Vous n\'avez aucun coffre assingné')
                elseif label == nil or label == "?" then
                    ESX.ShowNotification('~r~Vous n\'avez aucun label assingné')
                elseif price == nil or price == "?" then
                    ESX.ShowNotification('~r~Vous n\'avez aucun prix assingné')
                else
		    	    TriggerServerEvent('ns_createpropriete:Save', name, label, entering, exit, inside, outside, ipl, isSingle, isRoom, isGateway, roommenu, price)
                    RageUI.Visible(RMenu:Get('propriete', 'main'), false)  
		    	    Citizen.Wait(15)
		    	    SetEntityCoords(PlayerPedId(), PedPosition.x, PedPosition.y, PedPosition.z)
                    IsOpenMenu = false
		    	end   

                if debug then 
			    	print('Name '..name)
			    	print('ipl ' ..ipl)
			    	print('label ' ..label)
			    	print('entering ' ..entering)
			    	print('inside ' ..inside)
			    	print('roommenu ' ..roommenu)
			    	print('exit ' ..exit)
					print('outside ' ..outside)
			    	print(tonumber(price))
		    	end  
			end
        end)
    end, function()
    end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0, 167) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'realestateagent' then
			RageUI.Visible(RMenu:Get('propriete', 'main'), not RageUI.Visible(RMenu:Get('propriete', 'main')))
	    end
	end
end)

function Cam(type)
	if type == 'Low' then 
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(265.6078, -995.8491, -99.0086, 0.0, 0.0, 0.0)
		SetCamCoord(cam, 265.9317, -999.4464, -99.0086)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 87.69)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)
	elseif type == 'Middle' then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(-616.8566, 59.3575, 98.2000, 0.0, 0.0, 0.0)
		SetCamCoord(cam, -616.8566, 59.3575, 98.2000)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 195.59)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)	
	elseif type == 'Modern' then 
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(-788.3881, 320.2430, 187.3132, 0.0, 0.0, 0.0)
		SetCamCoord(cam, -788.3881, 320.2430, 187.3132)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 355.81)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)
	elseif type == 'High' then 
	    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(-1459.1700, -520.5855, 56.9247, 0.0, 0.0, 0.0)
		SetCamCoord(cam, -1459.1700, -520.5855, 56.9247)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 150.2664)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)	
    elseif type == 'Luxe' then 
	    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(-674.4503, 595.6156, 145.3796, 0.0, 0.0, 0.0)
		SetCamCoord(cam, -674.4503, 595.6156, 145.3796)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 195.45)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)	
	elseif type == 'Motel' then 
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(151.0994, -1007.8073, -98.9999, 0.0, 0.0, 0.0)
		SetCamCoord(cam, 151.0994, -1007.8073, -98.9999)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 337.79)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)	
	elseif type == 'Entrepot1' then 
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(1026.8707, -3099.8710, -38.9998, 0.0, 0.0, 0.0)
		SetCamCoord(cam, 1026.8707, -3099.8710, -38.9998)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 88.76)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)
	elseif type == 'Entrepot2' then 
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(1072.8447, -3100.0390, -38.9999, 0.0, 0.0, 0.0)
		SetCamCoord(cam, 1072.8447, -3100.0390, -38.9999)
		SetCamActive(cam,  true)
		SetCamRot(cam, 0.0, 0.0, 91.85)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)	
	elseif type == 'Entrepot3'	then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetFocusArea(1104.7231, -3100.0690, -38.9999, 0.0, 0.0, 0.0)
		SetCamCoord(cam, 1104.7231, -3100.0690, -38.9999)
	    SetCamActive(cam,  true)
	  	SetCamRot(cam, 0.0, 0.0, 85.68)
		RenderScriptCams(true,  false,  0,  true,  true)
		FreezeEntityPosition(GetPlayerPed(-1), true)
	end	
end

function Destroy()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
	SetCamActive(cam,  false)	
	FreezeEntityPosition(GetPlayerPed(-1), false)
	RenderScriptCams(false,  false,  0,  false,  false)
    SetFocusEntity(PlayerPedId())
	print('retour')
end