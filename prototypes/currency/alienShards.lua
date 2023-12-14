local alienShard = table.deepcopy(data.raw["item"]["iron-gear-wheel"])

alienShard.name = "alienShard"
alienShard.icon = "__DeckedOut__/graphics/currency/alienShard.png"
alienShard.icon_size = 120
alienShard.stack_size = 1
alienShard.pictures = {
    layers = {{
                  size = 120,
                  width = 120,
                  height = 64,
                  filename = alienShard.icon,
                  scale = 1
              }}
}


data:extend({alienShard})