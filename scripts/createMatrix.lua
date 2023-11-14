function generate_map_matrix(map_size)
    print("Generating Map")

    local map_size = map_size
    local starting_room_size = 10
    local amount_of_rooms = math.random(math.floor(math.floor(map_size / starting_room_size * 2 + 3)/2), math.floor(map_size / starting_room_size * 2 + 3))
    local max_room_size = math.floor(amount_of_rooms)

    if map_size <= starting_room_size * 2 + 3 then
        print("Map size is too small. Needs to be atleast: ".. starting_room_size * 2 + 3)
        return
    end

    --[[
    Matrix numbers and what they mean:
    0: empty space
    1: walls
    2: rooms
    3: corridors
    4: Spawn room and exit
    5: room walls
    9: doors (Removed before returning matrix)
    ]]--

    local map_matrix = {}

    print("Creating Matrix")
    -- Create matrix --
    for x = 1, map_size do
        map_matrix[x] = {}
        for y = 1, map_size do
            map_matrix[x][y] = 0
        end
    end


    print("Creating starting room")
    -- Create starting room --
    local startX, startY = math.random(starting_room_size + 1, map_size - starting_room_size - 1), math.random(starting_room_size + 1, map_size - starting_room_size - 1)
        --walls
    local starting_room_door = false
    for x = -1, starting_room_size + 1  do
        for y = -1, starting_room_size + 1 do
            if x == -1 or x == starting_room_size + 1 or y == -1 or y == starting_room_size + 1 then
                map_matrix[startX + x][startY + y] = 5
                if starting_room_door == false then
                    if x == 4 or x == starting_room_size - 3 or y == 4 or y == starting_room_size - 3 then
                        map_matrix[startX + x][startY + y] = 9
                    starting_room_door = true
                    end
                end
            end
        end
    end
        --Starting Room
    for x = 0, starting_room_size do
        for y = 0, starting_room_size do
            map_matrix[startX + x][startY + y] = 4
        end
    end


    print("Creating random rooms")
    -- Create random amount of rooms --
    local already_placed_rooms = 0 -- Set the amount of already placed rooms to 1
    local attempts = 0

    while already_placed_rooms <= amount_of_rooms - 1 and attempts < 10000 do -- While there are less placed rooms then the chosen amount, keep creating one

        local room_for_room = true -- Asume there is room but then check
        local room_width = math.random(math.floor(max_room_size / 2), max_room_size)
        local room_height = math.random(math.floor(max_room_size / 2), max_room_size)

        local startX = math.random(room_width + 3, map_size - room_width - 3) -- Choose a ranndom starting position
        local startY = math.random(room_height + 3, map_size - room_height - 3)
        for x = -2, room_width + 2 do
            for y = -2, room_height + 2 do
                if map_matrix[startX + x][startY + y] ~= 0 then
                    room_for_room = false -- Error, there is no room
                end
            end
        end
        if room_for_room == true then -- Only if there is room
            -- Create walls for the outer square
            for x = -1, room_width + 1 do
                for y = -1, room_height + 1 do
                    if x == -1 or x == room_width + 1 or y == -1 or y == room_height + 1 then
                        map_matrix[startX + x][startY + y] = 5
                    end
                end
            end

            -- Randomly choose between 1 and 4 sides for doors
            local sides_with_doors = math.random(1, 4)
            for _ = 1, sides_with_doors do
                local side = math.random(1, 4)
                if side == 1 then
                    -- Top side
                    local door_position = math.random(0, room_width)
                    map_matrix[startX + door_position][startY - 1] = 9  -- Create door
                elseif side == 2 then
                    -- Right side
                    local door_position = math.random(0, room_height)
                    map_matrix[startX + room_width + 1][startY + door_position] = 9  -- Create door
                elseif side == 3 then
                    -- Bottom side
                    local door_position = math.random(0, room_width)
                    map_matrix[startX + door_position][startY + room_height + 1] = 9  -- Create door
                elseif side == 4 then
                    -- Left side
                    local door_position = math.random(0, room_height)
                    map_matrix[startX - 1][startY + door_position] = 9  -- Create door
                end
            end
            -- Create Floor
            for x = 0, room_width do
                for y = 0, room_height do
                    map_matrix[startX + x][startY + y] = 2
                end
            end
            already_placed_rooms = already_placed_rooms + 1 -- Increase placed rooms by 1
        end
        attempts = attempts + 1
    end

    local amount_of_doors = 0
    for x = 1, map_size do
        for y = 1, map_size do
            if map_matrix[x][y] == 9 then
                amount_of_doors = amount_of_doors + 1
            end
        end
    end

    --[[
        Drunkard's walk
            Take a random emptyplace on the map
            turn tile into a 3
            scan surrounding tiles
            if tile is a 0, turn it into a wall
            if tile is a 9, do amount of doors - 1 and turn that door into a 2
            choose a random direction to go in
            if that direction has a 0 or 1, move towards it, otherwise choose a new direction
            keep repeating until amount of doors = 0
    ]]--

    print("Choosing starting place for drunkard's walk")
    -- Choosing random empty tile to begin drunkard's walk --
    local drunkX, drunkY = nil, nil
    while drunkX == nil and drunkY == nil do
        local randomX, randomY = math.random(starting_room_size, map_size - starting_room_size), math.random(starting_room_size, map_size - starting_room_size)
        if map_matrix[randomX][randomY] == 0 then
            drunkX, drunkY = randomX, randomY
        end
    end

    print("walking the drunkard")
    -- Repeat until there is a path to every door --
    while amount_of_doors ~= 0 do

        map_matrix[drunkX][drunkY] = 3 -- Turn tile into a 3

        -- Define directions
        local directions = { {0, -1}, {0, 1}, {-1, 0}, {1, 0} }

        -- Iterate over directions
        for _, direction in ipairs(directions) do
            local dx, dy = direction[1], direction[2]
            local adjacentTile = map_matrix[drunkX + dx][drunkY + dy]

            -- Turn surrounding tiles into walls
            if adjacentTile == 0 then
                map_matrix[drunkX + dx][drunkY + dy] = 1
            end

            -- Check for doors
            if adjacentTile == 9 then
                map_matrix[drunkX + dx][drunkY + dy] = 2
                amount_of_doors = amount_of_doors - 1
                print("Amount of doors left: "..amount_of_doors)
            end
        end

        -- Go in a random direction if the way is clear
        -- Implementing favoritism for the same direction until hitting a wall
        local favorDirection = math.random(1, 4)

        -- Check if the chosen direction is valid (not hitting a wall and within map bounds)
        local function isValidDirection(dx, dy)
            local newX, newY = drunkX + dx, drunkY + dy
            return newX >= 1 and newX <= map_size and newY >= 1 and newY <= map_size and map_matrix[newX][newY] ~= 1
        end

        -- Iterate over directions starting from the favorDirection
        for i = 1, 4 do
            local directionIndex = (favorDirection + i - 1) % 4 + 1  -- Cycle through directions

            local dx, dy = directions[directionIndex][1], directions[directionIndex][2]

            if isValidDirection(dx, dy) then
                -- Update drunkard's position
                drunkX = drunkX + dx
                drunkY = drunkY + dy

                -- Update favorDirection for the next iteration
                favorDirection = (favorDirection + math.random(1, 3)) % 4 + 1
                break
            end
        end

    end

    print("Finished")

    return map_matrix
end

local map_size = 80
local map_matrix = generate_map_matrix(map_size)
for x = 1, map_size do
    io.write("\n")
    for y = 1, map_size do
        io.write(map_matrix[x][y])
    end
end