local alienShard = table.deepcopy(data.raw["item"]["iron-gear-wheel"])

alienShard.name = "alienShard"
alienShard.icon = "__DeckedOut__/graphics/artifacts/alienEgg.png"
alienShard.icon_size = 112
alienShard.stack_size = 1
alienShard.pictures = {
    layers = {{
                  size = 112,
                  filename = alienShard.icon,
                  scale = 1
              }}
}


data:extend({alienShard})