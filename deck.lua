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

-- Get card by id
function Deck:get(idx)
   return self.items[idx]
end

-- Count of cards
function Deck:count()
   return #self.items
end

-- Count of opened cards
function Deck:openedCount()
   local count = 0
   
   for i = 1, self:count() do
      if self:get(i).isOpened then
         count = count + 1
      end
   end

   return count
end

-- Count of solved cards
function Deck:solvedCount()
   local count = 0
   
   for i = 1, self:count() do
      if self:get(i).isSolved then
         count = count + 1
      end
   end

   return count
end

-- Close all cards
function Deck:closeAll()
   for i = 1, self:count() do
      self:get(i).isOpened = false
   end
end

-- Shuffle cards
function Deck:shuffle()
   -- Generate a secure seed for the PRNG
   local seed = os.time() + math.random(1000000)
   math.randomseed(seed)

   for i = self:count(), 2, -1 do
		local j = math.random(i)
		
		-- Swap x
		self:get(i).x, self:get(j).x = self:get(j).x, self:get(i).x

		-- Swap y
		self:get(i).y, self:get(j).y = self:get(j).y, self:get(i).y
	end
end

-- Fill deck
function Deck:fill(windowWidth, windowHeight, cardWidth, cardHeight, gridSize, spacing)
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
      self:add(Card:new(name, x, y, adjustedCardWidth, adjustedCardHeight))
   end
end

return Deck
