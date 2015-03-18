--DCM Ops v2.2
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
     
    function sessioninfo()
    print("How Many Mining Turtles?")
    local numturt = tonumber(io.read()) -- get number of turtles
    mroster = {}
    for n = 1, numturt do
           
            print("Please enter Turtle ID:")
            local xtid = tonumber(io.read()) -- get turtle number as tid
            mroster[n] = xtid
    end
	    print("How Many Lumberjack Turtles?")
    local numturt = tonumber(io.read()) -- get number of turtles
    jroster = {}
    for n = 1, numturt do
           
            print("Please enter Turtle ID:")
            local xtid = tonumber(io.read()) -- get turtle number as tid
            jroster[n] = xtid
    end
    print("Please enter RelayID: ")
    relay = tonumber(io.read()) -- get relay number as relay
	print("Please enter MonitorID: ")
    tmonitor = tonumber(io.read()) -- get monitor number as tmonitor
	roster = {[1] = mroster, [2] = jroster}
    writesession()
    end
      
    function writesession()
    local xsession = {relay, roster, tmonitor}
    file = fs.open("sessiondetail", "w")
    file.write(textutils.serialize(xsession))
    file:close()
    end
     
    function readsession()
	if fs.exists("sessiondetail") then
    file = fs.open("sessiondetail", "r")
    local xsession = textutils.unserialize(file.readAll())
    file:close()
    relay = tonumber(xsession[1])
    roster = xsession[2]
	mroster = roster[1]
	jroster = roster[2]
	tmonitor = xsession[3]
	
	else
	relay = 0
	mroster = {}
	jroster = {}
	roster = {mroster, jroster}
	writesession()
	end
    end
    
	function minit()
	local msg = {relay, roster}
    local tArgs = {source, tmonitor, msg, "Minit"}
    rednet.send(tmonitor, textutils.serialize(tArgs))
	end
     
    function monitor()
	term.clear()
    print("Which Screen do you want to assign?")
    smon = tonumber(io.read())
	term.clear()
    print("Which type of Turtle do you wish to monitor?")
    print("1 Mining  //  2 Lumberjack")
    local k = tonumber(io.read())
	term.clear()
	print("Which Turtle do you wish to monitor?")
	local i = tonumber(io.read())
	local turtle = roster[k][i]
	local msg = {smon, turtle}	
    local tArgs = {source, tmonitor, msg, "MON"}
    rednet.send(tmonitor, textutils.serialize(tArgs))
    end
     
     
    function breakmon()
	local msg = {1, 0}	
    local tArgs = {source, tmonitor, msg, "MON"}
    rednet.send(tmonitor, textutils.serialize(tArgs))
	os.sleep(1)
	local msg = {2, 0}	
    local tArgs = {source, tmonitor, msg, "MON"}
    rednet.send(tmonitor, textutils.serialize(tArgs))
    end
     
    function monops()
    --choose subsystem
    print [[
    Please select your required system:
    ----------------
    1 - Initialise Monitor
    2 - Assign Monitor
    3 - Clear Monitor
    0 - Exit
    ----------------
    ]]
    local syschoice = io.read()
    if syschoice == "1" then
    term.clear()
	minit()

    elseif syschoice == "2" then
    term.clear()
    monitor()

    elseif syschoice == "3" then
    term.clear()
	breakmon()
    elseif syschoice == "0" then
    term.clear()
    pcall(main)
    else
    print("Input error")
    os.sleep(1)
    end
     
    end
	
	function minerEngage()
	print("1 - Position, 2 - Shaft, 3 - Engage? or 4 - Recall?")
	local jobtype = tonumber(io.read())
	
	if jobtype == 1 then
			 msg = "gotosite"
			elseif jobtype == 2 then
			 msg = "shaft"
			elseif jobtype == 3 then
			 msg = "engage"
			elseif jobtype == 4 then
			 msg = "gohome"
			else
			print("error")
			os.sleep(1)
		end
			
			for i = 1, #mroster do
			local turtle = tonumber(mroster[i])
			local tArgs = {source, turtle, msg, "I"}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending "..msg.." to "..turtle)
		end
	end
	
	
	function lumberjackEngage()
		for i = 1, #jroster do
			local turtle = tonumber(jroster[i])
			local msg = "engage"	
			local tArgs = {source, turtle, msg, "I"}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending to.. "..turtle)
			os.sleep(0.5)
		end
	end
	
	function initAll()
	for v, j in pairs(roster) do
		for i = 1, #j do
			local turtle = tonumber(j[i])
			local msg = "init"	
			local tArgs = {source, turtle, msg, "I"}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending to.. "..turtle)
			os.sleep(0.5)
		end
	end
	
	end
	
	function setHomeAll()
	for v, j in pairs(roster) do
		for i = 1, #j do
			local turtle = tonumber(j[i])
			local msg = "homehere"	
			local tArgs = {source, turtle, msg, "I"}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending to.. "..turtle)
			os.sleep(0.5)
		end
	end	
	end
	
	-- function setParamAll()
	-- for v, j in pairs(roster) do
		-- for i = 1, #j do
			-- local turtle = j[i]
			-- local msg = "xrelay"	
			-- local tArgs = {source, turtle, msg, relay}
			-- rednet.send(relay, textutils.serialize(tArgs))
			-- print("sending to.. "..turtle)
			-- os.sleep(0.5)
		-- end
	-- end	
	
		-- for v, j in pairs(roster) do
		-- for i = 1, #j do
			-- local turtle = j[i]
			-- local msg = "xmonitor"	
			-- local tArgs = {source, turtle, msg, tmonitor}
			-- rednet.send(relay, textutils.serialize(tArgs))
			-- print("sending to.. "..turtle)
			-- os.sleep(0.5)
		-- end
	-- end	
	-- end
	
	function setParamAll()
	print("Please enter new X Coord:")
    local xcoord = tonumber(io.read())
    print("Please enter new Y Coord:")
    local ycoord  = tonumber(io.read())
    print("Please enter new Z Coord:")
    local zcoord  = tonumber(io.read())
    print("Please enter new Heading:")
    local hcoord  = tonumber(io.read())
	print("Please enter e-size:")
	local esize = tonumber(io.read())
    local coords = {xcoord, ycoord, zcoord, hcoord}
	
			for i = 1, #mroster do
			local turtle = mroster[i]
			local msg = "setsite"	
			local tArgs = {source, turtle, msg, coords}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending site to.. "..turtle)
			os.sleep(0.5)
			end
			
			for i = 1, #mroster do
			local turtle = mroster[i]
			local msg = "esize"	
			local tArgs = {source, turtle, msg, esize}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending esize to.. "..turtle)
			os.sleep(0.5)
			end			
			
			local offset = esize
			for i = 1, #mroster do
			local xoffset = i * esize
			local turtle = mroster[i]
			local msg = "setoffset"	
			local tArgs = {source, turtle, msg, xoffset}
			rednet.send(relay, textutils.serialize(tArgs))
			print("sending offset to.. "..turtle)
			os.sleep(0.5)
			end
			
	end
	
	
	
	function groupOps()
	while true do
	term.clear()
	print [[
    "StreffCorp Industrial Control Program v2"
    GroupOps
     
    Please select your required system:
    ----------------
	1 - Engage Miners
	2 - Engage Lumberjacks
	3 - Init All
	4 - Set Home All
	5 - Set MonitorID & RelayID
	0 - Exit
    ----------------
    ]]
	
    local syschoice = io.read()
    if syschoice == "1" then
    term.clear()
	minerEngage()
    elseif syschoice == "2" then
    term.clear()
	lumberjackEngage()
	elseif syschoice == "3" then 
	term.clear()
	initAll()
	elseif syschoice == "4" then
    term.clear()
    setHomeAll()
	elseif syschoice == "5" then
	term.clear()
	setParamAll()
    elseif syschoice == "0" then
    term.clear()
	break
    else
    term.clear()
    print("Input error")
    os.sleep(1)
    end
	end
	end
	
	
	
	
    -- Main Menu
    function main()
	while true do
    term.clear()
    print [[
    "StreffCorp Industrial Control Program v2"
    Main Menu
     
    Please select your required system:
    ----------------
	1 - Lumberjack Ops
	2 - Mining Ops
	3 - Group Ops
	4 - Set Session Detail
	5 - Set Monitor Detail
	0 - Exit
    ----------------
    ]]
    
    local syschoice = io.read()
    if syschoice == "1" then
    term.clear()
    print("Which turtle would you like?")
    local xturtle = tonumber(io.read())
    turtle = jroster[xturtle]
    shell.run("DCMJackServer", relay, turtle)
    elseif syschoice == "2" then
    term.clear()
	print("Which turtle would you like?")
    local xturtle = tonumber(io.read())
    turtle = mroster[xturtle]
    shell.run("DCMServer", relay, turtle)
	elseif syschoice == "3" then 
	term.clear()
	groupOps()
	elseif syschoice == "4" then
    term.clear()
    sessioninfo()
	elseif syschoice == "5" then
	term.clear()
	monops()
    elseif syschoice == "0" then
    term.clear()
	break
    else
    term.clear()
    print("Input error")
    os.sleep(1)
    end
	end
    end
     
    -- call main menu
    open()
	readsession()
    main()
   