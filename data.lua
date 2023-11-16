require("prototypes/tiles/cobbleStoneTile.lua")
require("prototypes/tiles/dirtStoneTile.lua")
require("prototypes/walls/cobbleStoneWall.lua")
require("prototypes/artifacts/slimeArtifact.lua")

local styles = data.raw["gui-style"].default


styles["Dto_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}