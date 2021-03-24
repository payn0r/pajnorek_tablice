--] siema nie usuwaj nie podpisuj sie pod to ok?[--
ESX = nil
cooldown = false

Citizen.CreateThread(function()
Citizen.Trace('PAYNOR_TABLICA: URUCHAMIAM SIE |Ladowanie Kordow x=?y=?z=?')
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		if cooldown then
			Citizen.Wait(Config.cooldown * 60000)
			cooldown = false
		end
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

-- Blip & marker
Citizen.CreateThread(function()
	if Config.blipEnabled then
		PokazBlip()
	end
end)

-- Ped
Citizen.CreateThread(function()
	RequestModel(GetHashKey(Config.pedName))
	while not HasModelLoaded(GetHashKey(Config.pedName)) do
		Citizen.Wait(1)
	end
	local ped = CreatePed(4, Config.pedHash, Config.pedCoords.x, Config.pedCoords.y, Config.pedCoords.z - 1, Config.pedHeading, false, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
end)

-- cmd
RegisterNetEvent('tablice:command')
AddEventHandler('tablice:command', function()
	Tablica()
end)


Citizen.CreateThread(function()
	while true do
	Citizen.Wait(2000)
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped, true)
		while GetDistanceBetweenCoords(coords, Config.pedCoords.x, Config.pedCoords.y, Config.pedCoords.z, false) < 10 do
			Citizen.Wait(0)
			DrawText3D(Config.pedCoords.x, Config.pedCoords.y, Config.pedCoords.z + 1.1, 'Dziadek Karol(PAYNOR)')
			coords = GetEntityCoords(ped, true)
			if GetDistanceBetweenCoords(coords, Config.pedCoords.x, Config.pedCoords.y, Config.pedCoords.z, false) < 3 then
				Notify('Naciśnij ~INPUT_PICKUP~ aby zamalować tablice rejestracyjną. (~g~' .. Config.money .. '$~w~)')
				if IsControlJustReleased(0, 38) then
					Tablica()
				end
			end
		end
	end
end)

-- funkcje
function Tablica()
	if cooldown then
		ESX.ShowNotification('Musisz poczekać ' .. Config.cooldown .. ' sekund, aby ukryć tablicę ponownie!' )
	end
	if not cooldown then
		cooldown = true
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped, true)
		local plateText = GetVehicleNumberPlateText(veh)
		local plateNew = ' '
		TriggerServerEvent('tablice:pay')
		ESX.ShowNotification('Rejestracja jest teraz ~r~niewidoczna~w~ przez~g~ ' .. Config.czas .. ' ~w~minut!' )
		SetVehicleNumberPlateText(veh, plateNew)
		Citizen.Wait(Config.czas * 60000)
		SetVehicleNumberPlateText(veh, plateText)
		ESX.ShowNotification('Rejestracja jest teraz ~g~widoczna~w~!')
	end
end

function Notify (text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, true, -1)
end


function PokazBlip()
  local blip = AddBlipForCoord(Config.coords.x, Config.coords.y, Config.coords.z)
  SetBlipSprite(blip, Config.blipSprite)
  SetBlipColour(blip, Config.blipColour)
  SetBlipDisplay(blip, 6)
  SetBlipScale(blip, Config.blipScale)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING");
  AddTextComponentString(Config.blipName)
  EndTextCommandSetBlipName(blip)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

--] siema nie usuwaj nie podpisuj sie pod to ok?[--