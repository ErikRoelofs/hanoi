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

end

function love.update(dt)
  
end

function love.draw()
  drawTower(1)
  drawTower(2)
  drawTower(3)
  
end

function drawTower(towerNum)
    
    heightOffset = 500
    
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
  
  love.graphics.rectangle("fill", centerOfTower - ( discWidth / 2), heightOffset, discWidth, discHeight)
  
  return heightOffset
end
