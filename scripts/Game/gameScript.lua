
--[[
    1) Setting up stage:
        Spawn artifact
        teleport player

    2) Game stage:
        Check if player has artifact and is standing on spawn
        spawn in enemies
        break apart the map
]]--





function starting_game()
    local player = global.Player.player
    local dungeon_surface = global.GameState.map_surface
    local room_matrix = global.GameState.room_map_matrix
    local map_size =global.GameState.map_size
    
    -- 1) Setting up stage
    -- Decide spawn location for player
    local spawnTopLeft = math.random() < 0.5

    -- Spawn player
    local spawnX, spawnY
    repeat
        spawnX = math.ceil(map_size/4)
        spawnY = spawnTopLeft and math.random(1, math.ceil(map_size/2)) or math.random(math.ceil(map_size/2)+1, map_size)
    until room_matrix[spawnX][spawnY] == 1
    
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

    dungeon_surface.spill_item_stack({artifactX, artifactY}, {name = "alienEgg", count = 1})

    createDungeonGui(player)
    
-- 2) Game stage
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
            if player_inventory.get_item_count("alienEgg") > 0 then
                game.print("Got the artifact, ending dungeon run...")
                gameEnd(player, dungeon_surface)
            end
        end
    end
    
    local Deck = global.Player.equipped_cards
    local tickCounter = 0
    global.GameState.is_game_running = true
    script.on_event(defines.events.on_tick, function(event)
        if not global.GameState.is_game_running then
            return
        end
        -- 60 ticks == 1 second
        tickCounter = tickCounter + 1

        if tickCounter % 32 == 0 then
            updateDungeonGui(player)
            checkForPlayerEnding()
        end
        
        -- 60 * 20 = 1200
        if tickCounter % 60 == 0 then
            -- insert clank or crumble card or debris
            local randomCardSelect = math.random(1, 3)
            if randomCardSelect == 1 then
                table.insert(Deck, global.Cards["Clank"])
            elseif randomCardSelect == 2 then
                table.insert(Deck, global.Cards["Crumble"])
            else
                table.insert(Deck, global.Cards["Debris"])
            end

            -- Shuffle Deck
            for i = #Deck, 2, -1 do
                local j = math.random(i)
                Deck[i], Deck[j] = Deck[j], Deck[i]
            end

            -- Play card
            if Deck[1].name == "Crumble" and global.GameState.crumble_block > 0 then
                game.print("Blocked Crumble")
                table.remove(Deck, 1)
                global.GameState.crumble_block = global.GameState.crumble_block - 1
            elseif Deck[1].name == "Clank" and global.GameState.clank_block > 0 then
                game.print("Blocked Clank")
                table.remove(Deck, 1)
                global.GameState.clank_block = global.GameState.clank_block - 1
            elseif Deck[1].name == "Debris" and global.GameState.debris_block > 0 then
                game.print("Blocked Debris")
                table.remove(Deck, 1)
                global.GameState.debris_block= global.GameState.debris_block - 1
            else
                Deck[1].func()
                table.remove(Deck, 1)
            end
        end

        if tickCounter > 1000000 then
            tickCounter = 0
        end
    end)
end

