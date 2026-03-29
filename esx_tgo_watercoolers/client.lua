local ESX = nil

local waterCoolers = {-742198632}
local IS_ANIMATED = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do

        Wait(1)

        local sleep  = 1200
        local coords = GetEntityCoords(PlayerPedId())

        if IS_ANIMATED then
            goto END
        end
        
        if not IS_ANIMATED then

            for i = 1, #waterCoolers do

                local watercooler       = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, waterCoolers[i], false, false, false)
                local waterCoolercoords = GetEntityCoords(watercooler)
                local dist              = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, waterCoolercoords.x, waterCoolercoords.y, waterCoolercoords.z, true)
    
                if dist < 1.8 then
                    sleep = 0

                    ESX.Game.Utils.DrawText3D(vector3(waterCoolercoords.x, waterCoolercoords.y, waterCoolercoords.z + 1.0), 'Press [~y~E~w~] to drink water.', 0.7)

                    if IsControlJustReleased(0, 38) then
    
                        if not IS_ANIMATED then
                            prop_name = prop_name or 'prop_cs_paper_cup'
                            IS_ANIMATED = true
    
                            TriggerServerEvent('esx_tgo_watercoolers:refillThirst')
    
                            Citizen.CreateThread(function()
                                local playerPed = PlayerPedId()
                                local x,y,z = table.unpack(GetEntityCoords(playerPed))
                                local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
                                local boneIndex = GetPedBoneIndex(playerPed, 18905)
                                AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
                    
                                ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
                                    TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
    
                                    Citizen.Wait(3000)
                                    IS_ANIMATED = false
                                    ClearPedSecondaryTask(playerPed)
                                    DeleteObject(prop)
                                end)
                            end)
                        end
                    end
    
                end

            end

        end

        ::END::
        Wait(sleep)
    end
end)
