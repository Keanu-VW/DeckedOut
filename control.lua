require("scripts/createMatrix.lua")
require("scripts/turnMatrixIntoMap.lua")
require("scripts/gameScript.lua")
require("scripts/cardSystem.lua")
require("scripts/GUI.lua")


-- Falling rock test
commands.add_command("fallingRock", "Summon the falling rock explosion above the player", function()
    for _, player in pairs(game.players) do
        if player.connected then
            local player_position = player.position
            local explosion_position = {player_position.x, player_position.y - 5}  -- Adjust the Y offset as needed

            -- Create the explosion on the surface
            player.surface.create_entity{
                name = "falling-rock",
                position = explosion_position,
                force = game.forces["enemy"]
            }
        end
    end
end)




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