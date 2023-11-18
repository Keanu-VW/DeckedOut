--Decktorio gui prefix = Dto

local equippedCards = {}
local inventoryCards = {}

table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})
table.insert(equippedCards, {name = "Loot and Scoot", func = nil})
table.insert(equippedCards, {name = "Run and Gun", func = nil})
table.insert(equippedCards, {name = "Stumble", func = nil})
table.insert(equippedCards, {name = "Crumble", func = nil})

--[[Left frame: List of selected cards for the next run]]--
local function updateLeftFrame(player, Dto_left_frame)
    Dto_left_frame.clear()

    Dto_left_frame.add{type="frame", direction="horizontal", caption="Equipped Cards: ", style = "Dto_toolbar_style"}

    local Dto_equipped_scroll_pane = Dto_left_frame.add{type="scroll-pane", name="Dto_left_scroll_pane", direction="vertical"}

    local cardNumber = 0

    for _, cardData in pairs(equippedCards) do
        local Dto_card_content_frame = Dto_equipped_scroll_pane.add{type="frame", name="Dto_card_frame_" ..cardNumber, direction="vertical", style="Dto_card_frame"}
        local Dto_card = Dto_card_content_frame.add{
            type="button",
            caption="Card: " .. cardData.name,
            name="Dto_left_card_button_" .. cardData.name,
            style="Dto_card_button"
        }
        cardNumber = cardNumber + 1
    end
end

-- Button to open the dectorio deck editor
script.on_event(defines.events.on_player_created, function(event)
    -- Get the player
    local player = game.get_player(event.player_index)
    --Add button to screen top left (Layer 0)
    player.gui.top.add{
        type = "button",
        name = "Dto_Decktorio",
        caption = "Dectorio"
    }
end)

script.on_event(defines.events.on_gui_click, function(event)
    -- Get the player
    local player = game.get_player(event.player_index)

    -- Check if the clicked gui element was the Decktorio button
    if event.element.name == "Dto_Decktorio" then

        if player.gui.screen["Decktorio_Deck_Builder"] then
            -- If open, close it
            player.gui.screen["Decktorio_Deck_Builder"].destroy()
        else
            -- Create base gui element (Layer 0)
            local Dto_base = player.gui.screen

            -- Add a main frame (Layer 1)
            local Dto_frame = Dto_base.add{type="frame", name="Decktorio_Deck_Builder", caption="Decktorio Deck Builder"}
                -- Style main frame (Layer 1)
                Dto_frame.style.size = {800, 800}
                Dto_frame.auto_center = true

            local Dto_content_frame = Dto_frame.add{type="flow", name="Dto_content_frame", direction="horizontal"}

                local Dto_left_frame = Dto_content_frame.add{type="frame", name="Dto_left_frame", direction="vertical", style="Dto_content_frame"}

                local Dto_right_frame = Dto_content_frame.add{type="flow", name="Dto_right_frame", direction="vertical"}

                        -- Add two frames in the right frame, each taking up half of the height
                    local Dto_upper_right_frame = Dto_right_frame.add{type="frame", name="Dto_upper_right_frame", direction="horizontal", style="Dto_content_frame"}
                    local Dto_lower_right_frame = Dto_right_frame.add{type="frame", name="Dto_lower_right_frame", direction="vertical", style="Dto_content_frame"}

                    updateLeftFrame(player, Dto_left_frame)
        end
    end
end)