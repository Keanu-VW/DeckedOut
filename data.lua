require("prototypes/tiles/cobbleStoneTile.lua")
require("prototypes/tiles/dirtStoneTile.lua")
require("prototypes/walls/cobbleStoneWall.lua")
require("prototypes/artifacts/slimeArtifact.lua")
require("prototypes/fallingRock.lua")

local styles = data.raw["gui-style"].default


styles["Dto_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0
}

styles["Dto_card_frame"] = {
    type = "frame_style",
    height = 40,
    horizontally_stretchable = "on"
}

styles["Dto_card_button"] = {
    type = "button_style",
    horizontally_stretchable = "on"
}

styles["Dto_toolbar_style"] = {
    type="frame_style",
    use_header_filler = false,
    top_padding = 2,
    bottom_padding = -4,
    left_padding = 2,
    right_padding = 2,

}