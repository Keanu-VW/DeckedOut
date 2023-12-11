local function createDungeonGui(player)
    local dungeonGui = player.gui.screen.add{
        type = "frame",
        name = "Dto_DungeonGui",
        caption = "Dungeon",
        direction = "vertical"
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Crumble",
        caption = "CrumbleBlock = "
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Clank",
        caption = "ClankBlock = "
    }
    dungeonGui.add{
        type = "button",
        name = "Dto_DungeonGui_Button_Debris",
        caption = "DebrisBlock = "
    }
end

local function updateDungeonGui(player, crumble_block, clank_block, debris_block) 
    local dungeonGui = player.gui.screen["Dto_DungeonGui"]
    dungeonGui["Dto_DungeonGui_Button_Crumble"].caption = "CrumbleBlock = " .. crumble_block
    dungeonGui["Dto_DungeonGui_Button_Clank"].caption = "ClankBlock = " .. clank_block
    dungeonGui["Dto_DungeonGui_Button_Debris"].caption = "DebrisBlock = " .. debris_block
end

local function deleteDungeonGui(player)
    player.gui.screen["Dto_DungeonGui"].destroy()
end

return {
    createDungeonGui = createDungeonGui,
    updateDungeonGui = updateDungeonGui,
    deleteDungeonGui = deleteDungeonGui
}
