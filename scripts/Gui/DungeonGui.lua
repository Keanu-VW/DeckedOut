-- Event handler for surface change
function createDungeonGui(player)
    local dungeonGui = player.gui.screen.add{
        type = "frame",
        name = "Dto_DungeonGui",
        caption = "Dungeon",
        direction = "vertical"
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Crumble",
        caption = "CrumbleBlock = " .. global.GameState.crumble_block
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Clank",
        caption = "ClankBlock = " .. global.GameState.clank_block
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Debris",
        caption = "DebrisBlock = " .. global.GameState.debris_block
    }
end

function updateDungeonGui(player) 
    local dungeonGui = player.gui.screen["Dto_DungeonGui"]
    dungeonGui["Dto_DungeonGui_Button_Crumble"].caption = "CrumbleBlock = " .. global.GameState.crumble_block
    dungeonGui["Dto_DungeonGui_Button_Clank"].caption = "ClankBlock = " .. global.GameState.clank_block
    dungeonGui["Dto_DungeonGui_Button_Debris"].caption = "DebrisBlock = " .. global.GameState.debris_block
end

function deleteDungeonGui(player)
    player.gui.screen["Dto_DungeonGui"].destroy()
end
