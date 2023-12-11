function starting_game(player,dungeon_surface,room_matrix,map_size)
    local player = player
    local dungeon_surface = dungeon_surface
    local room_matrix = room_matrix
    local map_size = map_size

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
            if player_inventory.get_item_count("slimeArtifact") > 0 then
                game.print("Got the artifact, ending dungeon run...")
                gameEnd(player, dungeon_surface)
            end
        end
    end
    
    local tickCounter = 0
    global.is_game_running = true
    script.on_event(defines.events.on_tick, function(event)
        if not global.is_game_running then
            return
        end
        -- 60 ticks == 1 second
        tickCounter = tickCounter + 1

        if tickCounter % 32 == 0 then
            checkForPlayerEnding()
            updateDungeonGui(player)
        end

        -- 60 * 20 = 1200
        if tickCounter % 60 == 0 then
            -- insert clank or crumble card or debris
            local randomCardSelect = math.random(1, 3)
            if randomCardSelect == 1 then
                table.insert(global.equipped_cards, global.cards["Clank"])
            elseif randomCardSelect == 2 then
                table.insert(global.equipped_cards, global.cards["Crumble"])
            else
                table.insert(global.equipped_cards, global.cards["Debris"])
            end

            -- Shuffle Deck
            for i = #global.equipped_cards, 2, -1 do
                local j = math.random(i)
                global.equipped_cards[i], global.equipped_cards[j] = global.equipped_cards[j], global.equipped_cards[i]
            end

            -- Play card
            if global.equipped_cards[1].name == "Crumble" and global.CrumbleBlock > 0 then
                game.print("Blocked Crumble")
                table.remove(global.equipped_cards, 1)
                global.CrumbleBlock = global.CrumbleBlock - 1
            elseif global.equipped_cards[1].name == "Clank" and global.clank_block > 0 then
                game.print("Blocked Clank")
                table.remove(global.equipped_cards, 1)
                global.clank_block = global.clank_block - 1
            elseif global.equipped_cards[1].name == "Debris" and global.debrisBlock > 0 then
                game.print("Blocked Debris")
                table.remove(global.equipped_cards, 1)
                global.debrisBlock = global.debrisBlock - 1
            else
                global.equipped_cards[1].func()
                table.remove(global.equipped_cards, 1)
            end
        end

        if tickCounter > 1000000 then
            tickCounter = 0
        end
    end)
end


commands.add_command("card", "Execute a card", function(command)
    -- Get the name of the card from the command parameters
    local card_name = command.parameter

    -- Check if the card exists in the global cards table
    if global.cards[card_name] then
        -- Execute the card's function
        global.cards[card_name].func()
        game.print("Executed card: " .. card_name)
    else
        -- Print an error message if the card does not exist
        game.print("Card not found: " .. card_name)
    end
end)

commands.add_command("cards", "Print all existing cards", function()
    -- Loop over the cards in the global cards table
    for card_name, card in pairs(global.cards) do
        -- Print the name of each card
        game.print(card_name)
    end
end)