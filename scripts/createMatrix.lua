function generate_map_matrix(map_size)
    print("Generating Map of size: "..map_size)

    --[[
        0) Create empty Matrix
        1) Space Partitioning
        2) Room generation
        3) Edge Selection
        4) Corridor Generation
        5) Cave generation
        6) Removing Isolated Cells
        7) Mutliple Corridors Between Rooms
    ]]--

    -- 0) Create empty matrix --
    local map_matrix = {}
    for x = 1, map_size do
        map_matrix[x] = {}
        for y = 1, map_size do
            map_matrix[x][y] = 0
        end
    end

    -- 1) Space Partitioning (Binary) --
        --[[
            Save the coörds of the different partitions in a binary tree.
            A node is a list: {underlying Nodes} TopX, TopY, BottomX, BottomY
            Top node is the full matrix, split it in 2
            Split underlying nodes in two

            node = {{subnode 1, subnode 2}, topX, topY, bottomX, bottomY}
        ]]--

    -- Create list first node
    local partitionList = {{0, 0, map_size, map_size}}

    -- Function that takes in a node and splits it, alternating between horizontal and vertical splits. Returns the node 2 subnodes
    local function splitNodeInTwo(node)
        local splitPercent = math.random(45, 55)
        local subNode1 = {}
        local subNode2 = {}
        local topX, topY, bottomX, bottomY = node[1], node[2], node[3], node[4]

        local width = bottomX - topX
        local height = bottomY - topY

        -- Alternating between horizontal and vertical splits
        if height >= width then
            -- Horizontal split
            local newTopLength = topY + math.ceil(height / 100 * splitPercent)
            subNode1 = {topX, topY, bottomX, newTopLength}
            subNode2 = {topX, newTopLength, bottomX, bottomY}
        else
            -- Vertical split
            local newTopHeight = topX + math.ceil(width / 100 * splitPercent)
            subNode1 = {topX, topY, newTopHeight, bottomY}
            subNode2 = {newTopHeight, topY, bottomX, bottomY}
        end

        return subNode1, subNode2
    end

    local repetition = math.random(4, math.ceil(map_size/100))
    -- Split each partition in the list in two, and repeat the process for 5 times
    for iteration = 1, repetition do
        local currentListSize = #partitionList
        local newList = {}

        for j = 1, currentListSize do
            local nodeToSplit = partitionList[j]
            local newNode1, newNode2 = splitNodeInTwo(nodeToSplit)

            -- Add the newly created subnodes to the new list
            table.insert(newList, newNode1)
            table.insert(newList, newNode2)
        end

        -- Replace the old list with the new list for the next iteration
        partitionList = newList
    end

    --[[
    For testing room partitions
        -- Function to fill a partition with a single random letter from the alphabet
        local function fillPartitionWithRandomLetter(node)
            local topX, topY, bottomX, bottomY = node[1], node[2], node[3], node[4]
            local randomLetter = string.char(math.random(65, 90)) -- ASCII values for uppercase letters
            for x = topX + 1, bottomX do
                for y = topY + 1, bottomY do
                    map_matrix[x][y] = randomLetter
                end
            end
        end

        -- Take the first node and fill each partition with a single random letter
        for i = 1, #partitionList do
            fillPartitionWithRandomLetter(partitionList[i])
        end
    ]]--

    --[[
    print("Partitionlist:")
    for i = 1, #partitionList do
        for j = 1, #partitionList[i] do
            io.write(partitionList[i][j])
            io.write(",")
        end
        io.write("\n")
    end
    ]]--

    -- 2) Room generation (we have a partitionList with the partitions and map_matrix filled with 0's --

    local roomList = {}

    for partition = 1, #partitionList do
        local topX, topY, bottomX, bottomY = partitionList[partition][1], partitionList[partition][2], partitionList[partition][3], partitionList[partition][4]
        local newRoomWidth = math.random(math.ceil((bottomX - topX)/2), math.ceil((bottomX - topX)/1.2))
        local newRoomHeight = math.random(math.ceil((bottomY - topY)/2), math.ceil((bottomY - topY)/1.2))
        local newRoom = {
            topX + (bottomX - topX - math.ceil((bottomX - topX)/1.2)),
            topY + (bottomY - topY - math.ceil((bottomY - topY)/1.2)),
            topX+ newRoomWidth,
            topY + newRoomHeight
        }
        table.insert(roomList, newRoom)
    end

    --[[
    print("Roomlist:")
    for i = 1, #roomList do
        for j = 1, #roomList[i] do
            io.write(roomList[i][j])
            io.write(",")
        end
        io.write("\n")
    end
    ]]--

    -- 3) Put roomList into matrix --
    for room = 1, #roomList do
        local topX, topY, bottomX, bottomY = roomList[room][1], roomList[room][2], roomList[room][3], roomList[room][4]
        for x = 1, bottomX - topX do
            for y = 1, bottomY - topY do
                map_matrix[x + topX][y + topY] = 1
            end
        end
    end

    -- 4) Corridor generation --
    --[[
        Loop over every room
            Start in the middle of the room
            shoot every side until either out of bounds or hitting another room
            if successfully hitting a room
                change all tiles to a 1
    ]]--

    local corridorList = {}

    for room = 1, #roomList do
        local tempCor = {}
        local topX, topY, bottomX, bottomY = roomList[room][1], roomList[room][2], roomList[room][3], roomList[room][4]
        local middleX = topX + math.ceil((bottomX - topX) / 2)
        local middleY = topY + math.ceil((bottomY - topY) / 2)
        local currentX, currentY = middleX, middleY
        local chanceOfNewPathway = 100

        -- Move left
        if chanceOfNewPathway >= math.random(1, 100) then
            currentY = topY
            while currentX > 1 and currentX < map_size and currentY > 1 and currentY < map_size do
                table.insert(tempCor, {currentX, currentY})
                table.insert(tempCor, {currentX + 1, currentY})
                table.insert(tempCor, {currentX - 1, currentY})
                if map_matrix[currentX][currentY] == 1 then
                    table.insert(corridorList, tempCor)
                    chanceOfNewPathway = chanceOfNewPathway - math.random(1, 100)
                    break
                end
                currentY = currentY - 1
            end
            currentX, currentY = middleX, middleY -- Reset to middle of the room
            tempCor = {}
        end

        -- Move down
        if chanceOfNewPathway >= math.random(1, 100) then
            currentX = bottomX + 1
            while currentX > 1 and currentX < map_size and currentY > 1 and currentY < map_size do
                table.insert(tempCor, {currentX, currentY})
                table.insert(tempCor, {currentX, currentY + 1})
                table.insert(tempCor, {currentX, currentY - 1})
                if map_matrix[currentX][currentY] == 1 then
                    table.insert(corridorList, tempCor)
                    chanceOfNewPathway = chanceOfNewPathway - math.random(1, 100)
                    break
                end
                currentX = currentX + 1
            end
            currentX, currentY = middleX, middleY -- Reset to middle of the room
            tempCor = {}
        end

        -- Move right
        if chanceOfNewPathway >= math.random(1, 100) then
            currentY = bottomY + 1
            while currentX > 1 and currentX < map_size and currentY > 1 and currentY < map_size do
                table.insert(tempCor, {currentX, currentY})
                table.insert(tempCor, {currentX + 1, currentY})
                table.insert(tempCor, {currentX - 1, currentY})
                if map_matrix[currentX][currentY] == 1 then
                    table.insert(corridorList, tempCor)
                    chanceOfNewPathway = chanceOfNewPathway - math.random(1, 100)
                    break
                end
                currentY = currentY + 1
            end
            currentX, currentY = middleX, middleY -- Reset to middle of the room
            tempCor = {}
        end

         -- Move up
        if chanceOfNewPathway >= math.random(1, 100) then
            currentX = topX
            while currentX > 1 and currentX < map_size and currentY > 1 and currentY < map_size do
                table.insert(tempCor, {currentX, currentY})
                table.insert(tempCor, {currentX, currentY + 1})
                table.insert(tempCor, {currentX, currentY - 1})
                if map_matrix[currentX][currentY] == 1 then
                    table.insert(corridorList, tempCor)
                    chanceOfNewPathway = chanceOfNewPathway - math.random(1, 100)
                    break
                end
                currentX = currentX - 1
            end
        end
    end

    for coridor = 1, #corridorList do
        for tile = 1, #corridorList[coridor] do
            local tileX, tileY = corridorList[coridor][tile][1],corridorList[coridor][tile][2]
            map_matrix[tileX][tileY] = 1
        end
    end

    -- 5) Cave generation --
    local map_matrix_backup = {}
    for x = 1, map_size do
        map_matrix_backup[x] = {}
        for y = 1, map_size do
            map_matrix_backup[x][y] = map_matrix[x][y]
        end
    end

    for x = 1, map_size do
        for y = 1, map_size do
            if map_matrix[x][y] == 0 then
                if math.random(1, 2) == 1 then
                    map_matrix[x][y] = 1
                end
            end
        end
    end

    for cycles = 1, 4 do
        local oldMapMatrix = map_matrix
        for x = 2, map_size - 1 do
            for y = 2, map_size - 1 do
                local cellHealth = 
                    oldMapMatrix[x+1][y+1] +
                    oldMapMatrix[x+1][y] +
                    oldMapMatrix[x+1][y-1] +
                    oldMapMatrix[x][y+1] +
                    oldMapMatrix[x][y-1] +
                    oldMapMatrix[x-1][y+1] +
                    oldMapMatrix[x-1][y] +
                    oldMapMatrix[x-1][y-1] 

                if oldMapMatrix[x][y] == 1 and cellHealth >= 4 then
                    map_matrix[x][y] = 1
                elseif oldMapMatrix[x][y] == 0 and cellHealth >= 5 then
                    map_matrix[x][y] = 1
                else
                    map_matrix[x][y] = 0
                end

            end
        end
    end

    -- Making sure map is 100% accessible
    for x = 1, map_size do
        for y = 1, map_size do
            if map_matrix_backup[x][y] == 1 then
                map_matrix[x][y] = 1
            end
        end
    end



    return map_matrix
end