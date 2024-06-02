Card = {}

-- Card constructor
function Card:new(name, x, y, width, height)
    local card = {}
    setmetatable(card, {__index = self})

    card.name = name
    card.x = x
    card.y = y
    card.width = width
    card.height = height
    card.isOpened = false
    card.isSolved = false
    card.openedTime = 0
    card.openDuration = 2

    return card
end

-- Check inside in card
function Card:inside(x, y)
    return x >= self.x and x < self.x + self.width and y >= self.y and y <
               self.y + self.height
end

-- Autoclose by duration
function Card:autoclose(currentTime)
    if self.openedTime + self.openDuration < currentTime then
        self.isOpened = false
    end
end

return Card
