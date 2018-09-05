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
Pad.width = nil
Pad.height = nil

local Ball = {}
Ball.posX = 0
Ball.posY = 0
Ball.radius = 5
Ball.isOnThePad = false
Ball.velX = 0
Ball.velY = 0

local Brick = {}

local level = {}


function initialization()

-- init window et debug log
width = 800
height = 600
minWidth = 0
love.window.setMode(width, height)
love.window.setTitle(appsTitle)

--init pad and pad's position
Pad.padSprite = love.graphics.newImage("Resources/Sprites/Pad.png")
Pad.width = Pad.padSprite:getWidth()
print("largeur pad" ,Pad.width)
Pad.height = Pad.padSprite:getHeight()
deltaY = 30
delta10 = 10
deltaX = Pad.width / 2
Pad.posX = (width /2) + deltaX
print("position X", Pad.posX)
Pad.posY = height - Pad.height  - deltaY

-- level
level = {}
local row, column

for row = 1, 6 do
  level[row] = {}
  for column = 1, 15 do
    level[row][column] = 1
  end
  
end


--init ball and Ball postion
Ball.isOnThePad = true

end


function love.load()
  
  initialization()
  initBrick()
  
end

function initBrick()
  
  Brick.height = 25
  Brick.width = width / 15
  
end


function love.update( _deltaTime)
  
  Pad.posX = love.mouse.getX() - deltaX
  
  if(Ball.isOnThePad) then
    Ball.posX = Pad.posX + deltaX
    Ball.posY = Pad.posY + Ball.radius
  else
    Ball.posX = Ball.posX + (Ball.velX * _deltaTime)
    Ball.posY = Ball.posY + (Ball.velY * _deltaTime)
  end
  
  local CurrentColumn = math.floor(Ball.posX / Brick.width) + 1 -- +1 cause lua first index not 0
  local CurrentRow = math.floor(Ball.posY / Brick.height) + 1
  
  if CurrentRow >=1 and CurrentRow <= #level and CurrentColumn >=1 and CurrentColumn <= 15 then
    
  if level[CurrentRow][CurrentColumn] == 1 then
    RemoveBrick(CurrentRow, CurrentColumn)
  end
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

function RemoveBrick(_row, _column)
  Ball.velY = 0 - Ball.velY
  level[_row][_column] = 0
end


function CheckPadCollision()
  
   CollisionPad = (Pad.posY + delta10) - Ball.radius

  if Ball.posY > CollisionPad then
    local distance = math.abs((Pad.posX + deltaX) - Ball.posX)
    print ("distance >>" , distance)
    print ("delta de X >>", deltaX)
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
    print("lose")
    initialization()
  end
  
  if _isMin and _arg==false then
    print("collision avec la pad")
    Ball.velY = 0 - Ball.velY
    Ball.posY = CollisionPad
  end
  
  if _isMin==false and _arg == false then
    print("collision avec la plafond")
    Ball.velY = 0 - Ball.velY
    Ball.posY = 0
  end
  
end



function love.draw() 
-- brick drawing
local row, column
local brickX, brickY = 0, 0

for row = 1, 6 do
  brickX = 0
  for column = 1, 15 do
    if level[row][column] == 1 then
      -- draw
      love.graphics.rectangle("fill", brickX + 1, brickY + 1, Brick.width - 2 , Brick.height - 2)
    end
    brickX = brickX + Brick.width
  end
  brickY = brickY + Brick.height
end
-- sprite drawing
love.graphics.draw(Pad.padSprite, Pad.posX, Pad.posY)
love.graphics.circle("fill", Ball.posX, Ball.posY, Ball.radius)
love.graphics.circle("fill",Pad.posX, Pad.posY +30, 1)

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
