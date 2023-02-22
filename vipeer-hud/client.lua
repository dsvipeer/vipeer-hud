
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local hour = 0
local voice = 2
local minute = 0
local month = ""
local dayMonth = 0
local varDay = "th"
local showHud = true
local showMovie = false
local showRadar = true
local sBuffer = {}
local timedown = 0
local talking = false
local radioFrequency = nil
local hotkey = true

-----------------------------------------------------------------------------------------------------------------------------------------
-- CALCULATETIMEDISPLAY
-----------------------------------------------------------------------------------------------------------------------------------------
local months = { [0] = "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
function calculateTimeDisplay()
	hour = GetClockHours()
	month = GetClockMonth()
	minute = GetClockMinutes()
	dayMonth = GetClockDayOfMonth()

	if hour <= 9 then
		hour = "0"..hour
	end

	if minute <= 9 then
		minute = "0"..minute
	end
    month = months[month]
end

Citizen.CreateThread(function()
	while true do
		if IsPauseMenuActive() or IsScreenFadedOut() or menu_celular then
			SendNUIMessage({ hud = false, movie = false })
		else
			local ped = PlayerPedId()
			local armour = GetPedArmour(ped)
			local health = math.floor((GetEntityHealth(ped)-100)/(GetEntityMaxHealth(ped)-100)*100)
			local stamina = GetPlayerSprintStaminaRemaining(PlayerId())
            local directions = { [0] = 'Norte', [45] = 'Noroeste', [90] = 'Oeste', [135] = 'Sudoeste', [180] = 'Sul', [225] = 'Sudeste', [270] = 'Leste', [315] = 'Nordeste', [360] = 'Norte', }
            local direction = ''

            for k,v in pairs(directions)do
                direction = GetEntityHeading(ped)
                if(math.abs(direction - k) < 22.5)then
                    direction = v
                    break;
                end
            end

            hour = GetClockHours()
            minute = GetClockMinutes()
        
            if hour <= 9 then
                hour = "0"..hour
            end
        
            if minute <= 9 then
                minute = "0"..minute
            end

            time = hour..':'..minute

            local cds = GetEntityCoords(ped)
			local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(cds.x, cds.y, cds.z))
			
			local ped = PlayerPedId()
			local car = GetVehiclePedIsIn(ped)

			if not showHud then 
				showRadar = true 
			end

			if IsPedOnAnyBike(ped) then
				showRadar = true
			end
			
            local vehicle = GetVehiclePedIsIn(ped)

			if vehicle ~= 0 then

				-- showRadar = true
				-- DisplayRadar(showRadar)
				local fuel = GetVehicleFuelLevel(vehicle)
				local speed = GetEntitySpeed(vehicle) * 3.6

				SendNUIMessage({ hud = showHud, movie = showMovie, car = true, time = time, street = street, radio = radioDisplay, voice = voice, talking = talking, health = (health), armour = (armour), fuel = (fuel), speed = (speed), seatbelt = seatbelt, direction = direction, radiofreq = radioFrequency, hotkey = hotkey })
			else
				showRadar = true
				SendNUIMessage({ hud = showHud, movie = showMovie, car = false, time = time, street = street, radio = radioDisplay, voice = voice, talking = talking, health = (health), armour = (armour), direction = direction, radiofreq = radioFrequency, hotkey = hotkey })
			end
		end

		Citizen.Wait(200)
	end
end)