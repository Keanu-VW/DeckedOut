-- Import necessary libraries
local gui = require("__flib__/gui.lua")

-- Initialize global variables
global.cards = require("cards")
global.player_deck = {}
global.equipped_cards = {}

-- Function to add a card to the player's deck
local function addCardToDeck(cardName, times)
    for i = 1, times do
        table.insert(global.player_deck, global.cards[cardName])
    end
end

-- Add cards to the player's deck
addCardToDeck("Sneak", 3)
addCardToDeck("Stability", 3)
addCardToDeck("Debris Removal", 3)
addCardToDeck("Summon Ally", 3)

-- Function to create a card button
local function createCardButton(scrollPane, card, index, source)
    local button = scrollPane.add{
        type = "sprite-button",
        style = "flib_slot_button_grey",
        caption = "Card: " .. card.name,
        name = "Dto_card_button_" .. card.name .. index,
        tags = {
            gui = "deck_builder",
            action = "move_card",
            card_name = card.name,
            source = source
        }
    }
    button.style.width = 200
end


-- Function to update the left frame with equipped cards
local function updateLeftFrame(player, leftFrame)
    leftFrame.clear()
    local equippedScrollPane = gui.add(leftFrame, {type="scroll-pane", name="Dto_equipped_scroll_pane", direction="vertical", style="flib_shallow_scroll_pane"})
    for index, card in ipairs(global.equipped_cards) do
        createCardButton(equippedScrollPane, card, index, "equipped_cards")
    end
end

-- Function to update the bottom right frame with player's deck
local function updateBottomRightFrame(player, bottomRightFrame)
    bottomRightFrame.clear()
    local playerDeckScrollPane = gui.add(bottomRightFrame, {type="scroll-pane", name="Dto_player_deck_pane", direction="vertical", style="flib_shallow_scroll_pane"})
    for index, card in ipairs(global.player_deck) do
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
    elseif event.element.valid and event.element.tags.gui == "deck_builder" then
        local action = event.element.tags
        if action.action == "move_card" then
            local card_name = action.card_name
            local source = action.source
            if source == "player_deck" then
                -- Move the card from player_deck to equipped_cards
                for index, card in ipairs(global.player_deck) do
                    if card.name == card_name then
                        table.remove(global.player_deck, index)
                        table.insert(global.equipped_cards, card)
                        break
                    end
                end
            else
                -- Move the card from equipped_cards to player_deck
                for index, card in ipairs(global.equipped_cards) do
                    if card.name == card_name then
                        table.remove(global.equipped_cards, index)
                        table.insert(global.player_deck, card)
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
    end
end)