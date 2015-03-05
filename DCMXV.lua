-- Peripheral Functions

local function openModem()
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
                            print( "Opening "..sFreeSide.." modem" )
                            rednet.open( sFreeSide )
                            return true
                    else
                            print( "No modem attached" )
                            return false
                    end
            end
            return true
    end
	
	local function openBridge()
            local bOpen, sFreeSide = false, nil
            for n,sSide in pairs(rs.getSides()) do
                    if peripheral.getType( sSide ) == "openperipheral_bridge" then
                            sFreeSide = sSide
                    end
            end
                       
                    if sFreeSide then
                            print( "Opening "..sFreeSide.." Glass Bridge" )
                            glass = peripheral.wrap(sFreeSide)
                            return true
                    else
                            print( "No Bridge attached" )
                            return false
                    end
            
   
    end

	local function openMon()
            local bOpen, sFreeSide = false, nil
            for n,sSide in pairs(rs.getSides()) do
                    if peripheral.getType( sSide ) == "monitor" then
                            sFreeSide = sSide
                    end
            end
                       
                    if sFreeSide then
                            print( "Opening "..sFreeSide.." monitor" )
                            mon = peripheral.wrap(sFreeSide)
                            return true
                    else
                            print( "No Monitor attached" )
                            return false
                    end
            
   
    end
	
	-- menu and UI functions
	
function mainmenu()
    local options={
    "",
    "",
    "",
    "",
    "",
    "",
	"",
    "Exit",
    }
    local n=CUI(options)
    return(n)
    end

	
 function turtlemenu()
    while true do
     choice = mainmenu(n)
            print("choice:", choice)
            if choice == 1 then
                    
                    elseif choice == 2 then
                    
                    elseif choice == 3 then
                    
                    elseif choice == 4 then
                    
                    elseif choice == 5 then
                    
                    elseif choice == 6 then
                    
                    elseif choice == 7 then
                    
                    elseif choice == 8 then
                    break
                    else
            end
    end
    end

-- system functions
function registerHost()
-- generate hostname
rednet.host("DCMXC", "DCMCommand")


end

	-- read the dns registry and return expected fleet details
function sessionRead()
	local fleetID = {rednet.lookup("DCMX")}

	return fleetID
end
	-- ping the fleet, see who responds, set them ready to receive
function initFleet()
		for i=1,#fleetID do
			sndmsg("init", fleetID[i])
			
			
		end
end

-- communicate
    function sndmsg(smsg, id)
    print("sending message")
    os.sleep(1)
    zArgs = {source, id, smsg}
    xargs = textutils.serialize(zArgs)
    rednet.send(tonumber(relay), xargs)
    end 

function getmsg()    -- get message function
local me = os.getComputerID()
local forme = false
while forme == false do
print("listening")
local xid, xmsg, prot = rednet.receive("DCMXC", 5)
print("got message")
local xsub = string.sub(xmsg,1,1)
        if xsub == "{" then
fmsg = textutils.unserialize(xmsg)
print(fmsg)
        ysrc = tonumber(fmsg[1])
        yid = tonumber(fmsg[2])
        ymsg = fmsg[3]
        
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
return ysrc, ymsg
end
	
	--command functions
	function turtleinit()

   
    end	
	
	
	
	-- MAIN FUNCTION START

    openModem() 
	openBridge()
	openMon()
	registerHost()
	sleep(2)
    term.clear()
    source = tonumber(os.getComputerID()) -- get terminal number as source
    sessionRead()
	initFleet()
	turtlemenu()