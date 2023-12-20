local goldPlate = table.deepcopy(data.raw["item"]["iron-gear-wheel"])

goldPlate.name = "goldPlate"
goldPlate.icon = "__DeckedOut__/graphics/currency/gold-plate.png"
goldPlate.icon_size = 112
goldPlate.stack_size = 1
goldPlate.pictures = {
    layers = {{
                  size = 112,
                  filename = goldPlate.icon,
                  scale = 1
              }}
}
goldPlate.stack_size = 100

data:extend({goldPlate})