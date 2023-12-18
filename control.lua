global.GameState = {}
global.GameState.map_size = nil
global.GameState.map_matrix = nil
global.GameState.map_surface = nil
global.GameState.room_map_matrix = nil
global.GameState.crumble_block = 0
global.GameState.clank_block = 0
global.GameState.debris_block = 0
global.GameState.is_game_running = nil
global.GameState.chunks_generated = nil

global.Player = {}
global.Player.player = nil
global.Player.equipped_cards = {}
global.Player.inventory_cards = {}

global.Cards = {}

require("scripts/Cards/cards.lua")

require("scripts/Game/createMatrix.lua")
require("scripts/Game/generateDungeonSurface.lua")
require("scripts/Game/gameScript.lua")
require("scripts/Game/gameEnd.lua")

require("scripts/Gui/DeckBuilderGui.lua")
require("scripts/Gui/DungeonGui.lua")
require("scripts/Gui/shopGui.lua")


commands.add_command("run_dungeon", "Generates a new surface based on the matrix", function(command)
    global.Player.player = game.get_player(command.player_index)  -- Get the player who ran the command

    global.GameState.map_size = 400 -- Set the map size

    game.print("Creating matrix")
    generate_map_matrix()  -- Assume createMatrix is already defined and generates your matrix

    game.print("Turning matrix into new surface")
    global.GameState.map_surface = generate_dungeon_floor()
    
    starting_game()
    
end)