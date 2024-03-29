local hour = 0
local minute = 0
local month = ""
local dayMonth = 0
local showHud = true
local hotkey = true
local toggleHud = true 

local months = {
    [0] = "January", "February", "March", "April", "May", "June", "July", "August",
    "September", "October", "November", "December"
}

local directionMapping = {
    [0] = "North",
    [45] = "West",
    [135] = "South",
    [225] = "East",
    [315] = "North"
}

function calculateTimeDisplay()
    hour = GetClockHours()
    minute = GetClockMinutes()
    month = months[GetClockMonth()]
    dayMonth = GetClockDayOfMonth()

    if hour <= 9 then
        hour = "0" .. hour
    end

    if minute <= 9 then
        minute = "0" .. minute
    end
end

function ToggleHud()
    showHud = not showHud
    DisplayRadar(showHud)
end

RegisterCommand('togglehud', function()
    ToggleHud()
end, false)

RegisterKeyMapping('togglehud', 'Toggle HUD', 'keyboard', '')

Citizen.CreateThread(function()
    while true do
        if IsPauseMenuActive() or IsScreenFadedOut() or menu_celular then
            SendNUIMessage({ hud = false, movie = false })
        else
            local ped = PlayerPedId()
            local armour = GetPedArmour(ped)
            local health = math.floor((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100)

            hour = GetClockHours()
            minute = GetClockMinutes()

            if hour <= 9 then
                hour = "0" .. hour
            end

            if minute <= 9 then
                minute = "0" .. minute
            end

            time = hour .. ':' .. minute

            local cds = GetEntityCoords(ped)
            local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(cds.x, cds.y, cds.z))
            local ped = PlayerPedId()
            local car = GetVehiclePedIsIn(ped)

            if not showHud then
                DisplayRadar(false) 
            end

            if IsPedOnAnyBike(ped) then
                DisplayRadar(true)
            end

            local vehicle = GetVehiclePedIsIn(ped)

            if vehicle ~= 0 then
                local fuel = GetVehicleFuelLevel(vehicle)
                local speed = GetEntitySpeed(vehicle) * 3.6

                local direction = GetEntityHeading(ped)
                local directionText = directionMapping[math.floor((direction + 45) / 90) * 90]

                SendNUIMessage({
                    hud = showHud,
                    movie = showMovie,
                    car = true,
                    time = time,
                    street = street,
                    radio = radioDisplay,
                    voice = voice,
                    talking = talking,
                    health = health,
                    armour = armour,
                    fuel = fuel,
                    speed = speed,
                    direction = directionText,
                    radiofreq = radioFrequency,
                    hotkey = hotkey
                })
            else
                if not showHud then
                    DisplayRadar(false) 
                else
                    DisplayRadar(true)
                end

                SendNUIMessage({
                    hud = showHud,
                    movie = showMovie,
                    car = false,
                    time = time,
                    street = street,
                    radio = radioDisplay,
                    voice = voice,
                    talking = talking,
                    health = health,
                    armour = armour,
                    direction = directionText,
                    radiofreq = radioFrequency,
                    hotkey = hotkey
                })
            end
        end

        Citizen.Wait(1000)
    end
end)
