-- Define the new tile prototype
local artifactSpawnTile = table.deepcopy(data.raw["lamp"]["small-lamp"])

artifactSpawnTile.name = "artifactSpawnTile"

-- Register the new tile prototype
data:extend({artifactSpawnTile})