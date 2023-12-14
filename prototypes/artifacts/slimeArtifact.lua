local alienEgg = table.deepcopy(data.raw["item"]["iron-gear-wheel"]
)

alienEgg.name = "slimeArtifact"
alienEgg.icon = "__DeckedOut__/graphics/artifacts/alienEgg.png"
alienEgg.icon_size = 112
alienEgg.stack_size = 1
alienEgg.pictures = {
    layers = {{
        size = 112,
        filename = alienEgg.icon,
        scale = 1
    }}
}

-- Register the new item prototype
data:extend({alienEgg})