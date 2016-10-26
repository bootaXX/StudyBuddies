local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

gap = _H * 0.65;
size = _W * 0.0375;
gap2 = _H*0.05
wgap = _W* 0.5
local dis

local function textListener (event)

	dis = event.target.text

	if(event.phase == "began") then
		dis = nil
	elseif (event.phase == "ended" or event.phase == "submitted") then
		print(event.target.text)
		return dis

	elseif (event.phase == "editing") then
		print(event.newCharacters)
		print(event.oldText)
		print(event.startPosition)
		print(event.text)
	end

	

end

local path = system.pathForFile( "Message.txt", system.DocumentsDirectory )
local upath = system.pathForFile("Username.txt", system.DocumentsDirectory)

local ufile = io.open(upath, "r")
	if not ufile then
		print("File Error: " .. errorString)
	else
		local ucon = ufile:read("*a")

		local gap = _H * 0.05 
		msgy = _H * 0.3

		for line in io.lines( path ) do

	    print( line )
	    msg = display.newText(ucon .. ": ".. line, 0, 0, "unicode.arialr.ttf", _W*0.05)
		msg.anchorX = 0
		msg.x = _W * 0.150
		msg.y = msgy
		msg:setTextColor(0,0,0)
		msgy = msgy + gap
		
		end 

		io.close(ufile)
	end


local sendmsg = native.newTextField(_W * 0.43, _H * 0.9, _W * 0.64, _H * 0.065)


local unamey = msgy
local dispy = msgy

local function printUname()

	local upath = system.pathForFile("Username.txt", system.DocumentsDirectory)
	local ufile = io.open(upath, "r")
		
		if not ufile then
			print("File Error: " .. errorString)
		else
			local ucon = ufile:read("*l")
			local uname = display.newText(ucon .. ": ", 0, 0, "unicode.arialr.ttf", _W * 0.05)
			uname.anchorX = 0;
			uname.x = msg.x
			uname.y = unamey
			uname:setTextColor(0,0,0)
			unamey = unamey + gap2
		end
		disp = display.newText(tostring(dis), 0, 0, "unicode.arialr.ttf", _W * 0.05)
		disp.anchorX = 0
		disp.x = wgap
		disp.y = dispy
		disp:setTextColor(0,0,0)
		dispy = dispy + gap2
		dis = nil;

end


function scene:create (e)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )

	local background = display.newImageRect(backGroup, "b3.jpg", _W, _H)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local minibg = display.newRect(backGroup, display.contentCenterX, display.contentCenterY * 1.09, _W*0.9, _H*0.60)
	minibg:setFillColor(1,0,0)
	minibg.alpha = 0
	--scrollView:insert(minibg)

	
	sceneGroup:insert(sendmsg)
	sendmsg.placeholder = "Message"
	sendmsg.size = 63;
	

	-- sendmsg:addEventListener("touch", printMsg)

	local send = display.newImageRect(sceneGroup, "send.png", _W * 0.1, _H * 0.063 )
	send.x = _W * 0.82
	send.y = _H * 0.9
	send:addEventListener("tap", printUname)
	--send:addEventListener("touch", printMsg)
	sendmsg:addEventListener("userInput", textListener)
	--send:addEventListener("tap", printMsg)

	function send:touch( event )
    	if event.phase == "began" then
        	print( "You touched the object!" )
        	return true
    	end
	end


	function sendmsg:userInput(e)
		if e.phase == "began" then
			e.target.text = ''
		elseif e.phase == "ended" or e.phase == "submitted" then
			print( e.target.text )
			--	labelFeedback.text = "Hello".. " " .. event.target.text
			--  elseif event.phase == "editing" then
			--	labelFeedback.text = event.startPosition 

		elseif ( e.phase == "editing" ) then
	        -- print( e.newCharacters )
	        -- print( e.oldText )
	        -- print( e.startPosition )
	        -- print( e.text )
	   
			--file = nil
		end
	end
end

function scene:show(event)

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		-- txtMessage:removeSelf()
		-- txtMessage = nil
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene