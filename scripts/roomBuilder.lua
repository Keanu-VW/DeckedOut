function roomBuilder(player)

    -- Check if the surface already exists
    local room_editor_surface = game.surfaces["roomEditor"]

    local tile_size = 64

    if not room_editor_surface then
        -- Surface settings
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
            cliff_settings = { cliff_elevation_0 = 1024 },
            starting_area = "none",
            peaceful_mode = true
        }

        -- Create the surface
        room_editor_surface = game.create_surface("roomEditor"..math.random(1, 99999), map_gen_settings)

        game.print("Force Loading")
        -- Calculate the chunk area to generate based on the matrix size
        local chunk_area_to_generate = {
            left_top = {x = -1, y = -1},
            right_bottom = {x = tile_size, y = tile_size}
        }

        -- Request chunk generation for the entire area
        for chunk_x = chunk_area_to_generate.left_top.x, chunk_area_to_generate.right_bottom.x do
            for chunk_y = chunk_area_to_generate.left_top.y, chunk_area_to_generate.right_bottom.y do
                room_editor_surface.request_to_generate_chunks({x = chunk_x , y = chunk_y }, 0)
            end
        end
        room_editor_surface.force_generate_chunk_requests()  -- Force the generation of requested chunks

        game.print("Setting out-of-map Tiles")
        -- Set the entire area to 'out-of-map' first
        local all_tiles = {}
        for chunk in room_editor_surface.get_chunks() do
            for x = chunk.area.left_top.x, chunk.area.right_bottom.x - 1 do
                for y = chunk.area.left_top.y, chunk.area.right_bottom.y - 1 do
                    table.insert(all_tiles, {name = "out-of-map", position = {x, y}})
                end
            end
        end

        room_editor_surface.set_tiles(all_tiles)


        -- Set the middle 64x64 area to concrete tiles
        local concrete_tiles = {}
        for x = 0, 63 do
            for y = 0, 63 do
                table.insert(concrete_tiles, {name = "dirtStoneTile", position = {x, y}})
            end
        end
        room_editor_surface.set_tiles(concrete_tiles)

        local entities = {}

        -- Place walls around the perimeter, except in the middle
        for i = 0, tile_size - 1 do
            if i < tile_size / 2 - 2 or i > tile_size / 2 + 1 then
                table.insert(entities, {name = "stone-wall", position = {0 + i, 0}})
                table.insert(entities, {name = "stone-wall", position = {0 + i, tile_size - 1}})
                table.insert(entities, {name = "stone-wall", position = {0, 0 + i}})
                table.insert(entities, {name = "stone-wall", position = {tile_size - 1, 0 + i}})
            end
        end

        -- Place up to 10 entities per tick
        for _, entity in ipairs(entities) do
            room_editor_surface.create_entity({name = entity.name, position = entity.position, force = entity.force})
        end
    end

    player.teleport({x = 32, y = 1}, room_editor_surface)
end

commands.add_command("saveFloor", "Save floor data", function(event)
    local tile_size = 64
    local saved_floor = {}
    local player = game.players[event.player_index]

    -- Check if the player is standing on the roomEditor_surface
        local area = {{0, 0}, {tile_size - 1, tile_size - 1}}

        -- Capture tiles
        local tile_matrix = {}
        for x = area[1][1], area[2][1] do
            for y = area[1][2], area[2][2] do
                local tile = player.surface.get_tile(x, y)
                table.insert(tile_matrix, tile.name)
            end
        end

        -- Capture entities
        local entities = player.surface.find_entities_filtered{area = area}
        local entity_positions = {}
        for _, entity in pairs(entities) do
            entity_positions[#entity_positions + 1] = {name = entity.name, position = entity.position}
        end

        -- Get the floor name from the command parameter
        local floor_name = event.parameter

        -- Store the data with a unique name
        saved_floor[floor_name] = {tiles = tile_matrix, entities = entity_positions}
        player.print("Floor '" .. floor_name .. "' saved.")

        local serialized_data = game.table_to_json(saved_floor)

        -- Print the path where the file should be saved
        local file_path = "C:/Users/keanu/AppData/Roaming/Factorio/script-output/roomBuilder/rooms.json"
        player.print("Saving to file: " .. file_path)

        -- Write the JSON data to a file within the mod folder
        game.write_file(file_path, serialized_data, true)
end)
