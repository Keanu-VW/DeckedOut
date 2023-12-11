Card = {
    new = function(name, func, maxAmount, description)
        local self = {}
        self.name = name
        self.func = func
        self.maxAmount = maxAmount
        self.description = description
        global.DTO.cards[name] = self
        return self
    end
}