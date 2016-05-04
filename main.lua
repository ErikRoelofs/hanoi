if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()
  towers = {
    {},
    {},
    {}
  }
  
  towerBaseColor = {150,75,75,255}
  towerGoodHighlightColor = {150,75,255,255}
  towerBadHighlightColor = {255,75,75,255}
  
  discBaseColor = {75,150,75,255}
  discGoodHighlightColor = {75,150,255,255}
  discBadHighlightColor = {255,150,75,255}

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
    local disc = { size = i }
    table.insert(towers[1], disc)
    i = i - 1
  end
end

function love.update(dt)
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
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
  for tower, discs in ipairs(towers) do
    for key, disc in ipairs(discs) do
      if disc == discToPick then
        discPickedUp = table.remove(towers[tower], key)        
      end
    end
  end
end

function dropDisc()
  table.insert(towers[towerHovered], discPickedUp)
  discPickedUp = nil
end

function love.draw()
  
  if gameIsWon() then
    love.graphics.print("You won the game.", 350,300)
  else
    resetHover()
    drawTower(1)
    drawTower(2)
    drawTower(3)  
    
    if discPickedUp then
      love.graphics.setColor(discBaseColor)
      local discWidth, discHeight  = discDimensions(discPickedUp)
    
      love.graphics.rectangle("fill", mouse.x - discWidth / 2, mouse.y - discHeight / 2, discWidth, discHeight)
    end
  end
end

function drawTower(towerNum)    
    love.graphics.setColor(towerBaseColor)
    
    local heightOffset = 500
    
    if mode == "place" then
      if hoversTower(towerNum) then
        handleTowerHover(discPickedUp, towerNum)      
      end
    end
    love.graphics.rectangle("fill", 100 + (towerNum-1)*200,heightOffset,150,20)
    love.graphics.rectangle("fill", 170 + (towerNum-1)*200,100,10,400)      
    
    for _, disc in ipairs(towers[towerNum]) do
      heightOffset = drawDisc(disc, towerNum, heightOffset)
    end
    
end

function hoversTower(towerNum)
  if mouse.x > 100 + (towerNum-1)*200 and mouse.x < 100 + (towerNum-1)*200 + 150 
    and mouse.y > 500 and mouse.y < 500 + 20 then                  
    return true
  end      
  if mouse.x > 170 + (towerNum-1)*200 and mouse.x < 170 + (towerNum-1)*200 + 10 
    and mouse.y > 100 and mouse.y < 100 + 400 then        
    return true
  end        
end

function drawDisc(disc, tower, heightOffset)
  love.graphics.setColor(discBaseColor)
  local discWidth, discHeight = discDimensions(disc)
  local centerOfTower = (tower-1)*200 + 175
  heightOffset = heightOffset - discHeight - 1
  
  if mode == "select" then
    if mouse.x > centerOfTower - ( discWidth / 2) and mouse.x <  centerOfTower - ( discWidth / 2) + discWidth
      and mouse.y > heightOffset and mouse.y < heightOffset + discHeight then        
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
  love.graphics.rectangle("fill", centerOfTower - ( discWidth / 2), heightOffset, discWidth, discHeight)
  
  return heightOffset
end

function isTopDisk(targetDisc, tower)
  local topDisk = true
  for _, disc in ipairs(towers[tower]) do
    topDisk = (disc == targetDisc)
  end
  return topDisk
end

function handleTowerHover(discPickedUp, towerNum)
  if isDropValid(discPickedUp, towerNum) then
    towerHovered = towerNum
    love.graphics.setColor(towerGoodHighlightColor)
  else
    love.graphics.setColor(towerBadHighlightColor)
  end  
end

function isDropValid(discPicked, towerNum)
  local valid = true
  for _, disc in ipairs(towers[towerNum]) do          
    if disc.size < discPicked.size then
      valid = false
    end
  end
  return valid
end

function gameIsWon()
  return #towers[3] == numDiscs
end

function discDimensions(disc)
  return disc.size * 10 + 40, disc.size *3 + 10
end