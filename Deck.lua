-- A class for a deck of Card objects.

require "constants"
Object = require "classic"
require "Card"
Deck = Object:extend()

-- initializer method
function Deck:new(x, y)
    local sheetWidth, sheetHeight = CARD_SPRITE_SHEET:getDimensions()

    self.cards = {}
    self.x, self.y = x, y
    self.sprites = {}
    self.sprites.full = love.graphics.newQuad(0, 256, CARD_WIDTH, CARD_HEIGHT, sheetWidth, sheetHeight)
    self.sprites.empty = love.graphics.newQuad(96, 256, CARD_WIDTH, CARD_HEIGHT, sheetWidth, sheetHeight)
    self.sprite = self.sprites.full

    local cardY = 0    
    -- set card sprites and coordinates
    for suitIndex, suit in ipairs({'club', 'spade', 'diamond', 'heart'}) do
        local cardX = 0

        for rank = 1, 13 do
            local sprite = love.graphics.newQuad(cardX, cardY, CARD_WIDTH, CARD_HEIGHT, sheetWidth, sheetHeight)
            table.insert(self.cards, Card(suit, rank, sprite))
            cardX = cardX + CARD_WIDTH
        end

        cardY = cardY + CARD_HEIGHT
    end

    self:shuffle()
end

-- prints all cards in the deck to console
function Deck:printCards()
    for cardIndex, card in ipairs(self.cards) do
        print(card)
    end
end

-- shuffles the deck
function Deck:shuffle()
    local tmp
    local swapIndex
    local arrLen = #self.cards

    for cardIndex, card in ipairs(self.cards) do
        swapIndex = love.math.random(arrLen)
        tmp = self.cards[cardIndex]
        self.cards[cardIndex] = self.cards[swapIndex]
        self.cards[swapIndex] = tmp
    end
end

-- returns amount of cards in deck
function Deck:getLength()
    return #self.cards
end

-- removes a card from the top of the deck and returns it
function Deck:takeCard()
    local card = table.remove(self.cards)

    if #self.cards == 0 then
        self.sprite = self.sprites["empty"]
    end

    return card
end

-- returns true if deck has cards, or false if empty
function Deck:hasCards()
    if #self.cards > 0 then return true end

    return false
end
