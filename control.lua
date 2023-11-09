require("scripts/createMatrix.lua")
require("scripts/turnMatrixIntoMap.lua")
require("scripts/roomBuilder.lua")

-- Command to generate the new surface and teleport the player
commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
    local player = game.get_player(command.player_index)  -- Get the player who ran the command

    local tile_size = 64

    game.print("Creating matrix")
    local matrix = createMatrix(12, 12)  -- Assume createMatrix is already defined and generates your matrix

    game.print("Turning matrix into new surface")
    local new_surface = turnMatrixIntoMap(matrix, tile_size)

    -- Inside the command function after the new_surface has been created
    local spawn_position = nil
    for x, row in ipairs(matrix) do
        for y, value in ipairs(row) do
            if value == 2 then
                -- Calculate the center position of the room, not the tile
                spawn_position = {x = (x - 1) * tile_size + (tile_size/2), y = (y - 1) * tile_size + (tile_size/2)}
                goto found_spawn  -- Use a goto statement to break out of both loops
            end
        end
    end
    ::found_spawn::

    if spawn_position then
        game.print("Teleporting player to spawn room")
        -- Teleport the player to the spawn position
        player.teleport(spawn_position, new_surface)
    else
        game.print("Spawn room not found, teleporting to origin")
        -- If no spawn room was found, teleport to the origin as a fallback
        player.teleport({x = 0, y = 0}, new_surface)
    end

end)

-- Define the roomBuilder command
commands.add_command("roomBuilder", "Builds a room using the roomBuilder function", function(cmd)
    -- Get the player who ran the command
    local player = game.players[cmd.player_index]

    -- Call the roomBuilder function
    roomBuilder(player)
end)