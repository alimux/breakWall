-- display debug log in the console
io.stdout:setvbuf('no')

-- to prevent filtering.padSprites
love.graphics.setDefaultFilter("nearest")

-- to activate step by step debug in Zerobrane
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- var
local appsTitle = "GameCodeur -- BreakWalls Alex -- v. 0.0.1"

local Pad = {}
Pad.posX = 0
Pad.posY = 0
Pad.padSprite = nil

local Ball = {}
Ball.posX = 0
Ball.posY = 0
Ball.radius = 5
Ball.isOnThePad = false
Ball.velX = 0
Ball.velY = 0


function initialization()

-- init window et debug log
width = 1024
height = 768
minWidth = 0
love.window.setMode(width, height)
love.window.setTitle(appsTitle)

--init pad and pad's position
Pad.padSprite = love.graphics.newImage("Resources/Sprites/Pad.png")
deltaY = 50
deltaX = Pad.padSprite:getWidth() / 2
Pad.posX = (width /2) - Pad.padSprite:getWidth() / 2
Pad.posY = height - deltaY

--init ball and Ball postion
Ball.isOnThePad = true

end


function love.load()
  
  initialization()
  
end

function love.update( _deltaTime)
  
  Pad.posX = love.mouse.getX() - deltaX
  
  print("pos y de la balle", Ball.posY)
  
  if(Ball.isOnThePad) then
    Ball.posX = Pad.posX + deltaX
    Ball.posY = Pad.posY + Ball.radius
  else
    Ball.posX = Ball.posX + (Ball.velX * _deltaTime)
    Ball.posY = Ball.posY + (Ball.velY * _deltaTime)
  end

if Ball.posX > width then
  InvertVelocityX(false)
end

if Ball.posX < minWidth then
  InvertVelocityX(true)
end

if Ball.posY > height then  
  InvertVelocityY(true, true)
end

if Ball.posY < minWidth then
  InvertVelocityY(false, false)
end

CheckPadCollision()
  
end

function CheckPadCollision()
  print("Check Collision")
   CollisionPad = Pad.posY - Ball.radius
  print ("Collision pad", CollisionPad)
  if Ball.posY > CollisionPad then
    local distance = math.abs(Pad.posX - Ball.posX)
    if distance < deltaX then
      InvertVelocityY(true, false)
    end
  end
  
end


function InvertVelocityX(_isMin)
  Ball.velX = 0 - Ball.velX
  if _isMin then
  Ball.posX = minWidth
else
  Ball.posX = width
  end
end

function InvertVelocityY(_isMin, _arg)
  
  print ("_isMin >>", _isMin)
  print("arg >>", _arg)
  
  if _isMin and _arg then
    initialization()
  end
  
  if _isMin and _arg==false then
    Ball.velY = 0 - Ball.velY
    Ball.posY = CollisionPad
  end
  
  if _isMin==false and _arg == false then
    Ball.velY = 0 - Ball.velY
    Ball.posY = 0
  end
  
end



function love.draw() 
-- sprite drawing
love.graphics.draw(Pad.padSprite, Pad.posX, Pad.posY)
love.graphics.circle("fill", Ball.posX, Ball.posY, Ball.radius)

-- log drawing
love.graphics.print(appsTitle, 3, height - 20)
  
end

function love.mousepressed(_x, _y, _n)
  if Ball.isOnThePad then
    Ball.isOnThePad = false
    Ball.velX = 200
    Ball.velY = -200
  end
  
end
