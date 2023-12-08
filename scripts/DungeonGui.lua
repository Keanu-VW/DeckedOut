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
        caption = "CrumbleBlock = " .. global.CrumbleBlock
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Clank",
        caption = "ClankBlock = " .. global.clankBlock
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Debris",
        caption = "DebrisBlock = " .. global.debrisBlock
    }
end

function updateDungeonGui(player) 
    local dungeonGui = player.gui.screen["Dto_DungeonGui"]
    dungeonGui["Dto_DungeonGui_Button_Crumble"].caption = "CrumbleBlock = " .. global.CrumbleBlock
    dungeonGui["Dto_DungeonGui_Button_Clank"].caption = "ClankBlock = " .. global.clankBlock
    dungeonGui["Dto_DungeonGui_Button_Debris"].caption = "DebrisBlock = " .. global.debrisBlock
end

function deleteDungeonGui(player)
    player.gui.screen["Dto_DungeonGui"].destroy()
end
