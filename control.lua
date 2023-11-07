--[[

Rooms
    0:No room
    1:Empty Room
    2:Spawn/exit Room
    3:Artifact Spawn
    4:Enemy Spawn Room
    5:Danger Room
    6:Clanker Enemy Spawn Room
]]--

local function createMatrix(maxWidth, maxHeight)
    local floorPlanMatrix = {}
    local roomCount = 0
    local lastRoomCreatedX
    local lastRoomCreatedY

    -- Initialize the matrix with all zeros
    for x = 1, maxWidth do
        floorPlanMatrix[x] = {}
        for y = 1, maxHeight do
            floorPlanMatrix[x][y] = 0
        end
    end

    -- Start with a random cell
    local startX, startY = math.random(maxWidth), math.random(maxHeight)
    floorPlanMatrix[startX][startY] = 1
    roomCount = roomCount + 1
    local maxRoomCount = math.random(math.floor(maxWidth * 2), math.floor(maxWidth * (maxHeight/2)))

    local function spreadFrom(x, y, prevDirection)

        -- Directions: Up, Down, Left, Right
        local directions = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}}

        -- If there was a previous direction, greatly increase its priority
        if prevDirection then
            for _ = 1, 5 do -- Add the previous direction multiple times to increase its weight
                table.insert(directions, 1, prevDirection)
            end
        end

        -- Shuffle directions to allow for turns
        for i = #directions, 2, -1 do
            local j = math.random(i)
            directions[i], directions[j] = directions[j], directions[i]
        end

        -- Attempt to spread in the chosen direction
        for _, direction in ipairs(directions) do
            local newX, newY = x + direction[1], y + direction[2]
            -- Check boundaries and if the new position is available
            if newX >= 1 and newX <= maxWidth and newY >= 1 and newY <= maxHeight and floorPlanMatrix[newX][newY] == 0 then
                floorPlanMatrix[newX][newY] = 1
                lastRoomCreatedX, lastRoomCreatedY = newX, newY
                roomCount = roomCount + 1
                if roomCount < maxRoomCount then
                    -- Recursively spread from the new location
                    spreadFrom(newX, newY, direction) -- Pass the current direction as the preferred one for the next call
                    break -- Break after successful spread to favor straight paths
                end
            end
        end
    end

    local function createExtraPaths()
        -- A helper function to check if a position is within bounds and not already a room
        local function isValidPosition(x, y)
            return x >= 1 and x <= maxWidth and y >= 1 and y <= maxHeight and floorPlanMatrix[x][y] == 0
        end

        -- A helper function to dig a path in the matrix from a given starting point
        local function digPathFrom(x, y)
            local directions = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}} -- Up, Down, Left, Right
            local direction = directions[math.random(#directions)] -- Choose a random direction to dig


            -- Determine path length based on the current room count
            local pathLengthRange = (maxRoomCount < maxWidth * 3) and {2, 6} or {2, 4}
            local pathLength = math.random(table.unpack(pathLengthRange))

            for i = 1, pathLength do
                x = x + direction[1]
                y = y + direction[2]
                if isValidPosition(x, y) then
                    floorPlanMatrix[x][y] = 1 -- Dig a room
                    roomCount = roomCount + 1
                else
                    break -- If we hit a wall or existing room, stop digging
                end
            end
        end

        -- Pick two random rooms to start digging from
                local rooms = {}
        for x = 1, maxWidth do
            for y = 1, maxHeight do
                if floorPlanMatrix[x][y] == 1 then
                    table.insert(rooms, {x, y}) -- Add the room coordinates to the rooms table
                end
            end
        end

        -- Randomly choose starting rooms based on the current room count
        local startRoomCount = (maxRoomCount < maxWidth * 3) and 4 or 2  -- Choose 4 start rooms if room count is low, otherwise 2
        local chosenStartRooms = {}

        while #rooms > 0 and #chosenStartRooms < startRoomCount do
            local startRoomIndex = math.random(#rooms)
            table.insert(chosenStartRooms, rooms[startRoomIndex])
            table.remove(rooms, startRoomIndex) -- Remove the chosen room to avoid picking it again
        end

        for _, startRoom in ipairs(chosenStartRooms) do
            digPathFrom(startRoom[1], startRoom[2])
        end
    end
    -- Spread from the starting cell
    spreadFrom(startX, startY)

    createExtraPaths()

    local function assignRoomTypes()

        floorPlanMatrix[startX][startY] = 2
        floorPlanMatrix[lastRoomCreatedX][lastRoomCreatedY] = 3

    end

    assignRoomTypes()

    return floorPlanMatrix
end


-- Function to create and load the new surface
local function create_and_load_surface(matrix, tile_size)

    -- Create the new surface
    game.print("Creating new surface")
    local map_gen_settings = {
        terrain_segmentation = "very-high",
        water = "none",
        autoplace_controls = {
            ["coal"] = { frequency = "none", size = "none" },
            ["stone"] = { frequency = "none", size = "none" },
            ["copper-ore"] = { frequency = "none", size = "none" },
            ["iron-ore"] = { frequency = "none", size = "none" },
            ["uranium-ore"] = { frequency = "none", size = "none" },
            ["crude-oil"] = { frequency = "none", size = "none" },
            ["trees"] = { frequency = "none", size = "none" },
            ["enemy-base"] = { frequency = "none", size = "none" },
        },
        cliff_settings = { cliff_elevation_0 = 1024 },  -- Set cliffs to not appear
        starting_area = "none",
    }

    local new_surface = game.create_surface("new_surface" .. math.random(9999), map_gen_settings)

    for chunk in new_surface.get_chunks() do
        local area = {
            left_top = {chunk.x * 32, chunk.y * 32},
            right_bottom = {(chunk.x + 1) * 32, (chunk.y + 1) * 32}
        }
        local tiles = {}
        for x in area.left_top.x, area.right_bottom.x - 1 do
            for y in area.left_top.y, area.right_bottom.y - 1 do
                table.insert(tiles, {name = "out-of-map", position = {x, y}})
            end
        end
        new_surface.set_tiles(tiles)
    end

    game.print("Calculating bound size")
    -- Calculate the bounds based on the matrix size
    local bounds = {
        left_top = {x = 0, y = 0},
        right_bottom = {x = #matrix * tile_size, y = #matrix[1] * tile_size}
    }
    game.print("Top Left: (" .. bounds.left_top.x .. ", " .. bounds.left_top.y .. 
    ") || Bottom Right: (" .. bounds.right_bottom.x .. ", " .. bounds.right_bottom.y .. ")")

    game.print("Force Loading")
    -- Calculate the chunk area to generate based on the matrix size
    local chunk_area_to_generate = {
        left_top = {x = -1, y = -1},
        right_bottom = {x = math.ceil((#matrix * tile_size) / 32), y = math.ceil((#matrix[1] * tile_size) / 32)}
    }

    -- Request chunk generation for the entire area
    for chunk_x = chunk_area_to_generate.left_top.x, chunk_area_to_generate.right_bottom.x do
        for chunk_y = chunk_area_to_generate.left_top.y, chunk_area_to_generate.right_bottom.y do
            new_surface.request_to_generate_chunks({x = chunk_x * 32, y = chunk_y * 32}, 0)
        end
    end
    new_surface.force_generate_chunk_requests()  -- Force the generation of requested chunks

    game.print("Setting out-of-map Tiles")
    -- Set the entire area to 'out-of-map' first
    local all_tiles = {}
    for chunk in new_surface.get_chunks() do
        for x = chunk.area.left_top.x, chunk.area.right_bottom.x - 1 do
            for y = chunk.area.left_top.y, chunk.area.right_bottom.y - 1 do
                table.insert(all_tiles, {name = "out-of-map", position = {x, y}})
            end
        end
    end
    new_surface.set_tiles(all_tiles)

    -- Function to generate the tile pattern for a 64x64 room
    local function generate_room_decor(x_origin, y_origin, room_type)
        local tiles = {}
        local entities = {} -- To keep track of where entities should be placed

        -- Define different patterns and entities based on the room type
        if room_type == "spawn" then
            -- Spawn room pattern and entities
            for tile_x = 0, tile_size - 1 do
                for tile_y = 0, tile_size - 1 do
                    table.insert(tiles, {name = "lab-white", position = {x_origin + tile_x, y_origin + tile_y}})
                end
            end
            -- Example: Place a special entity in the center of the spawn room
            table.insert(entities, {name = "small-lamp", position = {x_origin + tile_size / 2, y_origin + tile_size / 2}})

        elseif room_type == "artifact" then
            -- Artifact room pattern and entities
            for tile_x = 0, tile_size - 1 do
                for tile_y = 0, tile_size - 1 do
                    table.insert(tiles, {name = "yellow-refined-concrete", position = {x_origin + tile_x, y_origin + tile_y}})
                end
            end
            -- Example: Place an artifact entity in the center of the artifact room
            table.insert(entities, {name = "small-lamp", position = {x_origin + tile_size / 2, y_origin + tile_size / 2}})
        else  -- Normal room
            -- Define a base tile for the room
            local base_tile = "stone-path"

            -- Fill the room with base tiles
            for tile_x = 0, tile_size - 1 do
                for tile_y = 0, tile_size - 1 do
                    table.insert(tiles, {name = base_tile, position = {x_origin + tile_x, y_origin + tile_y}})
                end
            end

            -- Create a pattern within the room
            for tile_x = 8, tile_size - 9 do
                for tile_y = 8, tile_size - 9 do
                    local tile_type
                    if (tile_x / 8) % 2 == (tile_y / 8) % 2 then
                        tile_type = "concrete"
                    else
                        tile_type = "hazard-concrete-left"
                    end
                    table.insert(tiles, {name = tile_type, position = {x_origin + tile_x, y_origin + tile_y}})
                end
            end

            -- Place walls around the perimeter, except in the middle
            for i = 0, tile_size - 1 do
                if not (i >= tile_size / 2 - 2 and i <= tile_size / 2 + 1) then
                    table.insert(entities, {name = "stone-wall", position = {x_origin + i, y_origin}})
                    table.insert(entities, {name = "stone-wall", position = {x_origin + i, y_origin + tile_size - 1}})
                    table.insert(entities, {name = "stone-wall", position = {x_origin, y_origin + i}})
                    table.insert(entities, {name = "stone-wall", position = {x_origin + tile_size - 1, y_origin + i}})
                end
            end

            -- Place lights in the corners of the room
            table.insert(entities, {name = "small-lamp", position = {x_origin + 1, y_origin + 1}})
            table.insert(entities, {name = "small-lamp", position = {x_origin + tile_size - 2, y_origin + 1}})
            table.insert(entities, {name = "small-lamp", position = {x_origin + 1, y_origin + tile_size - 2}})
            table.insert(entities, {name = "small-lamp", position = {x_origin + tile_size - 2, y_origin + tile_size - 2}})

            -- Add additional decoration elements as desired

            -- Define the middle area of the room to potentially spawn a biter
            local middle_start = tile_size / 4
            local middle_end = tile_size - middle_start

            -- Randomly decide to spawn a biter with a 2% chance
            if math.random(1, 100) <= 2 then
                -- Random position for the biter within the middle of the room
                local biter_x = math.random(middle_start, middle_end)
                local biter_y = math.random(middle_start, middle_end)

                -- Add the biter to the entities table
                table.insert(entities, {
                    name = "small-biter", -- Use the correct name for a biter entity in your game
                    position = {x_origin + biter_x, y_origin + biter_y},
                    force = "enemy" -- Biters are typically part of the enemy force
                })
            end
            if math.random(1, 100) <= 2 then
                -- Random position for the biter within the middle of the room
                local biter_x = math.random(middle_start, middle_end)
                local biter_y = math.random(middle_start, middle_end)

                -- Add the biter to the entities table
                table.insert(entities, {
                    name = "small-spitter", -- Use the correct name for a biter entity in your game
                    position = {x_origin + biter_x, y_origin + biter_y},
                    force = "enemy" -- Biters are typically part of the enemy force
                })
            end
            if math.random(1, 100) <= 99 then
                -- Random position for the biter within the middle of the room
                local biter_x = math.random(middle_start, middle_end)
                local biter_y = math.random(middle_start, middle_end)

                -- Add the biter to the entities table
                table.insert(entities, {
                    name = "compilatron", -- Use the correct name for a biter entity in your game
                    position = {x_origin + biter_x, y_origin + biter_y},
                    force = "enemy" -- Biters are typically part of the enemy force
                })
            end

        end

        -- Return the tiles and entity positions
        return tiles, entities
    end



    game.print("Setting room tiles")
    -- Now set room tiles based on the matrix

    global.tiles_to_set = {}
    global.entities_to_create = {}

    for x = 1, #matrix do
        for y = 1, #matrix[x] do
            local room_type
            if matrix[x][y] == 1 then
                room_type = "default"
            elseif matrix[x][y] == 2 then
                room_type = "spawn"
            elseif matrix[x][y] == 3 then
                room_type = "artifact"
            end

            if room_type then
                -- Calculate the top-left corner of the room in world coordinates
                local x_origin = (x - 1) * tile_size
                local y_origin = (y - 1) * tile_size

                 -- Generate the tiles and entity positions for the room
                local room_tiles, entities = generate_room_decor(x_origin, y_origin, room_type)
                table.insert(global.tiles_to_set, room_tiles)
                for _, entity in pairs(entities) do
                    table.insert(global.entities_to_create, {name = entity.name, position = entity.position, force = entity.force})
                end

                -- Here you should also schedule entity placement to be processed in on_tick or another event
                -- ... (entity placement logic)
            end
        end
    end

    -- Register the on_tick event handler to process the tile setting
    script.on_event(defines.events.on_tick, function(event)
        -- Place a batch of tiles if there are any to set
        if #global.tiles_to_set > 0 then
            local tile_batch = table.remove(global.tiles_to_set, 1)
            new_surface.set_tiles(tile_batch)
        end

        -- Create a batch of entities if there are any to create
        if #global.entities_to_create > 0 then
            for i = 1, math.min(#global.entities_to_create, 10) do -- Place up to 10 entities per tick
                local entity_info = table.remove(global.entities_to_create, 1)
                new_surface.create_entity({name = entity_info.name, position = entity_info.position, force = entity_info.force})
            end
        end

        -- If there are no more tiles or entities to place, remove this event handler
        if #global.tiles_to_set == 0 and #global.entities_to_create == 0 then
            script.on_event(defines.events.on_tick, nil)
        end
    end)


    return new_surface
end

-- Command to generate the new surface and teleport the player
commands.add_command("generate_surface", "Generates a new surface based on the matrix", function(command)
    local player = game.get_player(command.player_index)  -- Get the player who ran the command

    game.print("Creating matrix")
    local matrix = createMatrix(12, 12)  -- Assume createMatrix is already defined and generates your matrix

    game.print("Setting tile size")
    local tile_size = 64  -- Define your tile size

    game.print("Turning matrix into new surface")
    local new_surface = create_and_load_surface(matrix, tile_size)

    -- Inside the command function after the new_surface has been created
    local spawn_position = nil
    for x, row in ipairs(matrix) do
        for y, value in ipairs(row) do
            if value == 2 then
                -- Calculate the center position of the room, not the tile
                spawn_position = {x = (x - 1) * tile_size + (tile_size/2), y = (y - 1) * tile_size + (tile_size/2)}
                goto found_spawn  -- Use a goto statement to break out of both loops
            end
        end
    end
    ::found_spawn::

    if spawn_position then
        game.print("Teleporting player to spawn room")
        -- Teleport the player to the spawn position
        player.teleport(spawn_position, new_surface)
    else
        game.print("Spawn room not found, teleporting to origin")
        -- If no spawn room was found, teleport to the origin as a fallback
        player.teleport({x = 0, y = 0}, new_surface)
    end

end)
