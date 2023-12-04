--[[
    1) Setting up stage:
        Spawn artifact
        teleport player

    2) Game stage:
        Check if player has artifact and is standing on spawn
        spawn in enemies
        break apart the map
]]--

global.cards = require("cards")
global.player_deck = {}
table.insert(global.player_deck, global.cards["Sneak"])
table.insert(global.player_deck, global.cards["Sneak"])
table.insert(global.player_deck, global.cards["Sneak"])
table.insert(global.player_deck, global.cards["Stability"])
table.insert(global.player_deck, global.cards["Stability"])
table.insert(global.player_deck, global.cards["Stability"])
table.insert(global.player_deck, global.cards["Debris Removal"])
table.insert(global.player_deck, global.cards["Debris Removal"])
table.insert(global.player_deck, global.cards["Debris Removal"])



function starting_game(player,dungeon_surface,room_matrix,map_size)
    local player = player
    local dungeon_surface = dungeon_surface
    local room_matrix = room_matrix
    local map_size = map_size

-- 1) Setting up stage
    -- Spawn player
    local spawnX, spawnY
    for x = math.ceil(map_size/4), math.ceil(map_size/2) do
        for y = math.ceil(map_size/4), math.ceil(map_size/2) do
            if (
                room_matrix[x + 1][y + 1] +
                room_matrix[x + 1][y] +
                room_matrix[x + 1][y - 1] +
                room_matrix[x][y + 1] +
                room_matrix[x][y] +
                room_matrix[x][y - 1] +
                room_matrix[x - 1][y + 1] +
                room_matrix[x - 1][y] +
                room_matrix[x - 1][y - 1]
            ) == 9 then
                spawnX, spawnY = x, y
                goto stop
            end
        end
    end
    ::stop::

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
    for x = math.ceil(map_size/4) + math.ceil(map_size/4), math.ceil(map_size/2) + math.ceil(map_size/2) do
        for y = math.ceil(map_size/4)* 2, math.ceil(map_size/2) * 2 do
            if (
                room_matrix[x + 1][y + 1] +
                room_matrix[x + 1][y] +
                room_matrix[x + 1][y - 1] +
                room_matrix[x][y + 1] +
                room_matrix[x][y] +
                room_matrix[x][y - 1] +
                room_matrix[x - 1][y + 1] +
                room_matrix[x - 1][y] +
                room_matrix[x - 1][y - 1]
            ) == 9 then
                artifactX, artifactY = x, y
                goto spawnArtifact
            end
        end
    end
    ::spawnArtifact::

    dungeon_surface.spill_item_stack({artifactX, artifactY}, {name = "slimeArtifact", count = 1})

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
            end
        end
    end

    local tickCounter = 0
    script.on_event(defines.events.on_tick, function(event)
        -- 60 ticks == 1 second
        tickCounter = tickCounter + 1

        if tickCounter % 32 == 0 then
            checkForPlayerEnding()
        end

        -- 60 * 20
        if tickCounter % 1200 == 0 then
            -- If playerDeck empty -> insert clank and crumble card
            local randomCardSelect = math.random(1, 3)
            if randomCardSelect == 1 then
                table.insert(global.player_deck, global.cards["Clank"])
            elseif randomCardSelect == 2 then
                table.insert(global.player_deck, global.cards["Crumble"])
            else
                table.insert(global.player_deck, global.cards["Debris"])
            end

            -- Shuffle Deck
            for i = #global.player_deck, 2, -1 do
                local j = math.random(i)
                global.player_deck[i], global.player_deck[j] = global.player_deck[j], global.player_deck[i]
            end

            -- Play card
            if global.player_deck[1].name == "Crumble" and global.CrumbleBlock > 0 then
                game.print("Blocked Crumble")
                table.remove(global.player_deck, 1)
                global.CrumbleBlock = global.CrumbleBlock - 1
            elseif global.player_deck[1].name == "Clank" and global.clankBlock > 0 then
                game.print("Blocked Clank")
                table.remove(global.player_deck, 1)
                global.clankBlock = global.clankBlock - 1
            elseif global.player_deck[1].name == "Debris" and global.debrisBlock > 0 then
                game.print("Blocked Debris")
                table.remove(global.player_deck, 1)
                global.debrisBlock = global.debrisBlock - 1
            else
                global.player_deck[1].func()
                table.remove(global.player_deck, 1)
            end
        end

        if tickCounter > 1000000 then
            tickCounter = 0
        end
    end)
end