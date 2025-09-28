-- a class for a generic button
local Button = Object:extend()

-- initializer
function Button:new(x, y, width, height, sprites)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.sprites = sprites
    self.sprite = self.sprites.up
end

function Button:pressed()
    self.sprite = self.sprites.down
end

function Button:released()
    self.sprite = self.sprites.up
end

return Button