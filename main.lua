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
end

function love.update(dt)
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
end

function love.draw()
  drawTower(1)
  drawTower(2)
  drawTower(3)
end

function drawTower(towerNum)    
    heightOffset = 500
    
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", 100 + (towerNum-1)*200,heightOffset,150,20)
    love.graphics.rectangle("fill", 170 + (towerNum-1)*200,100,10,400)
    
    for _, disc in ipairs(towers[towerNum]) do
      heightOffset = drawDisc(disc, towerNum, heightOffset)
    end
    
end

function drawDisc(size, tower, heightOffset)
  discWidth = size * 10 + 40
  discHeight = size*3 + 10
  centerOfTower = (tower-1)*200 + 175
  heightOffset = heightOffset - discHeight - 1
  
  if mouse.x > centerOfTower - ( discWidth / 2) and mouse.x <  centerOfTower - ( discWidth / 2) + discWidth and
    mouse.y > heightOffset and mouse.y < heightOffset + discHeight then
    love.graphics.setColor(0,0,255,255) 
  else
    love.graphics.setColor(255,255,255,255)
  end
  
  love.graphics.rectangle("fill", centerOfTower - ( discWidth / 2), heightOffset, discWidth, discHeight)
  
  return heightOffset
end
