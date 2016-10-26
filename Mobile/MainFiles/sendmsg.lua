local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
local _W = display.viewableContentWidth
local _H = display.viewableContentHeight

local textMessage
local message
local backButton
local i = 1

local uid
local username

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			-- This is the "keyboard has appeared" event
			-- In some cases you may want to adjust the interface when the keyboard appears.
		
		elseif ( "ended" == event.phase ) then
			-- This event is called when the user stops editing a field: for example, when they touch a different field
			
		elseif ( "editing" == event.phase ) then
		
		elseif ( "submitted" == event.phase ) then
			-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
			--print( textField().text )
			
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
	end
end

local function backtoViewGroup(sceneGroup)
	composer.removeScene( "viewgroup" )
	local options = {
		parent = sceneGroup,
		effect = "crossFade",
		time = 800,
		params = {
			uid = uid,
			username = username
		}
	}
    composer.gotoScene( "viewgroup", options)
end

function scene:create (event)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	uid = event.params.uid
	username = event.params.username

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )

	local background = display.newImageRect(backGroup, "b3.jpg", _W, _H)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local minibg = display.newRect(backGroup, display.contentCenterX, display.contentCenterY * 1.09, _W*0.9, _H*0.60)
	minibg:setFillColor(1,0,0)
	minibg.alpha = 0

	backButton = display.newText( sceneGroup, "Back", 100, 50, native.systemFont, 44 )
	backButton:setFillColor( 0.75, 0.78, 1 )
	backButton:addEventListener("tap", backtoViewGroup)	
end

function scene:show(event)

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		textMessage = native.newTextField(_W * 0.43, _H * 0.9, _W * 0.64, _H * 0.065)
		textMessage:addEventListener("userInput", fieldHandler(function() return textMessage end))
		sceneGroup:insert(textMessage)
		textMessage.placeholder = "Message"
		textMessage.size = 40;

		local send = display.newImageRect(sceneGroup, "send.png", _W * 0.1, _H * 0.063 )
		send.x = _W * 0.82
		send.y = _H * 0.9
		send:addEventListener("tap", send)

		function textMessage:userInput(event)
			if event.phase == "began" then
				print("began")
				event.target.text =''
			elseif event.phase == "ended" then
				message = event.target.text
			elseif event.phase == "submitted" then
				send.tap(event)
				event.target.text = ''
			end
		end

		function send:tap(event)
			print(message)
			local options = {
				parent =sceneGroup,
				text = username .. ": " .. message,
				x = display.contentCenterX,
				y = 400+(30*(i-1)),
				font =native.systemFont,
				fontSize = 30
			}
			i = i+1
			local messageText = display.newText(options)
			messageText:setFillColor(1,0,0)
		end

		textMessage:addEventListener("userInput", textMessage)
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		textMessage:removeSelf()
		textMessage = nil
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