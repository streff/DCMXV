local tArgs = { ... }
if #tArgs ~= 2 then
        print( "Usage: plant <radius> <monitor>" )
        return
end

source = tonumber(os.getComputerID())

local size = tonumber( tArgs[1] )
if size < 1 then
        print( "Plant radius must be positive" )
        return
end

local placed = 0
local planted = 0


local xPos,zPos = 0,0
local xDir,zDir = 0,1
local depth = 0

function sndmsg(smsg, class)
local monitor = tonumber( tArgs[2] )
source = tonumber(os.getComputerID())
local tArgs = {source, monitor, smsg, class}
rednet.broadcast(textutils.serialize(tArgs))
end

local function stage()

for i = 1, 4 do
turtle.forward()
end

end



local function advance()
moveforward()
		selectDirt()
		turtle.placeDown()

	end
	

	
	
end

local function moveforward()
if turtle.forward() then
        xPos = xPos + xDir
        zPos = zPos + zDir
		
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

function selectDirt()
if turtle.getItemCount(1) == 0 then
        if turtle.getItemCount(2) == 0 then
                if turtle.getItemCount(3) == 0 then
                        if turtle.getItemCount(4) == 0 then
                                sndmsg("out of Dirt", "I")
								return false
                                break
                        else
                                turtle.select(4)
                        end
                else
                        turtle.select(3)
                end
        else
                turtle.select(2)
        end
else
        turtle.select(1)
end
end


local alternate = 0
local done = false
while not done do
        for n=1,size do
                for m=1,size-1 do
                        if not advance() then
                                done = true
                                break
                        end
                end
                if done then
                        break
                end
                if n<size then
                        if math.fmod(n + alternate,2) == 0 then
                                turnLeft()
                                if not advance() then
                                        done = true
                                        break
                                end
                                turnLeft()
                        else
                                turnRight()
                                if not advance() then
                                        done = true
                                        break
                                end
                                turnRight()
                        end
                end
        end
        if done then
                break
        end
       
        if size > 1 then
                if math.fmod(size,2) == 0 then
                        turnRight()
                else
                        if alternate == 0 then
                                turnLeft()
                        else
                                turnRight()
                        end
                        alternate = 1 - alternate
                end
        end
       
end

-- Return to where we started
sndmsg("Finishing Run", "I")
 
while depth < 0 do
        if turtle.up() then
                depth = depth + 1
        elseif turtle.digUp() then
                collect()
        else
                sleep( 0.5 )
        end
end
 
if xPos > 0 then
        while xDir ~= -1 do
                turnLeft()
        end
        while xPos > 0 do
                if moveforward() then
                        xPos = xPos - 1
                elseif dig() then
                        collect()
                else
                        sleep( 0.5 )
                end
        end
end
 
if zPos > 0 then
        while zDir ~= -1 do
                turnLeft()
        end
        while zPos > 0 do
                if moveforward() then
                        zPos = zPos - 1
                else
                        sleep( 0.5 )
                end
        end
end
while zDir ~= 1 do
        turnLeft()
end