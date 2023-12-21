local text_entities = {}
local start_ticks = {}


commands.add_command("test", "Test", function(command)
    local player = game.players[command.player_index]
    animate_text(player, "Hello world", "default", {r = 1, g = 1, b = 1}, 5, player.character)
end)


function animate_text(player, text, animation_style, color, size, position)
    if text_entities[player.index] and rendering.is_valid(text_entities[player.index]) then
        rendering.destroy(text_entities[player.index])
    end

    text_entities[player.index] = rendering.draw_text{
        text = text,
        surface = player.surface,
        target = position or player.character,
        target_offset = {0, -2},
        color = color or {r = 1, g = 1, b = 1},
        scale = size or 5,
        font = "default-game",
        alignment = "center",
        scale_with_zoom = true,
        time_to_live = 120
    }
    local new_x = 0
    local new_y = 0
    start_ticks[player.index] = game.tick

    -- Register the update function to run every tick for this player
    script.on_nth_tick(player.index, function()
        local text_entity = text_entities[player.index]
        local start_tick = start_ticks[player.index]

        if text_entity and rendering.is_valid(text_entity) then
            if game.tick - start_tick > 120 then
                rendering.destroy(text_entity)
                text_entities[player.index] = nil
                start_ticks[player.index] = nil
                script.on_nth_tick(player.index, nil)  -- Unregister the event handler
            else
                local elapsed_ticks = game.tick - start_tick
                new_x, new_y = InOutFadeHorizontal(elapsed_ticks)
                -- Subtract 100 pixels (converted to tiles) to start the animation 100 pixels to the left
                local new_position = {player.character.position.x + new_x, player.character.position.y + new_y}
                rendering.set_target(text_entity, new_position)
            end
        end
    end)
end

function InOutFadeHorizontal(elapsed_ticks)
    local x = math.pow((elapsed_ticks-60), 5)/2800 * 0.002
    return x, 0
end
function InOutFadeVertical(elapsed_ticks)
    local y = math.pow((elapsed_ticks-60), 5)/2800 * 0.002
    return 0, y
end

--[[
commands.add_command("test", "Test", function(command)
    local player = game.players[command.player_index]
    local player_index = player.index

    -- If there's already a text entity for this player, destroy it
    if text_entities[player_index] and rendering.is_valid(text_entities[player_index]) then
        rendering.destroy(text_entities[player_index])
    end

    -- Create a new text entity for this player
    text_entities[player_index] = rendering.draw_text{
        text = "Hello world",
        surface = player.surface,
        target = player.character,
        target_offset = {0, -2},
        color = {r = 1, g = 1, b = 1},
        scale = 5,
        font = "default-game",
        alignment = "center",
        scale_with_zoom = false,
        time_to_live = 120,
        scale_with_zoom = true
    }
    
    local new_x = 0
    -- Store the start tick for this player
    start_ticks[player_index] = game.tick

    -- Register the update function to run every tick for this player
    script.on_nth_tick(player_index, function()
        local text_entity = text_entities[player_index]
        local start_tick = start_ticks[player_index]

        if text_entity and rendering.is_valid(text_entity) then
            if game.tick - start_tick > 120 then
                rendering.destroy(text_entity)
                text_entities[player_index] = nil
                start_ticks[player_index] = nil
                script.on_nth_tick(player_index, nil)  -- Unregister the event handler
            else
                local elapsed_ticks = game.tick - start_tick
                new_x = math.pow((elapsed_ticks-60), 5)/2800 * 0.002
                -- Subtract 100 pixels (converted to tiles) to start the animation 100 pixels to the left
                local new_position = {player.character.position.x + new_x, player.character.position.y}
                rendering.set_target(text_entity, new_position)
            end
        end
    end)
end)

]]--