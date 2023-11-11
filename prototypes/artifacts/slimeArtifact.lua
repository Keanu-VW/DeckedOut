local slimeArtifact = table.deepcopy(data.raw["item"]["iron-gear-wheel"]
)

slimeArtifact.name = "slimeArtifact"
slimeArtifact.icon = "__DeckedOut__/graphics/artifacts/slimeArtifact.png"
slimeArtifact.icon_size = 32
slimeArtifact.stack_size = 1

-- Register the new item prototype
data:extend({slimeArtifact})