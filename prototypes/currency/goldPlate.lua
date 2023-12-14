local goldPlate = table.deepcopy(data.raw["item"]["iron-gear-wheel"])

goldPlate.name = "alienShard"
goldPlate.icon = "__DeckedOut__/graphics/currency/gold-plate.png"
goldPlate.icon_size = 120
goldPlate.stack_size = 1
goldPlate.pictures = {
    layers = {{
                  size = 120,
                  width = 120,
                  height = 64,
                  filename = goldPlate.icon,
                  scale = 1
              }}
}


data:extend({goldPlate})