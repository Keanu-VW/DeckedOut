require("scripts/Global.lua")
require("scripts/CardsLogic/cards.lua")
require("scripts/Gui/GuiController.lua")
require("scripts/GameLogic/Controller.lua")

script.on_init(function(event)
    -- Command to generate the new surface and teleport the player
    commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
        local player = game.get_player(command.player_index)  -- Get the player who ran the command
        game.print("Turning matrix into new surface")
        on_game_start(player, 400)
    end)
end)

