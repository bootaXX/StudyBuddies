local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local physics = require( "physics" )
local json = require("json")

physics.start()
physics.setGravity( 0, 0 )

local labelGroupname
local createButton
local textGroupname
local textPassword
local gnameni
local passwordni
local labelPassword
local timerperform

local uid
local username
local groupname

local function backtoViewGroup( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "slideRight",
			time = 300,
			params = {
				uid = uid,
				username = username
			}
		}
		composer.removeScene("verifygroup")
		composer.gotoScene("viewgroup", options)
	end
end

local function onComplete( event )
	if (event.action == "clicked") then
		local i = event.index
		if(i==1) then
		end
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
	onEvent = backtoViewGroup,
}

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

-- create
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )

	uid = event.params.uid -- userid of current user
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid

	print(uid)

	local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	labelGroupname = display.newText( sceneGroup, groupname, 217, 300, native.systemFont, 40)
	sceneGroup:insert( labelGroupname )

	labelPassword = display.newText( sceneGroup, "Password: ", 200, 400,native.systemFont,30 )
	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end
	sceneGroup:insert(myBack)
	background:addEventListener("tap", background)

	local function handleJoinEvent(event)
		if(event.phase == 'ended') then
			local function networkListener(event)
				if(event.isError) then
					print("Network error: ", event.response)
				else 
					print(event.response)
					local reply = json.decode(event.response)
					local replymessage = reply.callback

					if(replymessage == "invalid") then
						local alert = native.showAlert("Error Input", "Invalid Password", {"Ok"}, onComplete)
					else
						local options = {
							effect = "fromRight",
							time = 300,
							params = {
								uid = uid,
								username = username,
								groupname = groupname,
								gid = gid
							}
						}
						composer.removeScene("verifygroup")
						composer.gotoScene("choice", options)
					end
				end
			end
			network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/joinvalid/"..gid.."/"..uid.."/"..passwordni), "GET", networkListener)
			-- network.request( ("http://localhost:8080/studybuddies/groupchat/joinvalid/"..gid.."/"..uid.."/"..passwordni), "GET", networkListener)
		end
	end
	local joingroupButton = widget.newButton(
		{
			x = display.contentCenterX,
			y = 475,
			shape = "rect",
			id = "joinbutton",
			label = "JOIN",
			fontSize = 25,
			fillColor = { default={ 1, 0.5, 0.5, 0.5 }, over={ 1, 0.2, 0.5, 1 } },
			onEvent = handleJoinEvent
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


		textPassword = native.newTextField(450, 400, 350, 50)
		textPassword:addEventListener("userInput", fieldHandler(function() return textPassword end))
		textPassword.size = 30
		textPassword.isSecure = true
		textPassword.placeholder = "Password"
		textPassword:addEventListener("userInput", textPassword)


		function textPassword:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				passwordni = event.target.text
			elseif event.phase == "Submitted" then
			end
		end
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
	textPassword:removeSelf()
	textPassword = nil

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
