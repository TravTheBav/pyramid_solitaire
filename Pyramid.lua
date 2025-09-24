--[[
    A class representing a card pyramid. The pyramid has
    one card at the top, 2 on the second row, ... , and 7
    on the last row. Cards in the pyramid may only be selected
    when they are not covered by other cards.
]]

Object = require "classic"
require "DummyCard"
Pyramid = Object:extend()
dummyCard = DummyCard(nil, nil)

--[[ 
    initializer method
    rows: a 2D array, with 1 card in the first array, 2 in the second,
    ... , and 7 in the last.
]]
function Pyramid:new(rows)
    self.rows = rows
    self.length = 28
end

-- rows getter method
function Pyramid:getRows()
    return self.rows
end

-- returns amount of cards in pyramid
function Pyramid:getLength()
    return self.length
end

-- prints each row of the pyramid
function Pyramid:printCards()
    for rowIndex, row in ipairs(self.rows) do
        local line = ""

        for cardIndex, card in ipairs(row) do
            line = line .. card:__tostring() .. " "
        end

        print(line)
    end
end

-- returns the position of the card in the 2D rows array
function Pyramid:getCardPosition(card)
    local pos = nil

    for rowIndex, row in ipairs(self.rows) do
        for curCardIndex, curCard in ipairs(row) do
            if curCard == card then
                pos = {rowIndex, curCardIndex}
                break
            end
        end
    end

    return pos
end

--[[
    returns true if the card is covered by cards in the row below
    it, otherwise returns false
]]
function Pyramid:cardCovered(card)
    local pos = self:getCardPosition(card)
    local row, col = pos[1], pos[2]
    local bottomLeft, bottomRight = self.rows[row + 1][col], self.rows[row + 1][col + 1]

    if (bottomLeft:is(DummyCard) == false)
        or (bottomRight:is(DummyCard) == false) then
            return true
    end

    return false
end

--[[
    Removes a card from the pyramid by setting its location in self.rows
    to nil.
]]
function Pyramid:removeCard(card)
    local pos = self:getCardPosition(card)
    local row = pos[1]
    local col = pos[2]

    self.rows[row][col] = DUMMY_CARD

    -- update length
    self.length = self.length - 1
end
