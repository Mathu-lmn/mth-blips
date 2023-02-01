-- create a menu for the blips
local blips_menu = RageUI.CreateMenu("Blips", "Blips Menu")
blips_menu:DisplayPageCounter(true)
local settings_menu = RageUI.CreateSubMenu(blips_menu, "Settings", "blips settings")
local open = false
local results = {}
local dict = nil
blips_menu.Closed = function()
    open = false
end

local scale = 1.0
local color = 1
local createdBlip = nil
local x, y, z = 0, 0, 0
local heading = 0

RegisterCommand("blips", function()
    openBlipsMenu()
end)

function openBlipsMenu()
    if open then
        open = false
        RageUI.Visible(blips_menu, false)
        return
    else
        open = true
        RageUI.Visible(blips_menu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(blips_menu, function()
                    RageUI.Button("Settings", nil, { RightLabel = "→→→" }, true, {}, settings_menu)
                    RageUI.Separator("Blips list")
                    -- add a button for each effect
                    for i = 0, 838 do
                        RageUI.Button(i, nil, { RightLabel = ">" }, true, {
                            onSelected = function()
                                AddBlip(i)
                            end
                        }, nil)
                    end
                end)
                RageUI.IsVisible(settings_menu, function()
                    RageUI.Separator("Color")
                    -- add a button to set the position of the effect at the player's position
                    RageUI.List("Set the color", Config.color, color, nil, {}, true, {
                        onListChange = function(Index, Item)
                            color = Index
                        end
                    })
                    RageUI.Separator("Scale")
                    -- add a button to set the scale of the effect
                    RageUI.Button("Set the scale", scale, { RightLabel = ">" }, true, {
                        onSelected = function()
                            local result = KeyboardInput("Scale")
                            if result and tonumber(result) then
                                scale = tonumber(result) + 0.0
                            end
                        end
                    })
                end)
                Wait(0)
            end
        end)
    end
end

function AddBlip(blip)
    -- remove the blip if it already exists
    if createdBlip and DoesBlipExist(createdBlip) then
        if GetBlipSprite(createdBlip) == blip then
            RemoveBlip(createdBlip)
            createdBlip = nil
            showNotification("Blip removed")
            return
        else
            RemoveBlip(createdBlip)
            createdBlip = nil
        end
    end
    x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    heading = GetEntityHeading(PlayerPedId()) + 90.0
    -- Put the blip position in front of the player
    x = x + math.cos(heading * math.pi / 180.0) * 20.0
    y = y + math.sin(heading * math.pi / 180.0) * 20.0

    createdBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(createdBlip, blip)
    SetBlipScale(createdBlip, scale)
    SetBlipColour(createdBlip, color - 1)
    showNotification("Blip added")
end

function KeyboardInput(text)
	local result = nil
	AddTextEntry("CUSTOM_AMOUNT", text)
	DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 255)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(1)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		result = GetOnscreenKeyboardResult()
		Citizen.Wait(1)
	else
		Citizen.Wait(1)
	end
	return result
end

function showNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end