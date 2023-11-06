io.write("Starting Code \n")

local function createMatrix(maxWidth, maxHeight)
    local floorPlanMatrix = {}
    local roomCount = 0
    local lastRoomCreatedX
    local lastRoomCreatedY

    io.write("MaxWidth: " .. maxWidth .. ", maxHeight: " .. maxHeight .. "\n")


    -- Initialize the matrix with all zeros
    for x = 1, maxWidth do
        floorPlanMatrix[x] = {}
        for y = 1, maxHeight do
            floorPlanMatrix[x][y] = 0
        end
    end

    io.write("Matrix Created \n")

    -- Start with a random cell
    local startX, startY = math.random(maxWidth), math.random(maxHeight)
    floorPlanMatrix[startX][startY] = 1
    roomCount = roomCount + 1
    local maxRoomCount = math.random(math.floor(maxWidth * 2), math.floor(maxWidth * (maxHeight/2)))
    io.write("Maximum amount of rooms: " .. maxRoomCount .. "\n")

    io.write("Starting Room Chosen \n")

    local function spreadFrom(x, y, prevDirection)
        io.write("Room count: " .. roomCount .. "\n")

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
                    io.write("Room count: " .. roomCount .. "\n")
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

        io.write("Extra path starting rooms amount: " .. startRoomCount .. "\n")

        for _, startRoom in ipairs(chosenStartRooms) do
            io.write("Room coords: " .. startRoom[1] .. "," .. startRoom[2] .. "\n")
            digPathFrom(startRoom[1], startRoom[2])
        end
    end


    io.write("Starting room generation! \n")
    -- Spread from the starting cell
    spreadFrom(startX, startY)

    io.write("Creating extra paths \n")
    createExtraPaths()

    io.write("Matrix Created \n")


    local function assignRoomTypes()

        io.write("Creating spawn/exit(2) and artifact spawnplace(3) \n")
        floorPlanMatrix[startX][startY] = 2
        floorPlanMatrix[lastRoomCreatedX][lastRoomCreatedY] = 3


    end

    assignRoomTypes()

    return floorPlanMatrix
end

io.write("Creating Matrix \n")

local matrix = createMatrix(20, 20) -- Assuming createMatrix is already defined

io.write("Printing matrix:\n")
for i = 1, #matrix do
    for j = 1, #matrix[i] do
        io.write(matrix[i][j] .. " ")
    end
    io.write("\n") -- Newline for each row
end

io.write("Code Finished ------------------------------------------------------------------------------------------- \n")