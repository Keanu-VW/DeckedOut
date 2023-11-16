require("scripts/createMatrix.lua")
require("scripts/turnMatrixIntoMap.lua")
require("scripts/gameScript.lua")
require("scripts/cardSystem.lua")

-- Command to generate the new surface and teleport the player
commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
    local player = game.get_player(command.player_index)  -- Get the player who ran the command

    local map_size = 800 -- Set the map size

    game.print("Creating matrix")
    local map_matrix, room_matrix = generate_map_matrix(map_size)  -- Assume createMatrix is already defined and generates your matrix

    game.print("Turning matrix into new surface")
    local dungeon_surface = generate_dungeon_floor(map_matrix, map_size)

    starting_game(player,dungeon_surface,room_matrix,map_size)

end)

--Decktorio gui prefix = Dto

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

            local Dto_content_frame = Dto_frame.add{type="frame", name="Dto_content_frame", direction="horizontal", style="Dto_content_frame"}

                local Dto_left_frame = Dto_content_frame.add{type="frame", name="Dto_left_frame", direction="vertical", style="Dto_content_frame"}

                local Dto_right_frame = Dto_content_frame.add{type="flow", name="Dto_right_frame", direction="vertical"}

                        -- Add two frames in the right frame, each taking up half of the height
                    local Dto_upper_right_frame = Dto_right_frame.add{type="frame", name="Dto_upper_right_frame", direction="horizontal", style="Dto_content_frame"}
                    local Dto_lower_right_frame = Dto_right_frame.add{type="frame", name="Dto_lower_right_frame", direction="vertical", style="Dto_content_frame"}
        end
    end
end)