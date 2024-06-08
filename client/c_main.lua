ESX = exports['es_extended']:getSharedObject()

lib.locale()

--@ areablip
for _,v in ipairs(Config.Areas) do
    coords = v.coords
    size = v.area
    blip = AddBlipForCoord(v.coords)
    SetBlipSprite(blip, 273)
	SetBlipColour(blip, 0)
	SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(locale('blip_dig_area')) 
    EndTextCommandSetBlipName(blip)
    area_blip = AddBlipForRadius(v.coords, v.area)
    SetBlipSprite(area_blip, 10)
end

--@ area dig, check the coords and start function if player in area.
lib.callback.register('esx_digarea:StartDig', function(source)
    local playerCoords = GetEntityCoords(cache.ped)
    local dist = #(playerCoords - coords)

    if dist < size then
        if not IsPedInAnyVehicle(cache.ped) then
            print('Started Digging!')
            if lib.progressBar({
                label = locale('progressbar_digging'),
                duration = Config.DigTime * 1000,
                allowCuffed = false,
                allowFalling = false,
                allowRagdoll = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
                anim = {
                    dict = 'random@burial',
                    clip = 'a_burial'
                },
                prop = {
                    model = 'prop_tool_shovel',
                    bone = 28422,
                    rot = vec3(0.000000, 0.000000, 0.000000),
                    pos = vec3(0.000000, 0.000000, 0.240000)
                }
            }) then lib.callback.await('esx_digarea:GetReward', source) else Notify(locale('you_canceled_digging'), 'error') end
        else
            Notify(locale('can_do_it_in_vehicle'), 'error')
        end
    else
        Notify(locale('you_not_in_area'), 'warning')
    end
end)

lib.callback.register('esx_digarea:StartPan', function(source)
    local item = lib.callback.await('esx_digarea:CheckItem', 100)

    if item then
        if IsEntityInWater(cache.ped) then
            if not IsPedInAnyVehicle(cache.ped) then
                if not IsPedSwimming(cache.ped) then
                    local proppi = CreateObject(GetHashKey("bkr_prop_coke_metalbowl_02"), 0, 0, 0, true, true, true)
                    ClearPedTasks(cache.ped)
                    TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_BUM_WASH", 0, false)
                    AttachEntityToEntity(proppi, cache.ped, GetPedBoneIndex(cache.ped, 60309), 0.129, 0.14, 0.13, 270.0, 180.0, 300.0, true, true, false, true, 1, true)

		    exports.ox_inventory:closeInventory()

                    local minigame = exports.peuren_minigames:StartPressureBar(50, 3)
    
                    if minigame then
                        if lib.progressBar({
                            label = locale('panning'),
                            duration = Config.PanTime * 1000,
                            allowCuffed = false,
                            allowFalling = false,
                            allowRagdoll = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                            }
                        }) then 
                            DeleteEntity(proppi)
                            ClearPedTasksImmediately(cache.ped)
                            Notify(locale('you_success_pan'), 'success')
                            lib.callback.await('esx_digarea:PanReward', source)
                        end
                    else
                        DeleteEntity(proppi)
                        ClearPedTasksImmediately(cache.ped)
                        Notify(locale('you_failed_pan'), 'error')
                    end
                else
                    Notify(locale('can_do_this_swiming'), 'error')
                end
            else
                Notify(locale('can_do_it_in_vehicle'), 'error')
            end
        else
            Notify(locale('not_water_in_here'), 'error')
        end
    else
        Notify(locale('you_not_have_item'), 'error')
    end
end)
