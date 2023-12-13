gui = require("__flib__/gui.lua")

function createShopGui(player)
    -- Create a frame
    local frame = player.gui.screen.add{
        type = "frame",
        name = "shop_frame",
        caption = "Shop",
        direction = "vertical"
    }

    -- Center the frame on the screen
    frame.location = {player.display_resolution.width / 2, player.display_resolution.height / 2}
    frame.style.size = {400, 400}

    -- Add a flow to hold the close button
    local title_flow = frame.add{
        type = "flow",
        name = "title_flow",
        direction = "horizontal"
    }

    -- Add a filler to push the close button to the right
    title_flow.add{
        type = "empty-widget",
        style = "draggable_space_header",
    }.drag_target = frame

    -- Add the close button
    title_flow.add{
        type = "sprite-button",
        name = "close_button",
        sprite = "utility/close_white",
        style = "frame_action_button"
    }
    
    frame.add{
        type = "frame",
        name = "shop_content",
        direction = "vertical",
        style = "inside_shallow_frame_with_padding"
    }
    
    script.on_event(defines.events.on_gui_click, function(event)
        local player = game.players[event.player_index]
        local element = event.element

        if element.name == "close_button" then
            player.gui.screen["shop_frame"].destroy()
        end
    end)
end

commands.add_command("shop", "Open the shop GUI", function(command)
    -- Get the player who issued the command
    local player = game.players[command.player_index]

    -- Check if the shop GUI already exists
    if player.gui.screen["shop_frame"] then
        -- If it does, destroy it
        player.gui.screen["shop_frame"].destroy()
    end

    -- Open the shop GUI
    createShopGui(player)
end)
