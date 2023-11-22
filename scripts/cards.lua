local cards = {}


table.insert(cards, {name = "Crumble", func = card_crumble})
table.insert(cards, {name = "Debris", func = nil})
table.insert(cards, {name = "clank", func = nil})

-- Crumble: Map slowly crumbles away over time
function card_crumble()
    --Generate random matrix, take away this matrix from not needed tiles
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

function card_debris()
    local randomX, randomY = math.random(1, map_size - 1), math.random(1, map_size)
    player.surface.create_entity{
        name = "falling-rock",
        position = {randomX, randomY},
        force = game.forces["enemy"]
    }
    player.surface.create_entity{
        name = "falling-rock",
        position = {randomX, randomY},
        force = game.forces["enemy"]
    }
    player.surface.create_entity{
        name = "falling-rock",
        position = {randomX, randomY},
        force = game.forces["enemy"]
    }
end