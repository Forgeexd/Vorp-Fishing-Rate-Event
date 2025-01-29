local doubleFishChance = false -- 2x fish mode initially off

RegisterCommand("2xfish", function(source, args, rawCommand)
    doubleFishChance = not doubleFishChance -- On/Off
    if doubleFishChance then
        print("2x Fish mode ACTIVE! Increased probability of catching fish.")
    else
        print("2x Fish mode OFF! The probability of catching fish has returned to normal.")
    end
end, false)

-- Parts of fish catching parts
doisFishHooked = function()
    local probabilidadePuxar = math.random()
    local minChance = doubleFishChance and 0.1 or 0.2 -- 2x balık aktifse şans artar
    local maxChance = doubleFishChance and 0.95 or 0.9

    return not (probabilidadePuxar > maxChance or probabilidadePuxar < minChance)
end

-- Integrate into existing fish catch control
if fishHandle then
    if doisFishHooked() then 
        if FISHING_GET_F_(5) == 1 then
            Citizen.InvokeNative(0xF0FBF193F1F5C0EA, fishHandle)
            SetPedConfigFlag(fishHandle, 17, true)
            Citizen.InvokeNative(0x1F298C7BD30D1240, playerPed)
            ClearPedTasksImmediately(fishHandle, false, true)
            TaskSetBlockingOfNonTemporaryEvents(fishHandle, true)
            Citizen.InvokeNative(0x1A52076D26E09004, playerPed, fishHandle)
            FISHING_SET_FISH_HANDLE(fishHandle)
            fishForce = 0.6
            FISHING_SET_TRANSITION_FLAG(4)
        end
    end
end