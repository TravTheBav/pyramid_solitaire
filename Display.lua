-- A class for the game's display; handles drawing objects to the screen

require "arrayHelpers"
require "constants"
Object = require "classic"
Display = Object:extend()

-- initializer method
function Display:new(deck, pyramid, selectedCards)
    self.deck = deck
    self.pyramid = pyramid
    self.selectedCards = selectedCards
end

-- draws the deck to the screen
function Display:drawDeck()
    love.graphics.draw(CARD_SPRITE_SHEET, self.deck.sprite, self.deck.x, self.deck.y)
end

-- draws the card pyramid to the screen
function Display:drawPyramid()
    for rowIndex, row in ipairs(self.pyramid.rows) do
        for cardIndex, card in ipairs(row) do
            if card:is(DummyCard) then goto continue end
            
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(CARD_SPRITE_SHEET, card.sprite, card.x, card.y)

            -- add border highlight to any selected cards
            if itemInArray(self.selectedCards, card) then
                love.graphics.setColor(1, 0, 0, 0.5)
                love.graphics.rectangle("line", card.x, card.y, CARD_WIDTH, CARD_HEIGHT)
            end

            ::continue::
        end
    end
end