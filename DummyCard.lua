-- A class for a dummy card. Has no rank or suit and is used
-- to maintain empty positions in the pyramid
require "Card"
DummyCard = Card:extend()

function DummyCard:new(suit, rank)
    Card.super.new(self, suit, rank)
end

function DummyCard:__tostring()
    return "[empty]"
end

-- a singleton dummy card constant
DUMMY_CARD = DummyCard('nil', 'nil')