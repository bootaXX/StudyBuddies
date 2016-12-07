local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local json = require("json")

local _W = display.viewableContentWidth
local _H = display.viewableContentHeight
local textMessage
local message = ""
local i = 1
local uid
local username
local groupname
local gid
local loadedmessage
local decres
local messageText
local timerperform
local UIGroup
UIGroup = display.newGroup()
UIGroup.y = -5

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			 -- Transition group upward to y=50
        transition.to( UIGroup, { time=100, y=-330} )
		elseif ( "editing" == event.phase ) then

		elseif ( "submitted" == event.phase or  "ended" == event.phase ) then
            native.setKeyboardFocus( nil )
            -- Transition group back down to y=300
            transition.to( UIGroup, { time = 100, y = -5})
		end
	end
end

local function backtoChoice(event)
	local phase = event.phase
	if (phase == "ended") then
		local options = {
			effect = "slideRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				groupname = groupname,
				gid = gid
			}
		}
		composer.removeScene("sendmsg")
	    composer.gotoScene( "choice", options)
	end
end

local myBack = widget.newButton
{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = backtoChoice
}

function scene:create (event)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	uid = event.params.uid
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )

	local background = display.newImageRect(backGroup, "3.jpg", _W, _H)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local minibg = display.newRect(backGroup, display.contentCenterX, display.contentCenterY * 1.09, _W*0.9, _H*0.60)
	minibg:setFillColor(1,0,0)
	minibg.alpha = 0

	sceneGroup:insert(myBack)

	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
end

function scene:show(event)

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		local sendmessage = native.newTextBox(382, 450, 500, 560)
		sendmessage.isEditable = false
		sendmessage.size = 25
		sceneGroup:insert(sendmessage)
		UIGroup:insert(sendmessage)

		textMessage = native.newTextField(_W * 0.48, _H * 0.85, _W * 0.64, _H * 0.065)
		textMessage:addEventListener("userInput", fieldHandler(function() return textMessage end))
		textMessage.placeholder = "Message"
		textMessage.size = 40;
		UIGroup:insert(textMessage)

		function textMessage:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif (event.phase == "ended") then
				message = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        message = event.newCharacters
			end
		end

		local function handleButtonEvent( event )
			if(event.phase == "ended") then
				local function networkListener( event )
					if ( event.isError ) then
						print( "Network error: ", event.response )
					else
						print( "RESPONSE: ", event.response )
					end
				end

				local params = {}
				params.body = "messagesent="..message.."&groupnamesent="..groupname.."&usernamesent="..username
				network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/writemessage"), "POST", networkListener, params)
				-- network.request( ("http://localhost:8080/studybuddies/groupchat/writemessage"), "POST", networkListener, params)
			end
		end

		local sendmessageButton = widget.newButton(
			{
				x = 580,
				y = 870,
				shape = "rect",
				id = "sendbutton",
				label = "Send",
				fontSize = 25,
				fillColor = { default={ 1, 0.5, 0.5, 0.5 }, over={ 1, 0.2, 0.5, 1 } },
				onEvent = handleButtonEvent
			}
		)
		sceneGroup:insert(sendmessageButton)
		UIGroup:insert(sendmessageButton)

		local function reloadMessage( event )
			-- body
			local decres2
			local length = 1
			local lddmessage
			local function networkListener1( event )
				if (event.isError) then
					print("Network error: ", event.response)
				else
					decres2 = json.decode(event.response)
					length = decres2.lines
					lddmessage = decres2.message
					if(length ~= i) then
						sendmessage.text = lddmessage
					end
				end
			end

			network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/loadmessage/"..groupname), "GET", networkListener1)
			-- network.request( ("http://localhost:8080/studybuddies/groupchat/loadmessage/"..groupname), "GET", networkListener1)
		end

		timerperform = timer.performWithDelay(1000, reloadMessage, 0)	
		textMessage:addEventListener("userInput", textMessage)
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	timer.cancel(timerperform)
	textMessage:removeSelf()
	textMessage = nil
	UIGroup:removeSelf()
	UIGroup = nil
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