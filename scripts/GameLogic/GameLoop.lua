﻿local function starting_game(player, dungeon_surface,room_matrix,map_size, game_running)
    -- Set up game, spawn player, spawn artifact, create gui
    
    -- 1) Setting up stage
    -- Decide spawn location for player
    local spawnTopLeft = math.random() < 0.5

    -- Spawn player
    local spawnX, spawnY
    repeat
        spawnX = math.ceil(map_size/4)
        spawnY = spawnTopLeft and math.random(1, math.ceil(map_size/2)) or math.random(math.ceil(map_size/2)+1, map_size)
    until room_matrix[spawnX][spawnY] == 1

    -- Teleport player
    player.teleport({spawnX, spawnY}, dungeon_surface)

    -- Set tiles to concrete
    local all_tiles = {}
    for i = -1, 1 do
        for j = -1, 1 do
            table.insert(all_tiles, {name = "concrete", position = {spawnX + i, spawnY + j}})
        end
    end
    dungeon_surface.set_tiles(all_tiles)

    -- Spawn artifact
    local artifactX, artifactY
    repeat
        artifactX = math.ceil(map_size*3/4)
        artifactY = spawnTopLeft and math.random(math.ceil(map_size/2)+1, map_size) or math.random(1, math.ceil(map_size/2))
    until room_matrix[artifactX][artifactY] == 1

    dungeon_surface.spill_item_stack({artifactX, artifactY}, {name = "slimeArtifact", count = 1})

    global.DTO.createDungeonGui(player)

    
    -- Game end function --
    local function checkForPlayerEnding()
        local player_position = player.position

        -- Check if player is in the spawn area
        if (
                player_position.x >= spawnX - 1 and
                        player_position.x <= spawnX + 1 and
                        player_position.y >= spawnY - 1 and
                        player_position.y <= spawnY + 1
        ) then
            local player_inventory = player.get_main_inventory()
            if player_inventory.get_item_count("slimeArtifact") > 0 then
                game.print("Got the artifact, ending dungeon run...")
                gameEnd(player, dungeon_surface)
                    player.teleport({0,0}, game.surfaces["nauvis"])
                    dungeon_surface.clear()
                    global.DTO.dungeonGui.deleteDungeonGui(player)
                    global.DTO.shopGui.createShopGui(player)
            end
        end
    end

    -- 2) Game stage
    local deck = global.DTO.equipped_cards
    local crumble_block = 0
    local clank_block = 0
    local debris_block = 0

    local tickCounter = 0
    game_running = true
    script.on_event(defines.events.on_tick, function(event)
        if not global.game_running then
            return
        end
        -- 60 ticks == 1 second
        tickCounter = tickCounter + 1

        if tickCounter % 32 == 0 then
            checkForPlayerEnding()
            global.DTO.gui.dungeonGui.updateDungeonGui(player, crumble_block, clank_block, debris_block)
        end

        -- 60 * 20 = 1200
        if tickCounter % 60 == 0 then
            -- insert clank or crumble or debris card
            local randomCardSelect = math.random(1, 3)
            if randomCardSelect == 1 then
                table.insert(deck, global.DTO.cards["Clank"])
            elseif randomCardSelect == 2 then
                table.insert(deck, global.DTO.cards["Crumble"])
            else
                table.insert(deck, global.DTO.cards["Debris"])
            end

            -- Shuffle Deck
            for i = #deck, 2, -1 do
                local j = math.random(i)
                deck[i], deck[j] = deck[j], deck[i]
            end

            -- Play card
            if deck[1].name == "Crumble" and crumble_block > 0 then
                game.print("Blocked Crumble")
                table.remove(deck, 1)
                crumble_block = crumble_block - 1
            elseif deck[1].name == "Clank" and clank_block > 0 then
                game.print("Blocked Clank")
                table.remove(deck, 1)
                clank_block = clank_block - 1
            elseif deck[1].name == "Debris" and debris_block > 0 then
                game.print("Blocked Debris")
                table.remove(deck, 1)
                debris_block = debris_block - 1
            else
                deck[1].func()
                table.remove(deck, 1)
            end
        end

        if tickCounter > 1000000 then
            tickCounter = 0
        end
    end)
end

return { 
    starting_game = starting_game
}
