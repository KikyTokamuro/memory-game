Card = require("card")
Deck = require("deck") 

function love.load()
   deck = Deck:new()

   local windowWidth = love.graphics.getWidth()
   local windowHeight = love.graphics.getHeight()
   local cardWidth = 100
   local cardHeight = 120
   local gridSize = 24
   local spacing = 15

   -- Calculate the number of columns and rows that can fit in the window
   local cols = math.floor((windowWidth - spacing) / (cardWidth + spacing))
   local rows = math.floor((windowHeight - spacing) / (cardHeight + spacing))

   -- Adjust the card size and spacing to fit the window
   local adjustedCardWidth = (windowWidth - spacing * (cols + 1)) / cols
   local adjustedCardHeight = (windowHeight - spacing * (rows + 1)) / rows
   local adjustedSpacing = (windowWidth - cols * adjustedCardWidth) / (cols + 1)

   -- Calculate the x and y offsets to center the grid
   local xOffset = (windowWidth - cols * (adjustedCardWidth + adjustedSpacing)) 
   local yOffset = (windowHeight - rows * (adjustedCardHeight + adjustedSpacing)) 

   -- Layout the cards in a grid
   for i = 1, gridSize do
      local col = (i - 1) % cols
      local row = math.floor((i - 1) / cols)
      local x = col * (adjustedCardWidth + adjustedSpacing) + xOffset
      local y = row * (adjustedCardHeight + adjustedSpacing) + yOffset

      -- Generate name
      local name = ""
      if i % 2 == 0 then
         name = tostring(i-1)
      else
         name = tostring(i)
      end

      -- Add new card to deck
      deck:add(Card:new(name, x, y, adjustedCardWidth, adjustedCardHeight))
   end

   -- Suffle added cards
   deck:shuffle()

   -- Draw background
   love.graphics.setBackgroundColor(255, 255, 255, 1)
end

function love.draw()
   love.graphics.discard()

   -- Iterate over cards
   for i = 1, #deck.items do
      local d = deck.items[i]

      if not d.isSolved then
         -- Draw card
         love.graphics.setColor(0, 0, 0)
         love.graphics.rectangle('line', d.x, d.y, d.width, d.height, 10, 10)

         -- Params for card text
         local limit = 60
         local x = (d.x + d.width / 2) - limit / 2
         local y = (d.y + d.height / 2) - limit / 4
         local cardText = (d.isOpened and d.name or "#")

         -- Draw card text
         love.graphics.setFont(love.graphics.newFont(limit / 2))
         love.graphics.setColor(0, 0, 0)
         love.graphics.printf(cardText, x, y, limit, "center")
      end
   end
end

function love.update(dt)
   local firstCard = nil
   local secondCard = nil

   -- Search opened cards
   for i = 1, #deck.items do
      local c = deck.items[i]

      if c.isOpened and not c.isSolved and firstCard == nil then
         firstCard = c
         goto continue
      end

      if c.isOpened and not c.isSolved and secondCard == nil then
         secondCard = c
      end
      ::continue::
   end

   -- Update card status
   if firstCard ~= nil and secondCard ~= nil then
      if (firstCard.name == secondCard.name) then
         firstCard.isSolved = true
         secondCard.isSolved = true
      else
         firstCard:autoclose(love.timer.getTime())
         secondCard:autoclose(love.timer.getTime())
      end

      return
   end

   -- Autoclose
   if firstCard ~= nil then
      firstCard:autoclose(love.timer.getTime())
   end

   -- Autoclose
   if secondCard ~= nil then
      secondCard:autoclose(love.timer.getTime())
   end
end

function love.mousepressed(x, y, button, istouch, presses)
   -- Left button pressed
   if button == 1 then
      if deck:openedCount() >= 2 then
         deck:closeAll()
      else
         -- Iterate over cards
         for i = 1, #deck.items do
            local c = deck.items[i]

            -- Search card by coords
            if not c.isSolved and c:inside(x, y) then
               c.isOpened = true
               c.openedTime = love.timer.getTime()
            end
         end
      end
   end
end
