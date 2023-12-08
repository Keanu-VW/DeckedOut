require("scripts/sharedData.lua")
require("scripts/cards.lua")
require("scripts/DeckBuilderGui.lua")
require("scripts/DungeonGui.lua")
require("scripts/shopGui.lua")

require("scripts/createMatrix.lua")
require("scripts/generateDungeonSurface.lua")
require("scripts/gameScript.lua")
require("scripts/gameEnd.lua")

script.on_init(function(event)
    -- Command to generate the new surface and teleport the player
    commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
        local player = game.get_player(command.player_index)  -- Get the player who ran the command

        global.map_size = 400 -- Set the map size

        game.print("Creating matrix")
        generate_map_matrix(global.map_size)  -- Assume createMatrix is already defined and generates your matrix

        game.print("Turning matrix into new surface")
        global.map_surface = generate_dungeon_floor(global.map_matrix, global.map_size)

        starting_game(player, global.map_surface, global.room_map_matrix, global.map_size)
    end)
end)

