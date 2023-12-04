require("prototypes/tiles/cobbleStoneTile.lua")
require("prototypes/tiles/dirtStoneTile.lua")
require("prototypes/walls/cobbleStoneWall.lua")
require("prototypes/artifacts/slimeArtifact.lua")
require("prototypes/fallingRock.lua")

local styles = data.raw["gui-style"].default

styles["Dto_card_frame"] = {
    type = "button_style",
    left_padding = 4,
    right_padding = 4,
    horizontally_stretchable = "on",
    horizontally_squashable = "on",
    disabled_font_color = {1, 1, 1},
    minimal_width = 0,
    ignored_by_search = false,
    horizontal_align = "left",
    font = "default-listbox",
    default_font_color = {1, 1, 1},
    minimal_height = 28,
    top_padding = 0,
    bottom_padding = 0,
    left_click_sound = {
        {
            filename = "__core__/sound/gui-click.ogg",
            volume = 1
        }
    },
    hovered_font_color = {0, 0, 0},
    clicked_font_color = {0, 0, 0},
    striketrough_color = {0.5, 0.5, 0.5},
    pie_progress_color = {1, 1, 1},
    clicked_vertical_offset = 1
}


styles["Dto_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0
}



styles["Dto_card_button"] = {
    type = "button_style",
    horizontally_stretchable = "on"
}

styles["Dto_toolbar_style"] = {
    type = "frame_style",
    use_header_filler = false,
    top_padding = 2,
    bottom_padding = -4,
    left_padding = 2,
    right_padding = 2
}