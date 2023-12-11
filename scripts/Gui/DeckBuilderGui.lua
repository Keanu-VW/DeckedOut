-- Import necessary libraries
gui = require("__flib__/gui.lua")

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
    button.style.height = 30
end


-- Function to update the left frame with equiped cards
local function updateLeftFrame(player, leftFrame)
    leftFrame.clear()
    local equipedScrollPane = gui.add(leftFrame, {type="scroll-pane", name="Dto_equiped_scroll_pane", direction="vertical", style="flib_shallow_scroll_pane"})
    if global.DTO.equiped_cards ~= nil then
        for index, card in ipairs(global.DTO.equiped_cards) do
            createCardButton(equipedScrollPane, card, index, "equiped_cards")
        end
    end
end

-- Function to update the bottom right frame with player's deck
local function updateBottomRightFrame(player, bottomRightFrame)
    bottomRightFrame.clear()
    local playerDeckScrollPane = gui.add(bottomRightFrame, {type="scroll-pane", name="Dto_player_deck_pane", direction="vertical", style="flib_shallow_scroll_pane"})
    if global.DTO.inventory_cards ~= nil then
        for index, card in ipairs(global.DTO.inventory_cards) do
            createCardButton(playerDeckScrollPane, card, index, "player_deck")
        end
    end
end

-- Function to create the Deck Builder GUI
local function createDeckBuilderGui(player)
    local status, err = pcall(function()
        local base = player.gui.screen
        local mainFrame = gui.add(base, {type="frame", name="Decktorio_Deck_Builder", styles="outer_frame"})
        mainFrame.style.size = {800, 800}
        mainFrame.auto_center = true

        -- Add a flow to hold the title_flow and contentFrame
        local mainFlow = mainFrame.add{
            type = "flow",
            name = "main_flow",
            direction = "vertical"
        }

        -- Add a flow to hold the close button
        local title_flow = mainFlow.add{
            type = "flow",
            name = "title_flow",
            direction = "horizontal",
            style = "flib_titlebar_flow"
        }
        title_flow.style.horizontally_stretchable = true

        local title = title_flow.add{
            type = "label",
            name = "title",
            caption = "Dectorio Deck Builder",
            style = "frame_title"
        }

        -- Add a filler to push the close button to the right
        local filler = title_flow.add{
            type = "empty-widget",
            style = "draggable_space"
        }
        filler.style.horizontally_stretchable = true
        filler.drag_target = mainFrame
        filler.style.height = 24

        -- Add the close button
        title_flow.add{
            type = "sprite-button",
            name = "close_button",
            sprite = "utility/close_white",
            style = "frame_action_button"
        }

        local contentFrame = mainFlow.add({type="flow", name="Dto_content_frame", direction="horizontal"})
        local leftFrame = gui.add(contentFrame, {type="frame", name="Dto_left_frame", direction="vertical", style="flib_shallow_frame_in_shallow_frame"})
        leftFrame.style.horizontally_stretchable = true
        leftFrame.style.vertically_stretchable = true

        local rightFrame = gui.add(contentFrame, {type="flow", name="Dto_right_frame", direction="vertical"})
        local upperRightFrame = gui.add(rightFrame, {type="frame", name="Dto_upper_right_frame", direction="horizontal", style="flib_shallow_frame_in_shallow_frame"})
        upperRightFrame.style.horizontally_stretchable = true
        upperRightFrame.style.vertically_stretchable = true
        upperRightFrame.style.vertically_squashable = false

        local lowerRightFrame = gui.add(rightFrame, {type="frame", name="Dto_lower_right_frame", direction="vertical", style="flib_shallow_frame_in_shallow_frame"})
        lowerRightFrame.style.horizontally_stretchable = true
        lowerRightFrame.style.vertically_stretchable = true

        updateLeftFrame(player, leftFrame)
        updateBottomRightFrame(player, lowerRightFrame)
    end)
    if not status then
        game.print("Error while creating Deck Builder Gui: " .. err)
    end
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
    end
end

local function destroyDeckBuilderButton(player)
    local button = player.gui.top["Dto_Decktorio"]
    if button then
        button.destroy()
    end
end

-- Event handler for GUI click
script.on_event(defines.events.on_gui_click, function(event)
    local player = game.get_player(event.player_index)

    if event.element.name == "Dto_Decktorio" then
        if player.gui.screen["Decktorio_Deck_Builder"] then
            player.gui.screen["Decktorio_Deck_Builder"].destroy()
        else
            createDeckBuilderGui(player)
        end
    elseif event.element.name == "close_button" then
        -- Close the Deck Builder GUI when the close button is clicked
        if player.gui.screen["Decktorio_Deck_Builder"] then
            player.gui.screen["Decktorio_Deck_Builder"].destroy()
        end
    elseif event.element.valid and event.element.tags.gui == "deck_builder" then
        local action = event.element.tags
        if action.action == "move_card" then
            game.print("Moving Card")
            local card_name = action.card_name
            local source = action.source
            if source == "player_deck" then
                game.print("Source: "..source)
                -- Move the card from player_deck to equiped_cards
                for index, card in ipairs(global.DTO.inventory_cards) do
                    if card.name == card_name then
                        table.remove(global.DTO.inventory_cards, index)
                        table.insert(global.DTO.equiped_cards, card)
                        break
                    end
                end
            else
                game.print("Source: "..source)
                -- Move the card from equiped_cards to player_deck
                for index, card in ipairs(global.DTO.equiped_cards) do
                    if card.name == card_name then
                        table.remove(global.DTO.equiped_cards, index)
                        table.insert(global.DTO.inventory_cards, card)
                        break
                    end
                end
            end
            -- Update the frames
            local leftFrame = player.gui.screen["Decktorio_Deck_Builder"].main_flow.Dto_content_frame.Dto_left_frame
            local lowerRightFrame = player.gui.screen["Decktorio_Deck_Builder"].main_flow.Dto_content_frame.Dto_right_frame.Dto_lower_right_frame
            updateLeftFrame(player, leftFrame)
            updateBottomRightFrame(player, lowerRightFrame)
        end
    end
end)

return {
    createDeckBuilderButton = createDeckBuilderButton,
    destroyDeckBuilderButton = destroyDeckBuilderButton
}