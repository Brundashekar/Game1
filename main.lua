-----------------------------------------------------------------------------------------
--
-- main.lua
-- By Brunda
-----------------------------------------------------------------------------------------

-- Hide Status Bar, display object is a corona object makes globally available.
display.setStatusBar(display.HiddenStatusBar)

-- Anchors
display.setDefault('anchorX', 0)
display.setDefault('anchorY', 0)

-- Physics
local physics = require('physics')


-- [Background]
local background= display.newImageRect("background.png",360,570)

--local variables
local lobster
local crab 
local worms = display.newGroup()
local leftbtn
local rightbtn
local upbtn
local downbtn
local scoreTF
local alertView

--Sounds
local eat = audio.loadSound('eating.wav')
local wrong = audio.loadSound('lose.wav')

-- Functions
local Main = {}
local createWorms = {}
local leftbtn= {}
local rightbtn= {}
local upbtn= {}
local downbtn= {}
local loadbtn = {}
local onCollision ={}
local moveUp ={}
local moveDown ={}
local moveRight ={}
local moveLeft ={}
local moveWorms={}
local alert={}

--function onCollision, when lobster collides with worms 
function onCollision(self, event)
	local name1 = event.other.name:sub(1,1)
	local name2 = event.other.name
	local target = event.other
	if (name1 == 'w') then
		display.remove(event.other)
			-- Total Score
			scoreTF.text = tostring(tonumber(scoreTF.text) + 10)
			scoreTF.x = 15
			audio.play(eat)
-- when lobster collides with crab 
	else if(name2 == "crab") then
	alertView =display.newImage('gameOver.png', 155, 125)
	audio.play(wrong)
	display.remove(lobster)
	end
	end
end
--
function Main()
	print( 'Starting physics')--the first object in the collision
	physics.start()
	lobster = display.newImageRect("lobster.png",100,100)
	lobster.name = 'lobster'
	lobster.x = display.contentCenterX
	lobster.y = display.contentHeight-50
	physics.addBody(lobster)
	lobster.bodyType='dynamic'
	lobster.isSensor = true
	lobster.collision = onCollision
	lobster:addEventListener( 'collision')
	crab= display.newImageRect("crab.png",100,100)
	crab.name = 'crab'
	crab.x = display.contentUp
	crab.y = display.contentHeight-250
	physics.addBody(crab)
	crab.bodyType='dynamic'
	crab.isSensor = true	
	crab.collision = onCollision
     createWorms()
	loadbtn()
	physics.setGravity(0,0)
	physics.setPositionIterations(6)
	timer.performWithDelay( 500,moveWorms,-1)
-- TextFields
	scoreTF = display.newText('0', 25, 18, 'Courier', 15)
	scoreTF:setTextColor(0, 175, 29)
end

--function to load all the buttons:left,right,up,down. 
function loadbtn()
	leftbtn = display.newImageRect("leftbtn.png",20,20)
	rightbtn = display.newImageRect("rightbtn.png",20,20)
	upbtn = display.newImageRect("upbtn.png",20,20)
	downbtn = display.newImageRect("downbtn.png",20,20)
	leftbtn:addEventListener( "touch", moveLeft )
	rightbtn:addEventListener( "touch", moveRight )
	upbtn:addEventListener( "touch", moveUp )
	downbtn:addEventListener( "touch", moveDown )
	local xc = 0
	local yc = display.contentHeight
	leftbtn.x =0
	leftbtn.y = yc-20
	downbtn.x = xc+20
	downbtn.y = yc-20
	rightbtn.x = xc+40
	rightbtn.y = yc-20
	upbtn.x = xc+20
	upbtn.y = yc-40
end

--function CreateWorms will randomly create 5 worms on the screen.
function createWorms()
	for i = 1, 5 do
	local w
	--local mrandom = math.random
		local wx = math.floor(math.random() * display.contentWidth)
		local wy = math.floor(math.random() * display.contentHeight)
		w = display.newImage('worm.png', wx, wy)	
		w.name = 'w' .. tostring(i)
		physics.addBody(w)
		w.bodyType='dynamic'
		w.isSensor = false
		worms:insert(w)
	end
end

function moveWorms()
    -- For each worm in worms
    -- select a random number between 1 and 4 (inclusive)
    -- move 1 step in one of 4 directions based on random number selected
	for i=1, worms.numChildren	do
		w = worms[i]
		local rnd = math.floor(math.random() * 4)+1
		local newx = 0
		local newy = 0
		--left
		if (rnd == 1) then
newx = w.x - 20
			newy = w.y
			--right
		elseif(rnd == 2)then
newx = w.x + 20
			newy = w.y
			--up
		elseif(rnd == 3)then
newx = w.x
newy = w.y - 20
			--down
		elseif(rnd == 4)then
newx = w.x
newy = w.y + 20
		end
			if newx >= display.contentWidth-20 then
				newx = display.contentWidth-20
			elseif newx <= 0 then
				newx = 0
			end
			if newy >= display.contentHeight-20 then
				newy = display.contentHeight-20
			elseif newy <= 0 then
				newy = 0
			end
           transition.to(w,{x = newx,y = newy,time =10})
	end
end
		--function to move the lobster up 
		function moveUp(event)
		local newx = 0
		local newy = 0
			newx = lobster.x
		newy = lobster.y - 20
		if newx >= display.contentWidth-20 then
				newx = display.contentWidth
			elseif newx <= 0 then
				newx = 0
			end
			if newy >= display.contentHeight-20 then
				newy = display.contentHeight
			elseif newy <= 0 then
				newy = 0
			end
   		transition.to(lobster,{x = newx,y = newy,time =10})
		end

		--function to move the lobster down 
		function moveDown(event)
		newx = lobster.x
		newy = lobster.y + 20
		if newx >= display.contentWidth-100 then
				newx = display.contentWidth-100
			elseif newx <= 0 then
				newx = 0
			end
			if newy >= display.contentHeight-20 then
				newy = display.contentHeight
			elseif newy <= 0 then
				newy = 0
			end
   			transition.to(lobster,{x = newx,y = newy,time =10})
		end

		--function to move the lobster left 
		function moveLeft(event)
			newx = lobster.x 
			newy = lobster.y
			if newx >= display.contentWidth-100 then
				newx = display.contentWidth-100
			elseif newx <= 0 then
				newx = 0
			end
			if newy >= display.contentHeight-100 then
				newy = display.contentHeight-100
			elseif newy <= 0 then
				newy = 0
			end
   			transition.to(lobster,{x = newx,y = newy,time =10})
		end

		--function to move the lobster right.
		function moveRight(event)
			newx = lobster.x + 20
			newy = lobster.y
			if newx >= display.contentWidth-100 then
				newx = display.contentWidth-100
			elseif newx <= 0 then
				newx = 0
			end
			if newy >= display.contentHeight-100 then
				newy = display.contentHeight-100
			elseif newy <= 0 then
				newy = 0
			end
   			transition.to(lobster,{x = newx,y = newy,time =10})
		end
		
		function alert(action)
		if(action == 'lose') then
		alertView = display.newImage('gameOver.png', 155, 125)
		end
	transition.from(alertView, {time = 300, xScale = 0.5, yScale = 0.5})
		end
Runtime:removeEventListener( "touch", diceFunction2 )
 
--Runtime:addEventListener( "system", onSystemEvent )
Main()