-- A class for the discard pile.
require "constants"
local DiscardPile = Object:extend()

-- initializer method
function DiscardPile:new(x, y)
    self.cards = {}
    self.x, self.y = x, y
end

-- gets amount of cards in the pile
function DiscardPile:getLength()
    return #self.cards
end

-- returns a removed card from the discard
function DiscardPile:takeCard()
    return table.remove(self.cards)
end

-- returns true if discard pile has cards, or false if empty
function DiscardPile:hasCards()
    if #self.cards > 0 then return true end

    return false
end

-- returns the top card of the discard pile without removing it
function DiscardPile:getTopCard()
    if #self.cards > 0 then return self.cards[#self.cards] end

    return nil
end

return DiscardPile