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
rednet.host("DCMX", "DCMCommand")


end

	-- read the roster and return expected fleet details
function sessionRead()
	if fs.exists("sessiondetail") then
		local file = fs.open("sessiondetail", "r")
		local xfleet = textutils.unserialize(file.readAll())
		file:close()
		return xfleet
	else
		local file = fs.open("sessiondetail", "w")
		file.write("{}")
		local xfleet = {}
	end
end
	-- ping the fleet, see who responds, set them ready to receive
function initFleet()

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