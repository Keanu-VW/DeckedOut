-- Import necessary libraries
gui = require("__flib__/gui.lua")

-- Function to add a card to the player's deck
local function addCardToDeck(cardName, times)
    for i = 1, times do
        table.insert(global.Player.inventory_cards, global.Cards[cardName])
    end
end

-- Add cards to the player's deck
addCardToDeck("Sneak", 3)
addCardToDeck("Stability", 3)
addCardToDeck("Debris Removal", 3)
addCardToDeck("Summon Ally", 3)
addCardToDeck("Treasure", 3)

-- Function to create a card button
local function createCardButton(listBox, card, index, source)
    listBox.add_item(card.name)
end


-- Function to update the left frame with equipped cards
local function updateLeftFrame(player, leftFrame)
    leftFrame.clear()
    local equippedScrollPane = gui.add(leftFrame, {type="list-box", name="Dto_equipped_scroll_pane", direction="vertical", style="mods_list_box"})
    equippedScrollPane.style.horizontally_stretchable = true
    equippedScrollPane.style.vertically_stretchable = true
    for index, card in ipairs(global.Player.equipped_cards) do
        createCardButton(equippedScrollPane, card, index, "equipped_cards")
    end
end

-- Function to update the bottom right frame with player's deck
local function updateBottomRightFrame(player, bottomRightFrame)
    bottomRightFrame.clear()
    local playerDeckScrollPane = gui.add(bottomRightFrame, {type="list-box", name="Dto_player_deck_pane", direction="vertical", style="mods_list_box"})
    playerDeckScrollPane.style.horizontally_stretchable = true
    playerDeckScrollPane.style.vertically_stretchable = true
    for index, card in ipairs(global.Player.inventory_cards) do
        createCardButton(playerDeckScrollPane, card, index, "player_deck")
    end
end

-- Function to create the Deck Builder GUI
local function createDeckBuilderGui(player)
    local base = player.gui.screen
    local mainFrame = gui.add(base, {type="frame", name="Decktorio_Deck_Builder", caption="Decktorio Deck Builder", styles="outer_frame"})
    mainFrame.style.size = {800, 800}
    mainFrame.auto_center = true

    local contentFrame = gui.add(mainFrame, {type="flow", name="Dto_content_frame", direction="horizontal"})
    local leftFrame = gui.add(contentFrame, {type="frame", name="Dto_left_frame", direction="vertical", style="inner_frame_in_outer_frame"})
    leftFrame.style.horizontally_stretchable = true
    leftFrame.style.vertically_stretchable = true

    local rightFrame = gui.add(contentFrame, {type="flow", name="Dto_right_frame", direction="vertical"})
    local upperRightFrame = gui.add(rightFrame, {type="frame", name="Dto_upper_right_frame", direction="horizontal", style="inner_frame_in_outer_frame"})
    upperRightFrame.style.horizontally_stretchable = true
    upperRightFrame.style.vertically_stretchable = true
    upperRightFrame.style.vertically_squashable = false

    local lowerRightFrame = gui.add(rightFrame, {type="frame", name="Dto_lower_right_frame", direction="vertical", style="inner_frame_in_outer_frame"})
    lowerRightFrame.style.horizontally_stretchable = true
    lowerRightFrame.style.vertically_stretchable = true

    updateLeftFrame(player, leftFrame)
    updateBottomRightFrame(player, lowerRightFrame)
end

local function createDeckBuilderButton(player, surface)
    game.print(player.surface.name)
    local button = player.gui.top["Dto_Decktorio"]
    if surface.name == "nauvis" then
        if not button then
            player.gui.top.add {
                type = "button",
                name = "Dto_Decktorio",
                caption = "Dectorio"
                }
        end
    else
        if button then
            button.destroy()
        end
    end
end

-- Event handler for player creation
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    local surface = player.surface
    createDeckBuilderButton(player, surface)
end)

-- Event handler for surface change
script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.get_player(event.player_index)
    local surface = player.surface
    createDeckBuilderButton(player, surface)
end)


-- Event handler for GUI click
script.on_event(defines.events.on_gui_click, function(event)
    local player = game.get_player(event.player_index)

    if event.element.name == "Dto_Decktorio" then
        if player.gui.screen["Decktorio_Deck_Builder"] then
            player.gui.screen["Decktorio_Deck_Builder"].destroy()
        else
            createDeckBuilderGui(player)
        end
    end
end)



script.on_event(defines.events.on_gui_selection_state_changed, function(event)
    -- From equipped cards to player deck
    if event.element.valid and event.element.name == "Dto_equipped_scroll_pane" then
        game.print("Element Name:" .. event.element.name)
        game.print("Name:" .. event.name)
        game.print("tick:" .. event.tick)
    end
    
    -- From player deck to equipped cards
    if event.element.valid and event.element.name == "Dto_player_deck_pane" then
        game.print("Element Name:" .. event.element.name)
        
        game.print("Name:" .. event.name)
        game.print("tick:" .. event.tick)
    end
    
end)

--[[
local action = event.element.tags
if action.action == "move_card" then
    game.print("Moving card")
    local card_name = action.card_name
    local source = action.source
    local player = game.get_player(event.player_index)
    if source == "player_deck" then
        -- Move the card from player_deck to equipped_cards
        for index, card in ipairs(global.Player.inventory_cards) do
            if card.name == card_name then
                table.remove(global.Player.inventory_cards, index)
                table.insert(global.Player.equipped_cards, card)
                break
            end
        end
    else
        -- Move the card from equipped_cards to player_deck
        for index, card in ipairs(global.Player.equipped_cards) do
            if card.name == card_name then
                table.remove(global.Player.equipped_cards, index)
                table.insert(global.Player.inventory_cards, card)
                break
            end
        end
    end
    -- Update the frames
    local leftFrame = player.gui.screen["Decktorio_Deck_Builder"].Dto_content_frame.Dto_left_frame
    local lowerRightFrame = player.gui.screen["Decktorio_Deck_Builder"].Dto_content_frame.Dto_right_frame.Dto_lower_right_frame
    updateLeftFrame(player, leftFrame)
    updateBottomRightFrame(player, lowerRightFrame)
end
]]--