if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()
  
  local drawTower = function(self)
    love.graphics.setColor(self.color)
    
    local heightOffset = 500
    
    love.graphics.rectangle("fill", self.x,heightOffset,150,20)
    love.graphics.rectangle("fill", self.x + 70,100,10,400)

    for _, disc in ipairs(self.discs) do
      heightOffset = drawDisc(disc, self, heightOffset)
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

  towerBaseColor = {150,75,75,255}
  towerGoodHighlightColor = {150,75,255,255}
  towerBadHighlightColor = {255,75,75,255}
  
  discBaseColor = {75,150,75,255}
  discGoodHighlightColor = {75,150,255,255}
  discBadHighlightColor = {255,150,75,255}
  
  towers = {
    {
      discs = {},
      x = 100,
      isHovered = isTowerHovered,
      draw = drawTower,
      color = towerBaseColor,
      isValidDrop = isTowerValidDrop
    },
    {
      discs = {},
      x = 300,
      isHovered = isTowerHovered,
      draw = drawTower,
      color = towerBaseColor,
      isValidDrop = isTowerValidDrop
    },
    {
      discs = {},
      x = 500,
      isHovered = isTowerHovered,
      draw = drawTower,
      color = towerBaseColor,
      isValidDrop = isTowerValidDrop
    }
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
  while i > 0 do
    local disc = { 
      size = i, 
      width = i*10+40, 
      height = i*3+10 
    }
    table.insert(towers[1].discs, disc)
    i = i - 1
  end
end

function love.update(dt)
  
  resetHover()
  
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
  
  for num, tower in ipairs(towers) do
    tower.color = towerBaseColor
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
      end
    end
  end
end

function dropDisc()
  table.insert(towers[towerHovered].discs, discPickedUp)
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
      love.graphics.setColor(discBaseColor)
      love.graphics.rectangle("fill", mouse.x - discPickedUp.width / 2, mouse.y - discPickedUp.height / 2, discPickedUp.width, discPickedUp.height)
    end
  end
end

function drawDisc(disc, tower, heightOffset)
  love.graphics.setColor(discBaseColor)  
  local centerOfTower = tower.x + 75
  heightOffset = heightOffset - disc.height - 1
  
  if mode == "select" then
    if mouse.x > centerOfTower - ( disc.width / 2) and mouse.x <  centerOfTower - ( disc.width / 2) + disc.width
      and mouse.y > heightOffset and mouse.y < heightOffset + disc.height then        
      if isTopDisk(disc, tower) then
        love.graphics.setColor(discGoodHighlightColor)
        discHovered = disc
      else
        love.graphics.setColor(discBadHighlightColor)
      end
    else
      love.graphics.setColor(discBaseColor)
    end
  end
  love.graphics.rectangle("fill", centerOfTower - ( disc.width / 2), heightOffset, disc.width, disc.height)
  
  return heightOffset
end

function isTopDisk(targetDisc, tower)
  local topDisk = true
  for _, disc in ipairs(tower.discs) do
    topDisk = (disc == targetDisc)
  end
  return topDisk
end

function gameIsWon()
  return #towers[3].discs == numDiscs
end