
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json");

local res
local decres
local dgroupname

local uid
local username

local textJoinGroup
local groupname

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

local function gotoCreateGroupChat()
	composer.removeScene( "creategroupchat" )
	local options = {
		effect = "crossFade",
		time = 800,
		params = {
			uid = uid,
			username = username
		}
	}
    composer.gotoScene( "creategroupchat", options)
end

function scene:create( event )
	
	local sceneGroup = self.view

	uid = event.params.uid -- userid of current user
	username = event.params.username -- username of current user
	print(uid .. ": " .. username)

	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "study.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200

	createGroupChatButton = display.newText( sceneGroup, "Create Group", display.contentCenterX, 950, native.systemFont, 44 )
	createGroupChatButton:setFillColor( 0.75, 0.78, 1 )
	createGroupChatButton:addEventListener("tap", gotoCreateGroupChat)

	--eventhandler for buttonid = joinbutton
	local function handleButtonEvent( event )
		if(event.phase == "ended") then
			local function networkListener( event )
				if ( event.isError ) then
					print( "Network error: ", event.response )
				else
					print( "RESPONSE: ", event.response )
				end
			end
			-- network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/join/"..groupname.."/"..uid), "GET", networkListener)
			network.request( ("http://localhost:8080/studybuddies/groupchat/join/"..groupname.."/"..uid), "GET", networkListener)
			local options = {
				effect = "crossFade",
				time = 800,
				params = {
					uid = uid,
					username = username
				}
			}
			composer.removeScene("sendmsg")
			composer.gotoScene("sendmsg", options)
			print("Pressed")
		end
	end

	local joingroupButton = widget.newButton(
		{
			x = 600,
			y = 875,
			shape = "rect",
			id = "joinbutton",
			label = "JOIN",
			fontSize = 25,
			fillColor = { default={ 1, 0.5, 0.5, 0.5 }, over={ 1, 0.2, 0.5, 1 } },
			onEvent = handleButtonEvent
		}
	)
	sceneGroup:insert(joingroupButton)

	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		textJoinGroup = native.newTextField(300, 875, 400, 65)
		textJoinGroup:addEventListener("userInput", fieldHandler(function() return textJoinGroup end))
		sceneGroup:insert( textJoinGroup )
		textJoinGroup.size = 38
		textJoinGroup.placeholder = "Groupname"
		textJoinGroup:addEventListener("userInput", textJoinGroup)

		function textJoinGroup:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				groupname = event.target.text
				print(groupname)
			elseif event.phase == "Submitted" then
			end
		end

		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				decres = json.decode(event.response)
				local i=1
				while decres.chat[i] do
					res = decres.chat[i].groupname
					dgroupname = display.newText( sceneGroup, res, display.contentCenterX, 400+(30*(i-1)), native.systemFont, 30 )
					sceneGroup:insert( dgroupname )
					i = i+1
				end
			end
		end

		--network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/select"), "GET", networkListener)
		network.request( ("http://localhost:8080/studybuddies/groupchat/select"), "GET", networkListener)

		local function viewGroups( event )
			-- body
		end

		Runtime:addEventListener("enterFrame", viewGroups)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		textJoinGroup:removeSelf()
		textJoinGroup = nil
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
