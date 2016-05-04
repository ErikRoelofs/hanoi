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
  if towerNum == 1 then
    love.graphics.rectangle("fill", 100,500,150,20)
    love.graphics.rectangle("fill", 170,100,10,400)
  end
  
  if towerNum == 2 then
    love.graphics.rectangle("fill", 300,500,150,20)
    love.graphics.rectangle("fill", 370,100,10,400)
  end
  
  if towerNum == 3 then
    love.graphics.rectangle("fill", 500,500,150,20)
    love.graphics.rectangle("fill", 570,100,10,400)
  end
end