
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local labelGroupname
local createButton
local textGroupname
local gnameni

local uid
local username
local function gotoCreateGroup()
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error: ", event.response )
		else
			print ( "RESPONSE: " .. event.response )
		end
	end
	local params = {}
	params.body = "gname="..gnameni.."&uid="..uid
	-- network.request( "http://192.168.43.114:8080/studybuddies/groupchat/insert/"..gnameni.."/"..uid, "GET", networkListener)
	network.request( "http://localhost:8080/studybuddies/groupchat/insert", "POST", networkListener, params)

	local options = {
		effect = "crossFade",
		time = 800,
		params = {
			uid = uid,
			username = username
		}
	}
	composer.gotoScene("viewgroup", options)
	-- body
end

local function gotoCheck()
	print("Check")
	-- body
end

local function backtoViewGroup(sceneGroup)
	composer.removeScene( "viewgroup" )
	local options = {
		parent = sceneGroup,
		effect = "crossFade",
		time = 600,
		params = {
			uid = uid,
			username = username
		}
	}
	composer.removeScene("viewgroup")
    composer.gotoScene( "viewgroup", options)
end

function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )

	uid = event.params.uid -- userid of current user
	print(uid)

	local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	labelGroupname = display.newText( sceneGroup, "Groupname:", 217, 300, native.systemFont, 40)
	sceneGroup:insert( labelGroupname )

	createButton = display.newText( sceneGroup, "Create", display.contentCenterX, 520, native.systemFont, 44 )
	createButton:setFillColor( 0.75, 0.78, 1 )

	checkButton = display.newText( sceneGroup, "Check", display.contentCenterX, 450, native.systemFont, 44 )
	checkButton:setFillColor( 0.75, 0.78, 1 )
	createButton:addEventListener("tap", gotoCreateGroup)
	checkButton:addEventListener("tap", gotoCheck)

	backButton = display.newText( sceneGroup, "Back", 100, 50, native.systemFont, 44 )
	backButton:setFillColor( 0.75, 0.78, 1 )
	backButton:addEventListener("tap", backtoViewGroup)	

	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
end

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			-- This is the "keyboard has appeared" event
			-- In some cases you may want to adjust the interface when the keyboard appears.
		
		elseif ( "ended" == event.phase ) then
			
		elseif ( "editing" == event.phase ) then
		
		elseif ( "submitted" == event.phase ) then
			-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
			--print( textField().text )
			
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
	end
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		textGroupname = native.newTextField(375, 370, 500, 60)
		textGroupname:addEventListener("userInput", fieldHandler(function() return textGroupname end))
		sceneGroup:insert( textGroupname )
		textGroupname.size = 38
		textGroupname.placeholder = "Group name"

		function textGroupname:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				gnameni = event.target.text
			elseif event.phase == "Submitted" then
			end
		end
		textGroupname:addEventListener("userInput", textGroupname)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		textGroupname:removeSelf()
		textGroupname = nil

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
