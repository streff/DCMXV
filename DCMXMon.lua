local master = "0"
local collected = "0"
local fuel = "0"
local depth = "0"
local inst = "pre init"
 
local cposx = "0"
local cposy = "0"
local cposz = "0"
local cposh = "0"
 
local sposx = "0"
local sposy = "0"
local sposz = "0"
local sposh = "0"
 
local hposx = "0"
local hposy = "0"
local hposz = "0"
local hposh = "0"
local exc = "0"
local theight = "0"
local repeats = "0"
local offset = "0"
 
-- declare all the functions
 
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
 
function getturtlemsg()
print("getturtlemsg")
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
                        if tonumber(ysrc) == tonumber(master) then
                                forme = true
                                else
                                print("not for me")
                        end
        end
end
print("for me")
return ysrc, ymsg, yclass
end
 
function updatescreen()
print("updatescreen")
mon.clear()
mon.setCursorPos(2,2)
mon.write("Turtle")
mon.setCursorPos(10,2)
mon.write(textutils.serialize(master))
mon.setCursorPos(14,2)
mon.write("Fuel")
mon.setCursorPos(19,2)
mon.write(fuel)
mon.setCursorPos(2,4)
mon.write("Location")     --location
mon.setCursorPos(2,5)
mon.write("X:")
mon.setCursorPos(4,5)
mon.write(cposx)
mon.setCursorPos(8,5)
mon.write("Y:")
mon.setCursorPos(10,5)
mon.write(cposy)
mon.setCursorPos(14,5)
mon.write("Z:")
mon.setCursorPos(16,5)
mon.write(cposz)
mon.setCursorPos(21,5)
mon.write("H:")
mon.setCursorPos(23,5)
mon.write(cposh)
mon.setCursorPos(2,7)
mon.write("Home") --    HOME
mon.setCursorPos(2,8)
mon.write("X:")
mon.setCursorPos(4,8)
mon.write(hposx)
mon.setCursorPos(8,8)
mon.write("Y:")
mon.setCursorPos(10,8)
mon.write(hposy)
mon.setCursorPos(14,8)
mon.write("Z:")
mon.setCursorPos(16,8)
mon.write(hposz)
mon.setCursorPos(21,8)
mon.write("H:")
mon.setCursorPos(23,8)
mon.write(hposh)
mon.setCursorPos(2,10)
mon.write("Site")    -- SITE
mon.setCursorPos(2,11)
mon.write("X:")
mon.setCursorPos(4,11)
mon.write(sposx)
mon.setCursorPos(8,11)
mon.write("Y:")
mon.setCursorPos(10,11)
mon.write(sposy)
mon.setCursorPos(14,11)
mon.write("Z:")
mon.setCursorPos(16,11)
mon.write(sposz)
mon.setCursorPos(21,11)
mon.write("H:")
mon.setCursorPos(23,11)
mon.write(sposh)
mon.setCursorPos(2,13)   --DUG
mon.write("Dug:")
mon.setCursorPos(6,13)
mon.write(collected)
mon.setCursorPos(11, 13)
mon.write("Last Depth:")
mon.setCursorPos(22, 13)
mon.write(depth)
mon.setCursorPos(2, 16)
mon.write("Status:")
mon.setCursorPos(9, 16)
mon.write(inst)
mon.setCursorPos(2, 18)
mon.write("e:")
mon.setCursorPos(4, 18)
mon.write(exc)
mon.setCursorPos(8, 18)
mon.write("t:")
mon.setCursorPos(10, 18)
mon.write(theight)
mon.setCursorPos(15, 18)
mon.write("r:")
mon.setCursorPos(17, 18)
mon.write(repeats)
mon.setCursorPos(21, 18)
mon.write("o:")
mon.setCursorPos(23, 18)
mon.write(offset)
end
 
function monturtle()
print("monturtle")
updatescreen() -- initial draw
while true do
        src, msg, class = getturtlemsg()
        if class == "R" then
        fuel = msg
        elseif class == "C" then
        cposx = textutils.serialize(msg[1])
        cposy = textutils.serialize(msg[2])
        cposz = textutils.serialize(msg[3])
        cposh = textutils.serialize(msg[4])
        elseif class == "x" then
        cposx = textutils.serialize(msg[1])
        cposy = textutils.serialize(msg[2])
        cposz = textutils.serialize(msg[3])
        cposh = textutils.serialize(msg[4])
        elseif class == "H" then
        hposx = textutils.serialize(msg[1])
        hposy = textutils.serialize(msg[2])
        hposz = textutils.serialize(msg[3])
        hposh = textutils.serialize(msg[4])
        elseif class == "S" then
        sposx = textutils.serialize(msg[1])
        sposy = textutils.serialize(msg[2])
        sposz = textutils.serialize(msg[3])
        sposh = textutils.serialize(msg[4])
        elseif class == "I" then
        inst = msg
        elseif class == "D" then
        depth = msg
        elseif class == "m" then
        collected = msg
        elseif class == "E" then
        exc = msg
        elseif class == "T" then
        theight = msg
        elseif class == "Rx" then
        repeats = msg
        elseif class == "MOX" then
        break
        elseif class == "MON" then
        master = msg
        elseif class == "off" then
        offset = tonumber(msg)
        end
pcall(updatescreen)
end
end
 
function connect()
                mon.clear()
                mon.setCursorPos(4,5)
                mon.write("Monitor ")
                mon.setCursorPos(13,5)
                mon.write(mynumber)
                mon.setCursorPos(4,6)
                mon.write("waiting")
        while true do          
                local src, zmsg, class = getmsg()
                if class == "MON" then
                        print("Connecting...", zmsg)
                        master = tonumber(zmsg)
                        pcall(monturtle)
                end
        end
end
 
-- code execute start
 
mynumber = os.getComputerID()
mon = peripheral.wrap( "top" )
open()
connect()