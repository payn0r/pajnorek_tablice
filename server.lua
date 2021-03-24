--] siema nie usuwaj nie podpisuj sie pod to ok?[--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('tablice:pay')
AddEventHandler('tablice:pay', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.money)
end)
--] siema nie usuwaj nie podpisuj sie pod to ok?--
--w linice 84 zmieniasz nazwe na jaka chcesz max chyba 8 liter--