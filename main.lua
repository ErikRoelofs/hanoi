function love.load()
  
end

function love.update(dt)
  
end

function love.draw()
  drawTower(1)
  drawTower(2)
  drawTower(3)
end

function drawTower(towerNum)
    love.graphics.rectangle("fill", 100 + (towerNum-1)*200,500,150,20)
    love.graphics.rectangle("fill", 170+ (towerNum-1)*200,100,10,400)
end