function createChunkMatrix()  
    -- Out of map matrix
    local oom_matrix = {}
    for x = 1, 32 do
        oom_matrix[x] = {}
        for y = 1, 32 do
            oom_matrix[x][y] = 0
        end
    end
    -- Water stream matrix
    local water_matrix = oom_matrix
    -- Permanent terrain matrix (Can't be destroyed)
    local perma_matrix = oom_matrix
    -- Temporary terrain matrix (Can be destroyed)
    local terrain_matrix = oom_matrix
    
    
    
    
end

function createWaterMatrix(water_matrix)
    for x = 1, 32 do
        for y = 1, 32 do
            if math.random(1, 2) == 1 then
                water_matrix[x][y] = 1
            end
        end
    end
    for cycles = 1, 4 do
        local new_water_matrix = water_matrix
        for x = 1, 32 do
            for y = 1, 32 do
                local cellHealth = 
                water_matrix[math.max(math.min(x + 1, 2), 31)][math.max(math.min(y + 1, 2), 31)] +
                water_matrix[math.max(math.min(x + 1, 2), 31)][math.max(math.min(y - 1, 2), 31)] +
                water_matrix[math.max(math.min(x + 1, 2), 31)][math.max(math.min(y, 2), 31)] +
                water_matrix[math.max(math.min(x, 2), 31)][math.max(math.min(y + 1, 2), 31)] +
                water_matrix[math.max(math.min(x, 2), 31)][math.max(math.min(y - 1, 2), 31)] +
                water_matrix[math.max(math.min(x - 1, 2), 31)][math.max(math.min(y + 1, 2), 31)] +
                water_matrix[math.max(math.min(x - 1, 2), 31)][math.max(math.min(y - 1, 2), 31)] +
                water_matrix[math.max(math.min(x - 1, 2), 31)][math.max(math.min(y, 2), 31)]
                if water_matrix[x][y] == 0 and cellHealth >= 4 then
                    new_water_matrix[x][y] = 1
                elseif water_matrix[x][y] == 1 and cellHealth >= 5 then
                    new_water_matrix[x][y] = 0
                else
                    new_water_matrix[x][y] = 0
                end
            end
        end
        water_matrix = new_water_matrix
    end
    return water_matrix
end

function createPermaMatrix(perma_matrix)
    -- Create room
    local room_size = math.random(5, 20)
    local topX = math.random(1, 32)
    local topY = math.random(1, 32)
    for x = topX, room_size do
        for y = topY, room_size do
            perma_matrix[x][y] = 1
        end
    end
    
    -- Run pathways from previous chunks (y = mx + b)
    topX = topX + room_size/2
    topY = topY + room_size/2
    for x = 1, 32 do
        if perma_matrix[x][1] == 1 then
            -- 1) X = x, Y = 1
            -- 2) X = topX, Y = topY
            for thickness = 1, 3 do
                for m = 1, 
            end
        end
        if perma_matrix[x][32] == 1 then
            -- 1) X = x, Y = 32
            -- 2) X = topX, Y = topY
            for thickness = 1, 3 do

            end
        end
    end
    for y = 1, 32 do
        if perma_matrix[1][y] == 1 then
            -- 1) X = 1, Y = y
            -- 2) X = topX, Y = topY
            for thickness = 1, 3 do

            end
        end
        if perma_matrix[32][y] == 1 then
            -- 1) X = 32, Y = y
            -- 2) X = topX, Y = topY
            for thickness = 1, 3 do

            end
        end
    end
    
    
    return perma_matrix
end

function getChunkMatrix(chunkPosition)
    if isChunkGenerated(chunkPosition) then
        local chunk = global.GameState.chunks[chunkPosition.x][chunkPosition.y]
        return {
            water = chunk.water_matrix,
            perma = chunk.perma_matrix,
            terrain = chunk.terrain_matrix
        }
    else
        return nil
    end
end

function isChunkGenerated(chunkPosition)
    if surface.isChunkGenerated(chunkPosition) then
        return true
    else
        return false
    end
end