local lume = require 'lume'
local Vector = require 'vector'

local sin,cos,tan = math.sin, math.cos, math.tan
-- rules: always same amount of points.
-- atom dont copy nothing

function f(x)
  return -sin(x)
end

function derivative(f, x, dx)
  return (f(x+dx) - f(x))/dx
end

function integrate(f, x, dx)
  return f(x+dx) * dx
end

function joinpoints(points)
  for i = 2,#points do
    local p1 = points[i-1]
    local p2 = points[i]
    love.graphics.line(p1.x,p1.y, p2.x,p2.y)
  end
end

function generatepoints(f, from, to, pxPrUnit)
  local pts = {}
  for x = from/pxPrUnit.x,to/pxPrUnit.x,0.5/pxPrUnit.x do
    local p = Vector(x*pxPrUnit.x,f(x)*pxPrUnit.y)
    pts[#pts + 1] = p
  end
  return pts
end
function love.load()
  love.window.setMode(800, 800)
  pxPrUnit = Vector(10,10)
  movespeed = 10

  showgrid = true
  shownumbers = false
  showcoordsys = true

  pos = Vector(0,0)
  w,h = love.graphics.getDimensions()




end

function love.update(dt)
  --points = {}
  if love.keyboard.isDown("left") then
    pos.x = pos.x + movespeed
  end

  if love.keyboard.isDown("right") then
    pos.x = pos.x - movespeed
  end

  if love.keyboard.isDown("up") then
    pos.y = pos.y + movespeed
  end

  if love.keyboard.isDown("down") then
    pos.y = pos.y - movespeed
  end

  if love.keyboard.isDown("a") then
    pxPrUnit.x = pxPrUnit.x * 1.05
  end

  if pxPrUnit.x > 0.1 then
    if love.keyboard.isDown("d") then
      pxPrUnit.x = pxPrUnit.x / 1.05
    end
  end

  if love.keyboard.isDown("w") then
    pxPrUnit.y = pxPrUnit.y * 1.05
  end

  if pxPrUnit.y > 0.1 then
    if love.keyboard.isDown("s") then
      pxPrUnit.y = pxPrUnit.y / 1.05
    end
  end

  points = generatepoints(f, -w/2 - pos.x, w/2 - pos.x, pxPrUnit)

  d = generatepoints(cos, -w/2 - pos.x, w/2 - pos.x, pxPrUnit)
end

function love.draw()
  -- draw the coodinate sys
  love.graphics.translate(w/2+pos.x,h/2+pos.y)
  love.graphics.setColor(255, 255, 255)

  if showcoordsys then
    love.graphics.line(-w/2 - pos.x, 0, w/2 - pos.x, 0)
    love.graphics.line(0, -h/2 - pos.y, 0, h/2 - pos.y)
  end

  if showgrid then
    love.graphics.setColor(200, 200, 200)
    for x = -w/2-pos.x,w/2-pos.x,pxPrUnit.x do
      love.graphics.line(x+pos.x, -h/2 - pos.y, x+pos.x, h/2 - pos.y)
    end
  end

  love.graphics.setColor(255,0,0)
  joinpoints(d)

  love.graphics.setColor(0,0,255)
  joinpoints(points)
end
