local tArgs = { ... }
if #tArgs ~= 3 then
        print( "Usage: plant <number of trees> <monitor> <planted (boolean 1 or 0>" )
        return
end

local x = tonumber( tArgs[1] )
if x < 1 then
        print( "Plant radius must be positive" )
        return
end

local monitor = tonumber( tArgs[2] )

local planted = tonumber( tArgs[3] )


local dirt, sapling = 1, 2

local xPos,zPos = 0,0
local xDir,zDir = 0,1
local height = 0

function sndmsg(smsg, class)
print("send message: ", smsg, " to ID ", monitor)
local tArgs = {id, monitor, smsg, class}
rednet.send(monitor, textutils.serialize(tArgs))
end


local function moveforward()
if turtle.forward() then
        xPos = xPos + xDir
        zPos = zPos + zDir
	print("x "..xPos)
	print("z "..zPos)	
		end
end

local function moveback()
if turtle.back() then
        xPos = xPos - xDir
        zPos = zPos - zDir
	print("x "..xPos)
	print("z "..zPos)	
		end
end

local function turnLeft()
        turtle.turnLeft()
        xDir, zDir = -zDir, xDir
end
 
local function turnRight()
        turtle.turnRight()
        xDir, zDir = zDir, -xDir
end

local function moveup()
if turtle.up() then
height = height + 1
end
end

local function movedown()
if turtle.down() then
height = height - 1
end
end

-- get into position
-- initial planting
if planted == 0 then
sndmsg("planting row", "I")
moveup()
turnLeft()
turnLeft()
moveback()
moveback()
moveback()
moveback()
-- position is +3 0 +1

for i = 0, x do
  turtle.digDown()
  turtle.select(dirt)
  turtle.placeDown()
  moveback()
  turtle.select(sapling)
  turtle.place()
  sndmsg("placed "..i, "I")
moveback()
moveback()
moveback()
end
--return to start 0 +1 +1
turnRight()
moveforward()
turnLeft()


while zPos > 0 do
moveforward()
end

 while zDir ~= 1 do
        turnLeft()
end


else

turnLeft()
moveforward()
turnRight()
moveup() -- should now be in 0 +1 +1

end


--chop trees
for i=1,5 do
 sndmsg("waiting", "I") 
  -- sleep for 30 seconds
  os.sleep(30)
  -- check all trees for any that have grown
  for i = 0, x do
  sndmsg("checking "..i, "I") 
    moveforward()
    moveforward()
    moveforward()
	moveforward()
    turnRight()
    -- if the tree has grown
	local success, data = turtle.inspect()
    if data.name == "minecraft:log" then
	  sndmsg("harvesting "..i, "I") 
		turtle.dig()
		moveforward()
		-- harvest the tree
		
				while turtle.detectUp() do
					turtle.digUp()  
					moveup()
				end
				-- return to the ground
				while not turtle.detectDown() do
					movedown()
				end
				-- plant a new sapling
				moveback()
				turtle.select(sapling)
				turtle.place()
	end
		turnLeft()
	end
  -- back home

 
turnLeft()
turnLeft()
 
 while zPos > 0 do
moveforward()
end
 turnLeft()
turnLeft()
 
end