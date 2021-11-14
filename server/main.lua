ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'fbi', Config.MaxInService)
end

RegisterServerEvent('esx_fbijob:drag')
AddEventHandler('esx_fbijob:drag', function(target)
	TriggerClientEvent('esx_fbijob:drag', target, source)
end)

RegisterServerEvent('esx_fbijob:OutVehicle')
AddEventHandler('esx_fbijob:OutVehicle', function(target)
    TriggerClientEvent('esx_fbijob:OutVehicle', target)
end)

RegisterServerEvent('esx_fbijob:giveWeapon')
AddEventHandler('esx_fbijob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_fbijob:confiscatePlayerItem')
AddEventHandler('esx_fbijob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then

		local label = sourceXPlayer.getInventoryItem(itemName).label

		targetXPlayer.removeInventoryItem(itemName, amount)
		sourceXPlayer.addInventoryItem(itemName, amount)

		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
		TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

	end

	if itemType == 'item_account' then

		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
		TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

	end

	if itemType == 'item_weapon' then

		targetXPlayer.removeWeapon(itemName)
		sourceXPlayer.addWeapon(itemName, amount)

		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
		TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

	end

end)

RegisterServerEvent('esx_fbijob:handcuff')
AddEventHandler('esx_fbijob:handcuff', function(target)
	TriggerClientEvent('esx_fbijob:handcuff', target)
end)

RegisterServerEvent('esx_fbijob:putInVehicle')
AddEventHandler('esx_fbijob:putInVehicle', function(target)
	TriggerClientEvent('esx_fbijob:putInVehicle', target)
end)

ESX.RegisterServerCallback('esx_fbijob:getOtherPlayerData', function(source, cb, target)

		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

			if status ~= nil then
				data.drunk = status.getPercent()
			end
			
		end)

		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			data.licenses = licenses
		end)

		cb(data)

end)
--[[
ESX.RegisterServerCallback('esx_fbijob:getFineList', function(source, cb, category)

	MySQL.Async.fetchAll(
		'SELECT * FROM fine_types WHERE category = @category',
		{
			['@category'] = category
		},
		function(fines)
			cb(fines)
		end
	)

end)
--]]
ESX.RegisterServerCallback('esx_fbijob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles',
		{},
		function(result)
			
			local foundIdentifier = nil

			for i=1, #result, 1 do
				
				local vehicleData = json.decode(result[i].vehicle)

				if vehicleData.plate == plate then
					foundIdentifier = result[i].owner
					break
				end

			end

			if foundIdentifier ~= nil then

				MySQL.Async.fetchAll(
					'SELECT * FROM users WHERE identifier = @identifier',
					{
						['@identifier'] = foundIdentifier
					},
					function(result)

						local infos = {
							plate = plate,
							owner = result[1].name
						}

						cb(infos)

					end
				)
			
			else

				local infos = {
					plate = plate
				}

				cb(infos)

			end

		end
	)

end)

ESX.RegisterServerCallback('esx_fbijob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_fbi', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_fbijob:addArmoryWeapon', function(source, cb, weaponName)
	
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeWeapon(weaponName)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_fbi', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		 store.set('weapons', weapons)

		 cb()

	end)

end)

ESX.RegisterServerCallback('esx_fbijob:removeArmoryWeapon', function(source, cb, weaponName)
	
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 1000)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_fbi', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		 store.set('weapons', weapons)

		 cb()

	end)

end)


ESX.RegisterServerCallback('esx_fbijob:buy', function(source, cb, amount)
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_fbi', function(account)

		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			cb(false)
		end

	end)

end)

TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message, anon)

	local xPlayer  = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	if phoneNumber == 'fbi' then
		 for i=1, #xPlayers, 1 do
		 	local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer2.job.name == 'fbi' then
				TriggerEvent('esx_phone:getDistpatchRequestId', function(requestId)
					TriggerClientEvent('esx_phone:onMessage', xPlayer2.source, xPlayer.get('phoneNumber'), message, xPlayer.get('coords'), anon, _('alert_fbi'), requestId)
				end)
			end
		end
	end
	
end)