--[[
    Main gui file:
        Require all gui files here
        Event handler for gui's
        Add commands to open every gui for testing
]]--

-------------Require all gui files here-------------
local deckBuilderGui = require("scripts/Gui/DeckBuilderGui.lua")
local dungeonGui = require("scripts/Gui/DungeonGui.lua")
local shopGui = require("scripts/Gui/ShopGui.lua")

-------------Add gui's to the global DTO-------------
global.DTO.gui.deckBuilderGui = deckBuilderGui
global.DTO.gui.dungeonGui = dungeonGui
global.DTO.gui.shopGui = shopGui

-------------Event handler for gui's-------------
-- Event handler for player creation
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    local surface = player.surface
    -- Create the deck builder button
    deckBuilderGui.createDeckBuilderButton(player, surface)
end)

-- Event handler for surface change
script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    local surface = player.surface
    if surface.name == "nauvis" then
        -- Create the deck builder button
        deckBuilderGui.createDeckBuilderButton(player, surface)
    else
        -- Destroy the deck builder button
        deckBuilderGui.destroyDeckBuilderButton(player)
    end
end)

-------------Testing-------------
commands.add_command("shop", "Open the shop GUI", function(command)
    -- Get the player who issued the command
    local player = game.players[command.player_index]

    -- Check if the shop GUI already exists
    if player.gui.screen["shop_unique_frame"] then
        -- If it does, destroy it
        player.gui.screen["shop_unique_frame"].destroy()
    end

    -- Open the shop GUI
    shopGui.createShopGui(player)
end)

