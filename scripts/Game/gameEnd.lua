function gameEnd(player, dungeon_surface)
    player.teleport({0,0}, game.surfaces["nauvis"])
    dungeon_surface.clear()
    global.is_game_running = false
    deleteDungeonGui(player)
    createShopGui(player)
    --[[
        1) Teleport player back to main surface
        2) Destroy the dungeon surface
        3) Stop the game
        4) Destroy the dungeon GUI
        5) Create shop GUI
    ]]--
end