-- A class for the game's display; handles drawing objects to the screen
require "arrayHelpers"
require "constants"
local Display = Object:extend()

-- initializer method
function Display:new(displayParams)
    self.deck = displayParams.deck
    self.pyramid = displayParams.pyramid
    self.selectedCards = displayParams.selectedCards
    self.discardPile = displayParams.discardPile
    self.resetButton = displayParams.resetButton
end

-- draws the deck to the screen
function Display:drawDeck()
    love.graphics.draw(CARD_SPRITE_SHEET, self.deck.sprite, self.deck.x, self.deck.y)
end

-- draws the top card in the discard pile next to the deck
function Display:drawDiscardPile()
    local len = self.discardPile:getLength()

    if len > 0 then
        local topCard = self.discardPile.cards[len]

        love.graphics.draw(CARD_SPRITE_SHEET, topCard.sprite, topCard.x, topCard.y)
        
        -- add highlight if selected
        if itemInArray(self.selectedCards, topCard) then
            self:drawRedBorder(topCard)
        end
    end
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
                self:drawRedBorder(card)
            end

            ::continue::
        end
    end
end

-- draws reset button to the screen
function Display:drawResetButton()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        RESET_BUTTON_SPRITE_SHEET,
        self.resetButton.sprite,
        self.resetButton.x,
        self.resetButton.y
    )
end

-- draws red border around card
function Display:drawRedBorder(card)
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("line", card.x, card.y, CARD_WIDTH, CARD_HEIGHT)
end

return Display