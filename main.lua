Card = {}

-- Card constructor
function Card:new(name, x, y, width, height)
   local card = {}
   setmetatable(card, { __index = self })
   
   card.name = name
   card.x = x
   card.y = y
   card.width = width
   card.height = height
   card.isOpened = false
   card.isSolved = false
        
   return card
end

-- Check inside in card
function Card:inside(x, y)
   return x >= self.x 
      and x < self.x + self.width
      and y >= self.y
      and y < self.y + self.height
end

Deck = {}

-- Deck constructor
function Deck:new()
   local deck = {}
   setmetatable(deck, { __index = self })
   
   deck.items = {}
   
   return deck
end

-- Add card to deck
function Deck:add(card)
   table.insert(self.items, card)
end

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

   -- Draw background
   love.graphics.setBackgroundColor(255, 255, 255, 1)
end

function love.draw()
   -- Iterate over cards
   for i=1, #deck.items do
      local d = deck.items[i]

      if d.isSolved then
	 -- Draw card
	 love.graphics.setColor(255, 255, 255)
	 love.graphics.rectangle('fill', d.x, d.y, d.width, d.height)
      else
	 -- Draw card
	 love.graphics.setColor(0, 0, 0)
	 love.graphics.rectangle('line', d.x, d.y, d.width, d.height)

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
   
end

function love.mousepressed(x, y, button, istouch, presses)
   -- Left button pressed
   if button == 1 then
      -- Iterate over cards
      for i=1, #deck.items do
	 local d = deck.items[i]

	 -- Search card by coords
	 if d:inside(x, y) then
	    d.isOpened = true

	    -- Search another opened card
	    for j=1, #deck.items do
	       local ad = deck.items[j]
	       
	       if i ~= j and ad.isOpened then
		  if (ad.name == d.name) then
		     d.isSolved = true
		     ad.isSolved = true
		     
		     return
		  else
		     ad.isOpened = false
		     d.isOpened = false
		  end
	       end
	    end
	 end
      end
   end
end