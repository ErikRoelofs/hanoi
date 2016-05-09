if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()
  
  local drawTower = function(self)
    love.graphics.setColor(self.color)
    
    local heightOffset = 500
    
    love.graphics.rectangle("fill", self.x,heightOffset,150,20)
    love.graphics.rectangle("fill", self.x + 70,100,10,400)

    for _, disc in ipairs(self.discs) do
      heightOffset = disc:draw()
    end
  end
  
  local isTowerHovered = function(self, x, y)
    if x > self.x and x < self.x + 150 
      and y > 500 and y < 500 + 20 then                  
      return true
    end      
    if x > self.x + 70 and x < self.x + 70 + 10
      and y > 100 and y < 100 + 400 then
      return true
    end
    return false
  end
  
  local isTowerValidDrop = function(self, discPicked)
    local valid = true
    for _, disc in ipairs(self.discs) do
      if disc.size < discPicked.size then
        valid = false
      end
    end
    return valid  
  end
  
  local towerAddDisc = function(self, disc)      
    local height = 500
    for _, currentDisc in ipairs(self.discs) do
      height = height - currentDisc.height - 1
    end
    height = height - (disc.height / 2) - 1
    disc.x = self.x + 75
    disc.y = height
    table.insert(self.discs, disc)
  end

  local isTopDisc = function(self, targetDisc)
    local topDisc = true
    for _, disc in ipairs(self.discs) do
      topDisc = (disc == targetDisc)
    end
    return topDisc
  end

  towerBaseColor = {150,75,75,255}
  towerGoodHighlightColor = {150,75,255,255}
  towerBadHighlightColor = {255,75,75,255}
  
  discBaseColor = {75,150,75,255}
  discGoodHighlightColor = {75,150,255,255}
  discBadHighlightColor = {255,150,75,255}
  
  local function makeTower(num)
    return {
      discs = {},
      x = 100 + (200 * (num-1)),
      isHovered = isTowerHovered,
      draw = drawTower,
      color = towerBaseColor,
      isValidDrop = isTowerValidDrop,
      addDisc = towerAddDisc,
      isTopDisc = isTopDisc
    }    
  end
  
  towers = {
    makeTower(1),
    makeTower(2),
    makeTower(3),
  }
  
  numDiscs = 8
  makeDiscs(numDiscs)
  
  mouse = { x = 0, y = 0 }  
  mode = "select"  
  resetHover()
  discPickedUp = nil
  
end

function resetHover()
  discHovered = nil
  towerHovered = nil
end

function makeDiscs(amount)
  local i = amount
  local drawDisk = function(self)
    love.graphics.setColor(self.color)  
    local centerOfTower = self.x    
    love.graphics.rectangle("fill", self.x - ( self.width / 2), self.y - (self.height / 2), self.width, self.height)    
  end
  local isHovered = function(self, x, y)
    if x > self.x - ( self.width / 2) and x <  self.x + ( self.width / 2)
      and y > self.y - ( self.height / 2 ) and y < self.y + (self.height / 2) then        
      return true
    end
    return false
  end
  while i > 0 do
    local disc = { 
      size = i,
      width = i*10+40,
      height = i*3+10,
      color = discBaseColor,
      draw = drawDisk,
      x = 0,
      y = 0,
      isHovered = isHovered
    }    
    towers[1]:addDisc(disc)
    i = i - 1
  end
end

function love.update(dt)
  
  resetHover()
  
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
  
  for num, tower in ipairs(towers) do
    tower.color = towerBaseColor
    for _, disc in ipairs(tower.discs) do
      disc.color = discBaseColor
    end
  end
  
  if mode == "select" then
    for num, tower in ipairs(towers) do
      for _, disc in ipairs(tower.discs) do
        if disc:isHovered(mouse.x, mouse.y) then
          if tower:isTopDisc(disc) then
            disc.color = discGoodHighlightColor
            discHovered = disc
          else
            disc.color = discBadHighlightColor
          end
        end
      end
    end
  end
    
  if mode == "place" then
    for num, tower in ipairs(towers) do
      if tower:isHovered(mouse.x, mouse.y) then
        if tower:isValidDrop(discPickedUp) then
          towerHovered = num        
          tower.color = towerGoodHighlightColor
        else
          tower.color = towerBadHighlightColor
        end
      end
    end
  end
  
  if discPickedUp then
    discPickedUp.x = mouse.x
    discPickedUp.y = mouse.y
  end
  
end

function love.mousepressed(x,y,button)
  if mode == "select" and discHovered ~= nil then
    pickupDisc(discHovered)
    mode = "place"
  elseif mode == "place" and towerHovered ~= nil then    
    dropDisc()
    mode = "select"    
  end
end

function pickupDisc(discToPick)
  for towerNum, tower in ipairs(towers) do
    for key, disc in ipairs(tower.discs) do
      if disc == discToPick then
        discPickedUp = table.remove(towers[towerNum].discs, key)
        discPickedUp.color = discBaseColor
      end
    end
  end
end

function dropDisc()
  towers[towerHovered]:addDisc(discPickedUp)
  discPickedUp = nil
end

function love.draw()
  
  if gameIsWon() then
    love.graphics.print("You won the game.", 350,300)
  else    
    towers[1]:draw()
    towers[2]:draw()
    towers[3]:draw()
    
    if discPickedUp then
      discPickedUp:draw()
    end
  end
end

function gameIsWon()
  return #towers[3].discs == numDiscs
end