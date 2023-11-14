function generate_dungeon_floor(map_matrix, map_size)
    local tiles = {} -- To keep track of where tiles should be placed
    local entities = {} -- To keep track of where entities should be placed

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

    local dungeon_surface = game.create_surface("dungeon_floor_" .. math.random(9999), map_gen_settings)

    game.print("Force Loading")
    -- Calculate the chunk area to generate based on the matrix size
    local chunk_area_to_generate = {
        left_top = {x = -1, y = -1},
        right_bottom = {x = map_size + 1, y = map_size + 1}
    }

    local chunks_generated = 0

    -- Request chunk generation for the entire area
    for chunk_x = chunk_area_to_generate.left_top.x, chunk_area_to_generate.right_bottom.x do
        for chunk_y = chunk_area_to_generate.left_top.y, chunk_area_to_generate.right_bottom.y do
            dungeon_surface.request_to_generate_chunks({x = chunk_x * map_size, y = chunk_y * map_size}, 0)
        end
    end

    game.print("Waiting for chunks to generate...")
    script.on_event(defines.events.on_chunk_generated, function(event)
        chunks_generated = chunks_generated + 1
        if chunks_generated == (map_size + 1) * (map_size + 1) then
            game.print("Setting out-of-map Tiles")

            -- Set the entire area to 'out-of-map'
            local all_tiles = {}
            for y, row in ipairs(map_matrix) do
                for x, cell in ipairs(row) do
                    table.insert(all_tiles, {name = "out-of-map", position = {x - 1, y - 1}})
                end
            end

            dungeon_surface.set_tiles(all_tiles)

            -- Remove the on_chunk_generated event to stop checking for chunk generation
            script.on_event(defines.events.on_chunk_generated, nil)
        end
    end)

    return dungeon_surface
end



-- Function to generate the tile pattern for a 64x64 room
local function generate_room_decor(x_origin, y_origin, room_type)
    local tiles = {}
    local entities = {} -- To keep track of where entities should be placed

    game.print("Setting tile size")
    local tile_size = 64

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
        table.insert(entities, {name = "artifactSpawnTile", position = {x_origin + tile_size / 2, y_origin + tile_size / 2}})
    else  -- Normal room
        -- Define a base tile for the room
        local base_tile = "dirtStoneTile"

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
                    tile_type = "cobbleStoneTile"
                else
                    tile_type = "cobbleStoneTile"
                end
                table.insert(tiles, {name = tile_type, position = {x_origin + tile_x, y_origin + tile_y}})
            end
        end

        -- Place walls around the perimeter, except in the middle
        for i = 0, tile_size - 1 do
            if not (i >= tile_size / 2 - 2 and i <= tile_size / 2 + 1) then
                table.insert(entities, {name = "cobbleStoneWall", position = {x_origin + i, y_origin}})
                table.insert(entities, {name = "cobbleStoneWall", position = {x_origin + i, y_origin + tile_size - 1}})
                table.insert(entities, {name = "cobbleStoneWall", position = {x_origin, y_origin + i}})
                table.insert(entities, {name = "cobbleStoneWall", position = {x_origin + tile_size - 1, y_origin + i}})
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

-- Function to create and load the new surface
function turnMatrixIntoMap(matrix, tile_size)

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

