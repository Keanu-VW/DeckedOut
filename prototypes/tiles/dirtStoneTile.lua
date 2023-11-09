local cobbleStoneTile = table.deepcopy(data.raw["tile"]["concrete"])

cobbleStoneTile.name = "dirtStoneTile"
cobbleStoneTile.variants = {
    main = {
        {
            picture = "__DeckedOut__/graphics/tiles/"..cobbleStoneTile.name..".png",
            count = 16,
            scale = 0.8,
            size = 1
        },
        {
            picture = "__DeckedOut__/graphics/tiles/"..cobbleStoneTile.name..".png",
            count = 16,
            scale = 0.8,
            size = 2,
            probability = 0.39
        },
        {
            picture = "__DeckedOut__/graphics/tiles/"..cobbleStoneTile.name..".png",
            count = 16,
            scale = 0.8,
            size = 4,
            probability = 1
        }
    },
    inner_corner = { picture = "", count = 0, size = 0 },
    outer_corner = { picture = "", count = 0, size = 0 },
    side = { picture = "", count = 0, size = 0 }
}

data:extend({cobbleStoneTile})
