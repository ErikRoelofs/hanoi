if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

function love.load()
  towers = {
    {},
    {},
    {}
  }
  
  table.insert(towers[1], 8)
  table.insert(towers[1], 7)
  table.insert(towers[1], 6)
  table.insert(towers[1], 5)
  table.insert(towers[1], 4)
  table.insert(towers[1], 3)
  table.insert(towers[1], 2)
  table.insert(towers[1], 1)

  mouse = { x = 0, y = 0 }  
  mode = "select"  
  discHovered = 0
  discPickedUp = 0
  
  towerHovered = 0
end

function love.update(dt)
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
  
end

function love.mousepressed(x,y,button)
  if mode == "select" and discHovered ~= 0 then
    mode = "place"
    for tower, discs in ipairs(towers) do
      for key, disc in ipairs(discs) do
        if disc == discHovered then
          table.remove(towers[tower], key)
          discPickedUp = discHovered
        end
      end
    end  
  elseif mode == "place" and towerHovered ~= 0 then
    table.insert(towers[towerHovered], discPickedUp)
    mode = "select"
    discPickedUp = 0
  end
end


function love.draw()
  discHovered = 0
  towerHovered = 0
  drawTower(1)
  drawTower(2)
  drawTower(3)  
  
  if discPickedUp > 0 then
    love.graphics.setColor(255,255,255,255)
    discWidth = discPickedUp * 10 + 40
    discHeight = discPickedUp*3 + 10
  
    love.graphics.rectangle("fill", mouse.x - discWidth / 2, mouse.y - discHeight / 2, discWidth, discHeight)
  end
end

function drawTower(towerNum)    
    love.graphics.setColor(255,255,255,255)
    
    heightOffset = 500
    
    if mode == "place" then
      if mouse.x > 100 + (towerNum-1)*200 and mouse.x < 100 + (towerNum-1)*200 + 150 
        and mouse.y > heightOffset and mouse.y < heightOffset + 20 then
          towerHovered = towerNum
        love.graphics.setColor(0,0,255,255)
      end      
      if mouse.x > 170 + (towerNum-1)*200 and mouse.x < 170 + (towerNum-1)*200 + 10 
        and mouse.y > 100 and mouse.y < 100 + 400 then
        towerHovered = towerNum
        love.graphics.setColor(0,0,255,255)
      end      
    end
    love.graphics.rectangle("fill", 100 + (towerNum-1)*200,heightOffset,150,20)
    love.graphics.rectangle("fill", 170 + (towerNum-1)*200,100,10,400)      
    
    for _, disc in ipairs(towers[towerNum]) do
      heightOffset = drawDisc(disc, towerNum, heightOffset)
    end
    
end

function drawDisc(size, tower, heightOffset)
  love.graphics.setColor(255,255,255,255)
  discWidth = size * 10 + 40
  discHeight = size*3 + 10
  centerOfTower = (tower-1)*200 + 175
  heightOffset = heightOffset - discHeight - 1
  
  if mode == "select" then
    if mouse.x > centerOfTower - ( discWidth / 2) and mouse.x <  centerOfTower - ( discWidth / 2) + discWidth
      and mouse.y > heightOffset and mouse.y < heightOffset + discHeight then
        
      topDisk = true
      for _, disc in ipairs(towers[tower]) do
        topDisk = (disc == size)
      end
        
      if topDisk then
        love.graphics.setColor(0,0,255,255)
        discHovered = size
      else
        love.graphics.setColor(255,0,0,255)
      end
    else
      love.graphics.setColor(255,255,255,255)
    end
  end
  love.graphics.rectangle("fill", centerOfTower - ( discWidth / 2), heightOffset, discWidth, discHeight)
  
  return heightOffset
end