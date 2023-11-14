require("scripts/createMatrix.lua")
require("scripts/turnMatrixIntoMap.lua")
require("scripts/roomBuilder.lua")

-- Command to generate the new surface and teleport the player
commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
    local player = game.get_player(command.player_index)  -- Get the player who ran the command

    local map_size = 80 -- Set the map size

    game.print("Creating matrix")
    local map_matrix = generate_map_matrix(map_size)  -- Assume createMatrix is already defined and generates your matrix

    game.print("Turning matrix into new surface")
    local dungeon_surface = generate_dungeon_floor(map_matrix, map_size)

    for x = 1, map_size do
        for y = 1, map_size do
            if map_matrix[x][y] == 4 then
                player.teleport({x,y}, dungeon_surface)
            end
        end
    end
end)

-- Define the roomBuilder command
commands.add_command("roomBuilder", "Builds a room using the roomBuilder function", function(cmd)
    -- Get the player who ran the command
    local player = game.players[cmd.player_index]

    -- Call the roomBuilder function
    roomBuilder(player)
end)