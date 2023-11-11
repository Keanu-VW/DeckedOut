-- Map size = 768 --

function generate_map_matrix(map_size)

    local map_size = map_size
    print("Map size: "..map_size)
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
    9: doors (Removed before returning matrix)
    ]]--

    local map_matrix = {}

    -- Create matrix --
    for x = 1, map_size do
        map_matrix[x] = {}
        for y = 1, map_size do
            map_matrix[x][y] = 0
        end
    end

    -- Create starting room --
    local startX, startY = math.random(starting_room_size + 1, map_size - starting_room_size - 1), math.random(starting_room_size + 1, map_size - starting_room_size - 1)
        --walls
    local starting_room_door = false
    for x = -1, starting_room_size + 1 do
        for y = -1, starting_room_size + 1 do
            if x == -1 or x == starting_room_size + 1 or y == -1 or y == starting_room_size + 1 then
                map_matrix[startX + x][startY + y] = 1
                if starting_room_door == false then
                    if math.random(1, 5) == 1 then
                        map_matrix[startX + x][startY + y] = 9
                        starting_room_door = true
                    end
                end
            end
        end
    end
        --Starting Room
    for x = 0, starting_room_size - 1 do
        for y = 0, starting_room_size - 1 do
            map_matrix[startX + x][startY + y] = 4
        end
    end


    -- Create random amount of rooms --
    local already_placed_rooms = 0 -- Set the amount of already placed rooms to 1
    local attempts = 0

    print("Amount of rooms: "..amount_of_rooms)
    print("Max room size: "..max_room_size)
    print("Creating rooms")


    while already_placed_rooms <= amount_of_rooms - 1 and attempts < 10000 do -- While there are less placed rooms then the chosen amount, keep creating one
        local room_for_room = true -- Asume there is room but then check
        local room_width = math.random(math.floor(max_room_size / 2), max_room_size)
        local room_height = math.random(math.floor(max_room_size / 2), max_room_size)
        local startX = math.random(room_width + 2, map_size - room_width - 2) -- Choose a ranndom starting position
        local startY = math.random(room_height + 2, map_size - room_height - 2)
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
                        map_matrix[startX + x][startY + y] = 1
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
            print("Creating room #"..already_placed_rooms.." (Size: "..room_width..","..room_height..")")
        end
        attempts = attempts + 1
    end
    print("Attempts: "..attempts)

    -- Drunkard's walk --
    --[[
        Every room gets a random amount of doors
        Count the number of doors
        start with a door in the starting room
        walk randomly until you get to a door
        remove door from list and turn door into room (2)
        keep repeating until all doors are gone
    ]]--
    local amount_of_doors = 0
    for x = 1, map_size do
        for y = 1, map_size do
            if map_matrix[x][y] == 9 then
                amount_of_doors = amount_of_doors + 1
            end
        end
    end
    print("Amount of doors: " .. amount_of_doors)


    return map_matrix
end

local map_size = 80
local map_matrix = generate_map_matrix(map_size)
if map_matrix ~= nil then
    print("Generated map_matrix:")
    for x = 1, map_size do
        local row_str = ""
        for y = 1, map_size do
            row_str = row_str .. map_matrix[x][y] .. " "
        end
        print(row_str)
    end
end



function createMatrix(maxWidth, maxHeight)
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
        for x = #directions, 2, -1 do
            local y = math.random(x)
            directions[x], directions[y] = directions[y], directions[x]
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

            for x = 1, pathLength do
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