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

-- Count of opened cards
function Deck:openedCount()
   local count = 0
   
   for i = 1, #self.items do
      if self.items[i].isOpened then
         count = count + 1
      end
   end

   return count
end

-- Close all cards
function Deck:closeAll()
   for i = 1, #self.items do
      self.items[i].isOpened = false
   end
end

-- Shuffle cards
function Deck:shuffle()
   -- Generate a secure seed for the PRNG
   local seed = os.time() + math.random(1000000)
   math.randomseed(seed)

   for i = #self.items, 2, -1 do
		local j = math.random(i)
		
		-- Swap x
		self.items[i].x, self.items[j].x = self.items[j].x, self.items[i].x

		-- Swap y
		self.items[i].y, self.items[j].y = self.items[j].y, self.items[i].y
	end
end

return Deck
