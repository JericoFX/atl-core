ATL.RegisterCommand = function(name, description, group, cb, suggestions, rcon)
    if type(name) == 'table' then
        for i=1, #name do
            ATL.RegisterCommand(name[i], description, group, cb, suggestions, rcon)
        end
        return
    end
    RegisterCommand(name, function(source, args)
        local playerId <const> = source
        if rcon then
            if playerId == 0 then
                cb(nil, args)
            end
        else
            local player = Players[playerId]
            if player and player:isAuthorized(group) then
                cb(player, args)
            end
        end
    end)
end

ATL.GetLicense = function(playerId)
    if not playerId then return false end

    local identifiers = GetPlayerIdentifiers(playerId)
    local found = false
    for i=1, #identifiers do
        if identifiers[i]:match('license:') then
            found = identifiers[i]
            break
        end
    end
    return found
end

ATL.GetPassengers = function(ped, vehicle)
    local passengers = { }
    if vehicle and vehicle > 0 then
        for i=6, -1, -1 do
            local seatPed = GetPedInVehicleSeat(vehicle, i)
            if seatPed > 0 then
                passengers[i] = seatPed
            end
        end
    else
        passengers[-1] = ped
    end
    return passengers
end