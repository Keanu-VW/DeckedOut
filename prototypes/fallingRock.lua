local fallingRockExplosion = table.deepcopy(data.raw["explosion"]["grenade-explosion"])

fallingRockExplosion.type = "explosion"
fallingRockExplosion.name = "falling-rock"
fallingRockExplosion.flags = {"not-on-map"}
fallingRockExplosion.animations = {
    {
        filename = "__DeckedOut__/graphics/fallingRock.png",
        priority = "high",
        width = 102,
        height = 264,
        frame_count = 18,
        line_length = 6,  -- Adjusted to match the number of frames in a single row
        animation_speed = 0.2,
        scale = 10
    }
}
fallingRockExplosion.light = {intensity = 1, size = 20}
fallingRockExplosion.sound =
{
    {
        filename = "__base__/sound/fight/large-explosion-1.ogg",
        volume = 0.75
    }
}
fallingRockExplosion.time_to_live = 300 -- Adjust this value to set the delay in ticks

data:extend{fallingRockExplosion}