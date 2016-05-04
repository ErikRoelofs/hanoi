function love.load()
  towers = {
    {},
    {},
    {}
  }
end

function love.update(dt)
  
end

function love.draw()
  drawTower(1)
  drawTower(2)
  drawTower(3)
  
  drawDisc(8, 2)
  drawDisc(7, 1)
  drawDisc(6, 1)
end

function drawTower(towerNum)
    love.graphics.rectangle("fill", 100 + (towerNum-1)*200,500,150,20)
    love.graphics.rectangle("fill", 170 + (towerNum-1)*200,100,10,400)
end

function drawDisc(size, tower)
  table.insert(towers[tower], size)
  discWidth = size * 10 + 40
  discHeight = size*3 + 10
  centerOfTower = (tower-1)*200 + 175
  heightOffset = 500 - 1
  for _, discSize in ipairs(towers[tower]) do
    heightOffset = heightOffset - discSize *3 + 10
  end
  
  love.graphics.rectangle("fill", centerOfTower - ( discWidth / 2), heightOffset, discWidth, discHeight)
end
