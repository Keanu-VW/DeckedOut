local cobbleStoneWall = table.deepcopy(data.raw["wall"]["stone-wall"])

cobbleStoneWall.name = "cobbleStoneWall"

cobbleStoneWall.pictures = {
    single = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    straight_vertical = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWallV.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    straight_horizontal = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    corner_right_down = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    corner_left_down = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    t_up = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    ending_right = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    },
    ending_left = {
        layers = {
            {
                filename = "__DeckedOut__/graphics/walls/cobbleStoneWall.png",
                priority = "extra-high",
                width = 64,
                height = 92,
                variation_count = 6,
                line_length = 6,
                shift = util.by_pixel(0, -2),
                scale = 0.5
            }
        }
    }
}

data:extend({cobbleStoneWall})
