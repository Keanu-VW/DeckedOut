require("scripts/createMatrix.lua")
require("scripts/turnMatrixIntoMap.lua")

-- Command to generate the new surface and teleport the player
commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
    local player = game.get_player(command.player_index)  -- Get the player who ran the command

    local map_size = 800 -- Set the map size

    game.print("Creating matrix")
    local map_matrix = generate_map_matrix(map_size)  -- Assume createMatrix is already defined and generates your matrix

    game.print("Turning matrix into new surface")
    local dungeon_surface = generate_dungeon_floor(map_matrix, map_size)

    for x = (map_size/2), map_size do
        for y = (map_size/2), map_size do
            if map_matrix[x][y] == 1 then
                player.teleport({x,y}, dungeon_surface)
                goto stop
            end
        end
    end
    ::stop::
end)