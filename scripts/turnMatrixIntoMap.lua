function generate_dungeon_floor(map_matrix, map_size)
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

    local chunk_area_to_generate = {
        left_top = {x = -1, y = -1},
        right_bottom = {x = math.ceil(map_size/32), y = math.ceil(map_size/32)}
    }

    -- Request chunk generation for the entire area
    for chunk_x = chunk_area_to_generate.left_top.x, chunk_area_to_generate.right_bottom.x do
        for chunk_y = chunk_area_to_generate.left_top.y, chunk_area_to_generate.right_bottom.y do
            dungeon_surface.request_to_generate_chunks({x = chunk_x * 32, y = chunk_y * 32}, 0)
        end
    end
    dungeon_surface.force_generate_chunk_requests()  -- Force the generation of requested chunks

    local all_tiles = {}
    for x = -200, map_size + 200 do
        for y = -200, map_size + 200 do
            table.insert(all_tiles, {name = "out-of-map", position = {x, y}})
        end
    end

    dungeon_surface.set_tiles(all_tiles)

    all_tiles = {}
    for x = 1, map_size do
        for y = 1, map_size do
            if map_matrix[x][y] == 1 then
                table.insert(all_tiles, {name = "dirtStoneTile", position = {x, y}})
            end
        end
    end

    dungeon_surface.set_tiles(all_tiles)

    return dungeon_surface
end