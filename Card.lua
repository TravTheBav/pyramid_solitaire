-- A class for a standard playing card.

Object = require "classic"
Card = Object:extend()

-- initializer method
function Card:new(suit, rank, sprite)
    self.suit = suit
    self.rank = rank
    self.sprite = sprite
    self.x = 0
    self.y = 0
    self.location = "deck"
end

-- string metamethod
function Card:__tostring()
    return "[" .. self.rank .. " of " .. self.suit .. "s]"
end