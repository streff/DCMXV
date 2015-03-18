-- De Chelonian Mobile -- Client Install
-- 2013 Iain Strefford 

-- function declarations
function gohome()
pcall(travelheight)
file = fs.open("home", "r")
local xhome = textutils.unserialize(file.readAll())
file:close()
print("going home: ", textutils.serialize(xhome))
sndmsg("going home", "I")
goto(xhome[1], xhome[2], xhome[3], xhome[4])
sndmsg("At Home", "I")
end

function movefail() --not called
fails = fails + 1
	if fails > 3 then
		fails = 0
		pcall(gohome)
	end
end


function moveto(coords)
goto(coords[1], coords[2], coords[3], coords[4])
end

function goto(tarx,tary,tarz,tarh)
--print("called goto")
  if(cpos[2] > tary) then
    movetox(tarx)
	movetoy(tary)
	movetoz(tarz)
  else
    movetoy(tary)
	movetox(tarx)
	movetoz(tarz)
  end
  turnto(tarh)
end

function movetoz(tarz)
--print("called movetoz")
  while(cpos[3] ~= tarz) do
    if cpos[3] < tarz then
		moveup()
    else
		movedown()
	end
  end
end

function movetox(tarx)
--print("called movetox")
  while(cpos[1] ~= tarx) do
  --print("cpos[1] ~= tarx")
    if cpos[1] < tarx then
	 --print(" turnto(3)")
      turnto(3)
    else
	 --print(" turnto(1)")
      turnto(1)
    end
	--print(" moveforward()")
  moveforward()
  end
end

function movetoy(tary)
  while(cpos[2] ~= tary) do
		if cpos[2] < tary then
			turnto(0)
		else
			turnto(2)
		end
		moveforward()
    end
end

function turnto(direction)
  while cpos[4] ~= direction do
    diff = cpos[4] - direction
    if ((diff == 1) or (diff == -3)) then
      turnleft()
    else
      turnright()
    end
  end
end

function moveforward()
  if turtle.forward() then
    if     (cpos[4] == 0) then modposition(2,1)
    elseif (cpos[4] == 1) then modposition(1,-1)
    elseif (cpos[4] == 2) then modposition(2,-1)
    elseif (cpos[4] == 3) then modposition(1,1)
    end
    return true
  else
    return false
  end
end

function moveback()
  if turtle.back() then
    if     (cpos[4] == 0) then modposition(2,-1)
    elseif (cpos[4] == 1) then modposition(1,1)
    elseif (cpos[4] == 2) then modposition(2,1)
    elseif (cpos[4] == 3) then modposition(1,-1)
    end
    return true
  else
    return false
  end
end

function moveup()
  if turtle.up() then
    modposition(3,1)
    return true
  else
    return false
  end
end

function movedown()
  if turtle.down() then
    modposition(3,-1)
    return true
  else
    return false
  end
end

function turnright()
  modposition(4,1)
  turtle.turnRight()
end

function turnleft()
  modposition(4,-1)
  turtle.turnLeft()
end

function modposition(axis, value)
  if (axis == 4) then
    cpos[axis] = ((cpos[axis] + value) % 4)
  else
    cpos[axis] = (cpos[axis] + value)
  end

--blip = blip + 1
--if blip == 4 then 
--blip = 0
sndmsg(cpos, "x") 				-- position spam
--end
pcall(reportfuel)
end

function sethome(coords)
file = fs.open("home", "w")
file.write(textutils.serialize(coords))
file:close()
sndmsg("Home Set", "I")
end

function reportparam()
file = fs.open("home", "r")
local xhome = textutils.unserialize(file.readAll())
file:close()
sndmsg(xhome, "H")
sndmsg(theight, "T")
sndmsg(esize, "E")
sndmsg(repeats, "Rx")
sndmsg(offset, "off")
end

function gotosite()
pcall(travelheight)
sndmsg("Going to site..", "I")
file = fs.open("site", "r")
local xsite = textutils.unserialize(file.readAll())
xsite[1] = xsite[1] + offset
file:close()
goto(xsite[1], xsite[2], xsite[3], xsite[4])
sndmsg("At Site", "I")
end

function engage()
for n = 1, repeats do
tellpos()
getfuel()
sndmsg("Going to Site", "I")
gotosite()
getpos()
sndmsg("Excavating", "I")
shell.run("excavate2", esize, monitor)
sndmsg("Done Excavating", "I")
tellpos()
gohome()
unload()
getfuel()
end
end

function shaft()
tellpos()
getfuel()
sndmsg("Going to Site", "I")
gotosite()
tellpos()
sndmsg("Dropping Shaft", "I")
shell.run("excavate2", "2", monitor)
tellpos()
gohome()
lowersite()
unload()
getfuel()
sndmsg("Done Shafting.. snigger..", "I")
end

function punch()
while cpos[3] < theight do
	if turtle.up() then
	modposition(3,1)
	else
	turtle.digUp()
	sleep( 0.5 )
	end
end
end

function unload()
turtle.select(1)
for n =1,16 do
		turtle.select(n)
		local dropped = turtle.dropDown()
		print(dropped)
end
end

function getfuel()
while (turtle.getFuelLevel() < 4000) do
	turnright()
	turtle.suck()
	turnleft()
		for p =1,16 do
			turtle.select(1)
			turtle.refuel()
		end
end

end

function fgetfuel()  -- forced fuel collection from menu
sndmsg("getting fuel", "I")
turnright()
turtle.select(1)
turtle.suck()
turnleft()
	for p =1,16 do
		turtle.select(1)
				turtle.refuel()
	end
sndmsg("got fuel", "I")
end

function sndmsg(smsg, class)
print("send message: ", smsg, " to ID ", monitor)
local tArgs = {id, monitor, smsg, class}
rednet.send(relay, textutils.serialize(tArgs))
end

function getmsg()    -- get message function
local me = os.getComputerID()
local forme = false
while forme == false do
print("listening")
local xid, xmsg = rednet.receive()
print("got message")
local xsub = string.sub(xmsg,1,1)
	if xsub == "{" then
fmsg = textutils.unserialize(xmsg)
print(fmsg)
	ysrc = tonumber(fmsg[1])
	yid = tonumber(fmsg[2])
	ymsg = fmsg[3]
	yclass = fmsg[4]
		if tonumber(yid) == tonumber(me) then
		print("its for me")
		forme = true
		elseif tonumber(yid) == -1 then
		print("its for all")
		forme = true
		else 
		print("not for me")
		end 
	end
end
return ysrc, ymsg, yclass
end

function reportfuel()
local tfuel = turtle.getFuelLevel()
sndmsg(tfuel, "R")
end

function tellpos()
--local var
local cx, cy, cz, ch = getpos()  --grab location/heading
--global var
pos = {cx,cy,cz,ch}
--local cpos = textutils.serialize( pos )
sndmsg(pos, "C")
end


function getpos()
print("getting position")
local ch -- sets a var for the direction the turtle is facing
local cx,cy,cz = gps.locate(10) -- gets the turtles position
turtle.forward() -- moves the turtle forward 1 space
local fx,fy,fz = gps.locate(10) -- gets the turtles position
turtle.back() -- moves the turtle back to its original position
if fx > cx then --if final X is Greater than original X  turtle is facing East
ch = 3 --East
elseif fx < cx then --if final X is Less than original X  turtle is facing West
ch = 1 --West
elseif fy > cy then --if final Y is Greater than original Y  turtle is facing South
ch = 0 --South
elseif fy < cy then --if final Y is Less than original Y  turtle is facing North
ch = 2 --North
end
cpos = {cx, cy, cz, ch}
print(textutils.serialize( cpos ))
return cx , cy , cz , ch -- returns position and heading info
end

function setsite(src,msg,coords)
file = fs.open("site", "w")
file.write(textutils.serialize(coords))
file:close()
sndmsg("Site set", "I")
reportsite()
end

function lowersite()
file = fs.open("site", "r")
local xsite = textutils.unserialize(file.readAll())
file:close()
xsite[3] = 25
file = fs.open("site", "w")
file.write(textutils.serialize(xsite))
file:close()
local xconf = reportsite()
end

function reportsite()
file = fs.open("site", "r")
local xsite = textutils.unserialize(file.readAll())
file:close()
sndmsg(xsite, "S")
end

function treboot()
sndmsg("rebooting", "I")
os.reboot()
end

function travelheight()
sndmsg("to t-height","I")
movetoz(theight)
end

function setesize()
esize = class
writesettings()
sndmsg("E-Size Set", "I")
end

function setheight(src, message, class)
theight = tonumber(class)
writesettings()
sndmsg("T-Height Set", "I")
end

function setrepeats(src, message, class)
repeats = tonumber(class)
writesettings()
sndmsg("Repeats Set", "I")
end

function setoffset(src, message, class)
offset = class
writesettings()
sndmsg("Offset Set", "I")
end

function setrelay(src, message, class)
relay = class
writesettings()
sndmsg("Relay Set", "I")
end

function setmonitor(src, message, class)
monitor = class
writesettings()
sndmsg("Relay Set", "I")
end

function homehere()
file = fs.open("home", "w")
file.write(textutils.serialize(cpos))
file:close()
sndmsg("Home Set", "I")
end

function writesettings()
local xsettings = {esize, theight, repeats, offset, relay, monitor}
file = fs.open("settings", "w")
file.write(textutils.serialize(xsettings))
file:close()
end

function init()
sndmsg("Initialising...", "I")
reportparam()
reportsite()
reportfuel()
tellpos()
os.sleep(1)
sndmsg("Init Ok.", "I")

end







-- MAIN FUNCTION START
-- code execute start
--open modem & init source
rednet.open("right")
id = tonumber(os.getComputerID())
file = fs.open("settings", "r")
local xsettings = textutils.unserialize(file.readAll())
file:close()
esize = tonumber(xsettings[1])
theight = tonumber(xsettings[2])
repeats = tonumber(xsettings[3])
offset = tonumber(xsettings[4])
relay = tonumber(xsettings[5])
monitor = tonumber(xsettings[6])
blip = 0   										-- position spam blip

while true do
print("Now Listening for instruction")
source, message, class = getmsg()
	if message == "tellpos" then
	pcall(tellpos)
	elseif message == "sethome" then
	sethome(class)
	elseif message == "init" then
	pcall(init)
	elseif message == "gohome" then
	pcall(gohome)
	elseif message == "reportparam" then
	pcall(reportparam)
	elseif message == "setsite" then
	setsite(source,message,class)
	elseif message == "reportsite" then
	pcall(reportsite)
	elseif message == "reportfuel" then
	pcall(reportfuel)
	elseif message == "gotosite" then
	pcall(gotosite)
	elseif message == "moveto" then
	moveto(class)
	elseif message == "engage" then
	pcall(engage)
	elseif message == "refuel" then
	pcall(fgetfuel)
	elseif message == "reboot" then
	pcall(treboot)
	elseif message == "unload" then
	pcall(unload)
	elseif(message) == "shaft" then
	pcall(shaft)
	elseif(message) == "esize" then
	setesize(source,message,class)
	elseif(message) == "setheight" then
	setheight(source,message,class)
	elseif message == "repeats" then
	setrepeats(source,message,class)
	elseif message == "homehere" then
	pcall(homehere)
	elseif message == "setoffset" then
	setoffset(source,message,class)
	elseif message == "punch" then
	pcall(punch)
	elseif message == "relay" then
	setrelay(source,message,class)
	elseif message == "monitor" then
	setmonitor(source,message,class)
	else
	end
end