-- DCMMon v2.2
-- declare !all! the vars \o/

screens = {0,0}



function populate()
mroster = {}
jroster = {}
for i = 1, #roster[1] do
print(roster[1][i])
	mroster[i] ={}
	mroster[i].tid = roster[1][i]
	mroster[i].collected = "0"
	mroster[i].fuel = "0"
	mroster[i].depth = "0"
	mroster[i].inst = "pre init"
 
	mroster[i].cposx = "0"
	mroster[i].cposy = "0"
	mroster[i].cposz = "0"
	mroster[i].cposh = "0"
 
	mroster[i].sposx = "0"
	mroster[i].sposy = "0"
	mroster[i].sposz = "0"
	mroster[i].sposh = "0"
 
	mroster[i].hposx = "0"
	mroster[i].hposy = "0"
	mroster[i].hposz = "0"
	mroster[i].hposh = "0"
	mroster[i].exc = "0"
	mroster[i].theight = "0"
	mroster[i].repeats = "0"
	mroster[i].offset = "0"
end

for i = 1, #roster[2] do
	jroster[i] = {}
	jroster[i].tid = roster[2][i]
	jroster[i].collected = "0"
	jroster[i].fuel = "0"
	jroster[i].depth = "0"
	jroster[i].inst = "pre init"
 
	jroster[i].cposx = "0"
	jroster[i].cposy = "0"
	jroster[i].cposz = "0"
	jroster[i].cposh = "0"
 
	jroster[i].sposx = "0"
	jroster[i].sposy = "0"
	jroster[i].sposz = "0"
	jroster[i].sposh = "0"
 
	jroster[i].hposx = "0"
	jroster[i].hposy = "0"
	jroster[i].hposz = "0"
	jroster[i].hposh = "0"
	jroster[i].exc = "0"
	jroster[i].theight = "0"
	jroster[i].repeats = "0"
	jroster[i].offset = "0"
end
	
	sroster = {mroster, jroster}

end

	
	-- declare all the functions

    function readsession()
    if fs.exists("sessiondetail") then
	file = fs.open("sessiondetail", "r")
    local xsession = textutils.unserialize(file.readAll())
    file:close()
    relay = xsession[1]
	roster = xsession[2]
	else
	relay = 0
	roster = {{0},{0}}
	writesession()
	end
	
    end

	function writesession()
    local xsession = {trelay, roster}
    file = fs.open("sessiondetail", "w")
    file.write(textutils.serialize(xsession))
    file:close()
    end
 
local function open()
        local bOpen, sFreeSide = false, nil
        for n,sSide in pairs(rs.getSides()) do 
                if peripheral.getType( sSide ) == "modem" then
                        sFreeSide = sSide
                        if rednet.isOpen( sSide ) then
                                bOpen = true
                                break
                        end
                end
        end
       
        if not bOpen then
                if sFreeSide then
                        print( "No modem active. Opening "..sFreeSide.." modem" )
                        rednet.open( sFreeSide )
                        return true
                else
                        print( "No modem attached" )
                        return false
                end
        end
        return true
end
 
function getmsg()
print("getmsg")
local forme = false
while forme == false do
local xid, xmsg = rednet.receive()
        print(xmsg)
local xsub = string.sub(xmsg,1,1)
        if xsub == "{" then
                fmsg = textutils.unserialize(xmsg)
                ysrc = fmsg[1]
                yid = fmsg[2]
                ymsg = fmsg[3]
                yclass = fmsg[4]
                        if tonumber(yid) == mynumber then
                                forme = true
                                else
                        end
        end
end
return ysrc, ymsg, yclass
end
 
function drawblank(z)
	
    placeCursor(z, 4,5)
    mon.write("Monitor ")
    placeCursor(z, 13,5)
    mon.write(mynumber)
    placeCursor(z, 4,6)
    mon.write("waiting")

end

function placeCursor(ps, px, py)
print(ps)
if ps == 1 then 
	cx = px
	cy = py
	print(cx)
	print(cy)
elseif ps == 2 then
	cx = tonumber(px + 27)
	cy = tonumber(py)
	print(cx)
	print(cy)
end
mon.setCursorPos(cx,cy)
end

 
function updatescreen()
print("updatescreen")
mon.clear()
	for z = 1, #screens do
	print(z)
		if screens[z] ~= 0 then

			for i,k in pairs(roster) do
				for _,v in pairs(k) do
					if v == screens[z] then

placeCursor(z, 2, 2)
mon.write("Turtle")
placeCursor(z, 10,2)
mon.write(sroster[i][_].tid)
placeCursor(z, 14,2)
mon.write("Fuel")
placeCursor(z, 19,2)
mon.write(sroster[i][_].fuel)
placeCursor(z, 2,4)
mon.write("Location")     --location
placeCursor(z, 2,5)
mon.write("X:")
placeCursor(z, 4,5)
mon.write(sroster[i][_].cposx)
placeCursor(z, 8,5)
mon.write("Y:")
placeCursor(z, 10,5)
mon.write(sroster[i][_].cposy)
placeCursor(z, 14,5)
mon.write("Z:")
placeCursor(z, 16,5)
mon.write(sroster[i][_].cposz)
placeCursor(z, 21,5)
mon.write("H:")
placeCursor(z, 23,5)
mon.write(sroster[i][_].cposh)
placeCursor(z, 2,7)
mon.write("Home") --    HOME
placeCursor(z, 2,8)
mon.write("X:")
placeCursor(z, 4,8)
mon.write(sroster[i][_].hposx)
placeCursor(z, 8,8)
mon.write("Y:")
placeCursor(z, 10,8)
mon.write(sroster[i][_].hposy)
placeCursor(z, 14,8)
mon.write("Z:")
placeCursor(z, 16,8)
mon.write(sroster[i][_].hposz)
placeCursor(z, 21,8)
mon.write("H:")
placeCursor(z, 23,8)
mon.write(sroster[i][_].hposh)
placeCursor(z, 2,10)
mon.write("Site")    -- SITE
placeCursor(z, 2,11)
mon.write("X:")
placeCursor(z, 4,11)
mon.write(sroster[i][_].sposx)
placeCursor(z, 8,11)
mon.write("Y:")
placeCursor(z, 10,11)
mon.write(sroster[i][_].sposy)
placeCursor(z, 14,11)
mon.write("Z:")
placeCursor(z, 16,11)
mon.write(sroster[i][_].sposz)
placeCursor(z, 21,11)
mon.write("H:")
placeCursor(z, 23,11)
mon.write(sroster[i][_].sposh)
placeCursor(z, 2,13)   --DUG
mon.write("Dug:")
placeCursor(z, 6,13)
mon.write(sroster[i][_].collected)
placeCursor(z, 11, 13)
mon.write("Last Depth:")
placeCursor(z, 22, 13)
mon.write(sroster[i][_].depth)
placeCursor(z, 2, 16)
mon.write("Status:")
placeCursor(z, 9, 16)
mon.write(sroster[i][_].inst)
placeCursor(z, 2, 18)
mon.write("e:")
placeCursor(z, 4, 18)
mon.write(sroster[i][_].exc)
placeCursor(z, 8, 18)
mon.write("t:")
placeCursor(z, 10, 18)
mon.write(sroster[i][_].theight)
placeCursor(z, 15, 18)
mon.write("r:")
placeCursor(z, 17, 18)
mon.write(sroster[i][_].repeats)
placeCursor(z, 21, 18)
mon.write("o:")
placeCursor(z, 23, 18)
mon.write(sroster[i][_].offset)

				end
			end
		end
else
drawblank(z)
end
end
end
 
function monturtle()
print("monturtle")

while true do

    src, msg, class = getmsg()
	
	if class == "Minit" then
			print("got minit")
			print(msg)
			relay = msg[1]
			print("relay "..relay)
			roster = msg[2]
			print("got roster")
			writesession()
			populate()
	elseif class == "MOX" then
        break
    elseif class == "MON" then
        local screen = tonumber(textutils.serialize(msg[1]))
		local mturtle = tonumber(textutils.serialize(msg[2]))
		screens[screen] = mturtle
		print("screens")
		print(screen)
		print(mturtle)
		print(screens[1])
		updatescreen()
		os.sleep(1)

	else

	
		for i,k in pairs(roster) do
			
			for _,v in pairs(k) do
			
				if v == src then
					
					if class == "R" then
						sroster[i][_].fuel = msg						
					elseif class == "C" then
						sroster[i][_].cposx = textutils.serialize(msg[1])
						sroster[i][_].cposy = textutils.serialize(msg[2])
						sroster[i][_].cposz = textutils.serialize(msg[3])
						sroster[i][_].cposh = textutils.serialize(msg[4])
					elseif class == "x" then
						sroster[i][_].cposx = textutils.serialize(msg[1])
						sroster[i][_].cposy = textutils.serialize(msg[2])
						sroster[i][_].cposz = textutils.serialize(msg[3])
						sroster[i][_].cposh = textutils.serialize(msg[4])
					elseif class == "H" then
						sroster[i][_].hposx = textutils.serialize(msg[1])
						sroster[i][_].hposy = textutils.serialize(msg[2])
						sroster[i][_].hposz = textutils.serialize(msg[3])
						sroster[i][_].hposh = textutils.serialize(msg[4])
					elseif class == "S" then
						sroster[i][_].sposx = textutils.serialize(msg[1])
						sroster[i][_].sposy = textutils.serialize(msg[2])
						sroster[i][_].sposz = textutils.serialize(msg[3])
						sroster[i][_].sposh = textutils.serialize(msg[4])
					elseif class == "I" then
						sroster[i][_].inst = msg
					elseif class == "D" then
						sroster[i][_].depth = msg
					elseif class == "m" then
						sroster[i][_].collected = msg
					elseif class == "E" then
						sroster[i][_].exc = msg
					elseif class == "T" then
						sroster[i][_].theight = msg
					elseif class == "Rx" then
						sroster[i][_].repeats = msg
					elseif class == "off" then
						sroster[i][_].offset = tonumber(msg)
					end
	
					updatescreen()
	
				end
			end
		end
	
	end
end
end
 
-- code execute start
 
mynumber = os.getComputerID()
mon = peripheral.wrap( "top" )
readsession()
populate()
open()
updatescreen()
monturtle()