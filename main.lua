function love.load()
  
end

function love.update(dt)
  
end

function love.draw()
  drawTower(1)
  drawTower(2)
  drawTower(3)
  
  drawDisc(8, 2)
  drawDisc(7, 1)
end

function drawTower(towerNum)
    love.graphics.rectangle("fill", 100 + (towerNum-1)*200,500,150,20)
    love.graphics.rectangle("fill", 170 + (towerNum-1)*200,100,10,400)
end

function drawDisc(size, tower)
  love.graphics.rectangle("fill", ((tower-1)*200) + 175 - ((size * 10 + 40) / 2), 500 - (size*3 + 10) - 1, size * 10 + 40, size*3 + 10)
end
