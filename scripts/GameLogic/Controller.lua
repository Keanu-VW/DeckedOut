local Setup = require("scripts/GameLogic/Setup.lua")
local GameLoop = require("scripts/GameLogic/GameLoop.lua")

function on_game_start(player, map_size)
    local game_running = false
    local map_matrix, room_map_matrix = Setup.generate_map_matrix(map_size)
    local dungeon_surface = Setup.generate_dungeon_floor(map_matrix, map_size)
    GameLoop.starting_game(player, dungeon_surface,room_map_matrix,map_size, game_running)
end