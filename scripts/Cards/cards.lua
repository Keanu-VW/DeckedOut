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

Card = {
    new = function(name, func, maxAmount, description)
    local self = {}
    self.name = name
    self.func = func
    self.maxAmount = maxAmount
    self.description = description
    global.Cards[name] = self
    return self
end
}

-- Treasure: Drops a random amount of shards or gold plates scattered across the map
local function card_treasure()
    local success = false
    while success == false do
        local TreasureX, TreasureY = math.random(1, global.GameState.map_size), math.random(1, global.GameState.map_size)
        if global.GameState.room_map_matrix[TreasureX][TreasureY] == 1 then
            -- Choose a random item type (either "alienShard" or "goldPlate")
            local itemType = math.random() < 0.5 and "alienShard" or "goldPlate"
            -- Generate a random amount for the item count
            local itemCount = math.random(1, 10)
            -- Spill the items at the treasure position
            global.GameState.map_surface.spill_item_stack({TreasureX, TreasureY}, {name = itemType, count = itemCount})
            success = true
            game.print("Treasure")
        end
    end
end

-- Crumble: Map slowly crumbles away over time
local function card_crumble()
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
        local crumbleX, crumbleY = math.random(crumble_size, global.GameState.map_size - crumble_size), math.random(crumble_size, global.GameState.map_size - crumble_size)
        for x = 1, crumble_size do
            for y = 1, crumble_size do
                if global.GameState.room_map_matrix[crumbleX + x - 1][crumbleY + y - 1] == 0 then
                    if crumble_matrix[x][y] == 1 then
                        global.GameState.map_surface.set_tiles({{name = "out-of-map", position = {x = crumbleX + x - 1, y = crumbleY + y - 1}}})
                        success = true
                    end
                end
            end
        end
    end

    game.print("Crumble")
end

-- Debris: Falling rocks from the ceiling create small explosions and debris everywhere
local function card_debris()
    local success = false
    while success == false do
        local randomX, randomY = math.random(1, global.GameState.map_size - 1), math.random(1, global.GameState.map_size)
        -- Check if the selected position is a walkable tile
        if global.GameState.room_map_matrix[randomX][randomY] == 1 then
            -- Create falling rock
            rendering.draw_animation{
                animation = "falling-rock",
                target = {randomX, randomY},
                surface = global.GameState.map_surface,
                time_to_live = 90
            }
            global.GameState.map_surface.create_entity({
                name = "rock-big",
                position = {randomX,randomY}
            })
            game.print("debris")
            success = true
        end
    end
end

-- Clank: Spawn in enemies
local function card_clank()
    local success = false
    while success == false do
        local spitterX, spitterY = math.random(1, global.GameState.map_size), math.random(1, global.GameState.map_size)
        local spitters = {"small-spitter", "medium-spitter", "big-spitter", "behemoth-spitter"}
        if global.GameState.room_map_matrix[spitterX][spitterY] == 1 then
            for i = 1, math.random(1,#spitters) do
                global.GameState.map_surface.create_entity({name = spitters[i], position = {x = spitterX, y = spitterY}})
                end
            success = true
            game.print("Clank")
        end
    end
end

-- Sneak: Block 2 clank
local function card_sneak()
    global.GameState.clank_block = global.GameState.clank_block + 2
    game.print("Sneak")
end

-- Stability: Block 2 Crumble
local function card_stability()
    global.GameState.clank_block = global.GameState.clank_block + 2
    game.print("Stability")
end

-- Debris Removal: Block 2 debris
local function card_debris_removal()
    global.GameState.debris_block = global.GameState.debris_block + 2
    game.print("Debris Removal")
end

-- Summon Ally: Spawn a group of friendly spitters at the player's location
local function card_summon_ally()
    -- Get the player's current position
    local player_position = game.players[1].position

    -- Generate a random number for the number of allies to spawn
    local num_allies = math.random(3, 5)
    local spitters = {"small-spitter", "medium-spitter", "big-spitter", "behemoth-spitter"}
    
    -- For each ally to spawn, create a friendly spitter at a position near the player
    for i = 1, num_allies do
        -- Generate a random offset for the spitter's position
        local offset = {x = math.random(-3, 3), y = math.random(-3, 3)}

        -- Create the spitter at the player's position plus the offset
        global.GameState.map_surface.create_entity({
            name = spitters[math.random(1,#spitters)],
            position = {x = player_position.x + offset.x, y = player_position.y + offset.y},
            force = game.forces["player"]
        })
    end
    game.print("Summon Ally")
end

global.Cards = {}
Card.new("Treasure", card_treasure, 5, "Drops a random amount of shards or gold plates scattered across the map")
Card.new("Sneak", card_sneak, 5, "Block 2 clank")
Card.new("Stability", card_stability, 5, "Block 2 crumble")
Card.new("Debris Removal", card_debris_removal, 5, "Block 2 debris")
Card.new("Crumble", card_crumble, 5, "Map slowly crumbles away over time")
Card.new("Clank", card_clank, 3, "Spitters appear randomly on the map")
Card.new("Debris", card_debris, 7, "Falling rocks and explosions")
Card.new("Summon Ally", card_summon_ally, 3, "Spawn a group of friendly spitters at your location")

return global.Cards
