gui = require("__flib__/gui.lua")

local function createShopGui(player)
    -- Create a frame
    local shopFrame = player.gui.screen.add{
        type = "frame",
        name = "shop_unique_frame",
        direction = "vertical"
    }

    -- Center the frame on the screen
    shopFrame.location = {player.display_resolution.width / 2, player.display_resolution.height / 2}
    shopFrame.style.size = {400, 400}

    -- Add a flow to hold the close button
    local shopTitleFlow = shopFrame.add{
        type = "flow",
        name = "shop_title_flow",
        direction = "horizontal"
    }

    shopTitleFlow.add{
        type = "label",
        name = "shop_title",
        caption = "Shop",
        style = "frame_title"}

    -- Add a filler to push the close button to the right
    local shopFiller = shopTitleFlow.add{
        type = "empty-widget",
        style = "draggable_space"
    }
    shopFiller.style.horizontally_stretchable = true
    shopFiller.drag_target = shopFrame
    shopFiller.style.height = 24

    -- Add the close button
    shopTitleFlow.add{
        type = "sprite-button",
        name = "shop_close_button",
        sprite = "utility/close_white",
        style = "frame_action_button"
    }

    shopFrame.add{
        type = "frame",
        name = "shop_content_unique",
        direction = "vertical",
        style = "inside_shallow_frame_with_padding"
    }

    script.on_event(defines.events.on_gui_click, function(event)
        local player = game.players[event.player_index]
        local element = event.element

        if element.name == "shop_close_button" then
            player.gui.screen["shop_unique_frame"].destroy()
        end
    end)
end

return {
    createShopGui = createShopGui
}
