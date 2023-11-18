--[[
    1) Setting up stage:
        Spawn artifact
        teleport player

    2) Game stage:
        Check if player has artifact and is standing on spawn
        spawn in enemies
        break apart the map
]]--








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

    local playerDeck = {}

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

    local function clank()
        local success = false
        while success == false do
            local spitterX, spitterY = math.random(1, map_size), math.random(1, map_size)
            if room_matrix[spitterX][spitterY] == 1 then
                dungeon_surface.create_entity({name = "small-spitter", position = {x = spitterX, y = spitterY}})
                dungeon_surface.create_entity({name = "medium-spitter", position = {x = spitterX, y = spitterY}})
                dungeon_surface.create_entity({name = "big-spitter", position = {x = spitterX, y = spitterY}})
                dungeon_surface.create_entity({name = "behemoth-spitter", position = {x = spitterX, y = spitterY}})
                success = true
                game.print("Clank")
            end
        end
    end

    local function crumble()
        local crumble_size = 10
        local crumble_matrix = {}
        for x = 1, crumble_size do
            crumble_matrix[x] = {}
            for y = 1, crumble_size do
                crumble_matrix[x][y] = math.random(0, 1)
            end
        end
        for x = 2, crumble_size - 2 do
            for y = 2, crumble_size - 2 do
                crumble_matrix[x][y] = 1
            end
        end
        for cycles = 1, 10 do
            for x = 2, crumble_size - 1 do
                for y = 2, crumble_size - 1 do
                    local cellHealth =
                        crumble_matrix[x+1][y+1] +
                        crumble_matrix[x+1][y] +
                        crumble_matrix[x+1][y-1] +
                        crumble_matrix[x][y+1] +
                        crumble_matrix[x][y-1] +
                        crumble_matrix[x-1][y+1] +
                        crumble_matrix[x-1][y] +
                        crumble_matrix[x-1][y-1]
                    if crumble_matrix[x][y] == 1 and cellHealth >= 4 then
                        crumble_matrix[x][y] = 1
                    elseif crumble_matrix[x][y] == 0 and cellHealth >= 5 then
                        crumble_matrix[x][y] = 1
                    else
                        crumble_matrix[x][y] = 0
                    end
                end
            end
        end

        local success = false
        while success == false do
            local crumbleX, crumbleY = math.random(crumble_size, map_size - crumble_size), math.random(crumble_size, map_size - crumble_size)
            player.surface.create_entity{
                name = "falling-rock",
                position = {crumbleX, crumbleY},
                force = game.forces["enemy"]
            }
            for x = 1, crumble_size do
                for y = 1, crumble_size do
                    if room_matrix[crumbleX + x - 1][crumbleY + y - 1] == 0 then
                        if crumble_matrix[x][y] == 1 then
                            dungeon_surface.set_tiles({{name = "out-of-map", position = {x = crumbleX + x - 1, y = crumbleY + y - 1}}})
                            success = true
                        end
                    end
                end
            end
        end

        game.print("Crumble")
    end

    for i = 1, 10 do
        table.insert(playerDeck, clank)
        table.insert(playerDeck, crumble)
    end

    local tickCounter = 0
    local speedUpGame = 1000
    script.on_event(defines.events.on_tick, function(event)
        -- 60 ticks == 1 second
        tickCounter = tickCounter + 1

        if tickCounter % 32 == 0 then
            checkForPlayerEnding()
            if speedUpGame < 1180 then
                speedUpGame = speedUpGame + 10
            end
        end

        -- 60 * 20
        if tickCounter % (1200-speedUpGame) == 0 then
            -- If playerDeck empty -> insert clank and crumble card
            if math.random(1, 2) == 1 then
                table.insert(playerDeck, clank)
            else
                table.insert(playerDeck, crumble)
            end
            -- Shuffle Deck
            for i = #playerDeck, 2, -1 do
                local j = math.random(i)
                playerDeck[i], playerDeck[j] = playerDeck[j], playerDeck[i]
            end
            -- Play card
            playerDeck[1]()
        end

        if tickCounter > 1000000 then
            tickCounter = 0
        end
    end)

end