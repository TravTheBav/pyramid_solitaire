require "classic"
local Deck = require "Deck"
local Pyramid = require "Pyramid"
local Display = require "Display"
local DiscardPile = require "DiscardPile"
local Button = require "Button"
local push = require "push"

love.graphics.setDefaultFilter("nearest", "nearest")
love.window.setTitle("Pyramid Solitare")

local gameWidth, gameHeight = 644, 362
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = math.floor(windowWidth * .8), math.floor(windowHeight * .8)

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {pixelperfect = true})
push:setBorderColor(0, .4, 0)

function love.load()
    -- make game objects
    local xOffset = 10
    local yOffset = 74
    deck = Deck((gameWidth / 2) + xOffset, (gameHeight - yOffset))
    discardPile = DiscardPile(deck.x - (CARD_WIDTH + xOffset * 2), deck.y)
    pyramid = fillPyramidRows()

    local sheetWidth, sheetHeight = RESET_BUTTON_SPRITE_SHEET:getDimensions()
    local resetButtonSprites = {
        down = love.graphics.newQuad(0, 0, 48, 32, sheetWidth, sheetHeight),
        up = love.graphics.newQuad(48, 0, 48, 32, sheetWidth, sheetHeight)
    }
    resetButton = Button((gameWidth - 48), (gameHeight - 32), 48, 32, resetButtonSprites)

    selectedCards = {}

    -- make display parameters
    local displayParams = {
        deck = deck,
        pyramid = pyramid,
        selectedCards = selectedCards,
        discardPile = discardPile,
        resetButton = resetButton
    }

    -- create display instance
    display = Display(displayParams)
end

function love.update(dt)
    local x, y = love.mouse.getPosition()

    if love.mouse.isDown(1) then
        x, y = push:toGame(x, y)

        if objectClicked(x, y, resetButton.x, resetButton.y, resetButton.width, resetButton.height) then
            resetButton:pressed()
        else
            resetButton:released()
        end
    end
end

function love.draw()
    push:start()
    
    display:drawDeck()
    display:drawDiscardPile()
    display:drawPyramid()
    display:drawResetButton()

    push:finish()
end

function love.mousereleased(x, y, button)
    if button == 1 then
        local x, y = push:toGame(x, y)

        -- game window is smaller than actual window, so we must
        -- account for cases where mouse is clicked out of invisible boundary
        if x == nil or y == nil then return end

        handleMouseClick(x, y)
    end
end

-- fills pyramid rows with cards from the deck
function fillPyramidRows()
    local rows = {}
    local card
    local cardXStart = (gameWidth / 2) - (CARD_WIDTH / 2)
    local cardX = cardXStart
    local cardY = 20
    local mult = 1

    for i = 1, 8 do
        local row = {}
        
        if i ~= 8 then
            for j = 1, i do
                card = deck:takeCard()
                card.x, card.y = cardX, cardY
                card.location = "pyramid"
                table.insert(row, card)
                cardX = cardX + CARD_WIDTH + 8
            end
        -- an empty bottom row is used to simplify certain pyramid methods
        elseif i == 8 then
            for j = 1, i do
                table.insert(row, DUMMY_CARD)
            end
        end

        cardX = cardXStart - ((CARD_WIDTH / 2) * mult) - (4 * mult)
        mult = mult + 1
        cardY = cardY + 30

        table.insert(rows, row)
    end

    return Pyramid(rows)
end

-- checks for which object the user clicked on and calls the relevant function
-- takes in x and y coordinates of the mouse release
function handleMouseClick(x, y)
    local selection = nil

    -- moves top card of deck to top of discard pile
    local function transferCard()
        local card = deck:takeCard()
        card.location = "discard"
        card.x = discardPile.x
        card.y = discardPile.y
        table.insert(discardPile.cards, card)
    end

    -- check each card in pyramid
    for rowIndex, row in ipairs(pyramid.rows) do
        for cardIndex, card in ipairs(row) do
            if card:is(DummyCard) then goto continue end

            -- add clicked card to the selected cards
            if objectClicked(x, y, card.x, card.y, CARD_WIDTH, CARD_HEIGHT)
                and pyramid:cardCovered(card) == false then
                selection = card
                break
            end

            ::continue::
        end
    end

    -- check if discard was clicked
    if objectClicked(x, y, discardPile.x, discardPile.y, CARD_WIDTH, CARD_HEIGHT)
        and discardPile:hasCards() then
            selection = discardPile:getTopCard()
    end

    -- check if deck was clicked
    if objectClicked(x, y, deck.x, deck.y, CARD_WIDTH, CARD_HEIGHT)
        and deck:hasCards() then
            transferCard()
    end

    -- check selected cards if there was a selection
    if selection then 
        table.insert(selectedCards, selection)
        checkSelectedCards()
    end

    -- check if reset button was clicked
    if objectClicked(x, y, resetButton.x, resetButton.y, resetButton.width, resetButton.height) then
        love.load()
    end
end

-- returns true if object was clicked, or false if not
function objectClicked(mouseX, mouseY, objX, objY, objWidth, objHeight)
    clicked = false

    if mouseX > objX
        and mouseX < (objX + objWidth)
        and mouseY > objY
        and mouseY < (objY + objHeight) then
            clicked = true
    end

    return clicked
end

--[[
    Checks if total value of selected cards is at 13. If there is one
    King in the selection, then the King is removed from it's location.
    If there are two cards that add up to 13, then both are removed from
    their locations. If there are two cards that do not add up to 13, then
    they are removed from the selection but not their locations.
]]
function checkSelectedCards()
    local cardTotal = 0

    for cardIndex, card in ipairs(selectedCards) do
        cardTotal = cardTotal + card.rank
    end

    -- remove cards from pyramid/discard, and the selection
    if cardTotal == 13 then
        for cardIndex, card in ipairs(selectedCards) do
            if card.location == "pyramid" then
                pyramid:removeCard(card)
            elseif card.location == "discard" then
                discardPile:takeCard()
            end
        end

        emptySelectedCards()
    end

    -- clear the selection if there are 2 selected cards that do not add to 13
    if #selectedCards > 1 then
        emptySelectedCards()
    end
end

-- prints selected cards to console
function printSelected()
    local line = ""

    for cardIndex, card in ipairs(selectedCards) do
        line = line .. card:__tostring() .. " "
    end

    print(line)
end

-- empties the selected cards array
function emptySelectedCards()
    local i = 1

    while selectedCards[i] do
        table.remove(selectedCards)
    end
end
