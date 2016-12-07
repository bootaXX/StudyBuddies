
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")

local response1
local decodedresponse1
local response2
local decodedresponse2
local dgroupname

local uid
local username
local groupname
local gid

local textJoinGroup
local timerperform

local UIGroup
UIGroup = display.newGroup()
UIGroup.y = -5

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
        	transition.to( UIGroup, { time=100, y=-330} )
		elseif ( "editing" == event.phase ) then
		elseif ( "submitted" == event.phase or  "ended" == event.phase ) then
            native.setKeyboardFocus( nil )
            transition.to( UIGroup, { time = 100, y = -5})
		end
	end
end

local function onComplete( event )
	if (event.action == "clicked") then
		local i = event.index
		if(i==1) then
		end
	end
end

local function gotoCreateGroupChat(event)
	local phase = event.phase
	if (phase == "ended") then
		local options = {
			effect = "fromBottom",
			time = 300,
			params = {
				uid = uid,
				username = username
			}
		}
		composer.removeScene("viewgroup")
	    composer.gotoScene( "creategroupchat", options)
	end
end

local function logout(event)
	local phase = event.phase
	if(phase == "ended") then
		local options = {
			effect = "fade",
			time = 200
		}
		composer.removeScene("viewgroup")
    	composer.gotoScene( "menu", options)
	end
end

local function onComplete( event )
	if (event.action == "clicked") then
		local i = event.index
		if(i==1) then
		end
	end
end

local function handleButtonEvent( event )
	if(event.phase == "ended") then
		if(groupname == nil) then
			local alert = native.showAlert("Input Error", "Invalid Groupname: No input", {"Ok"}, onComplete)
		else
			local function networkListener( event )
				if ( event.isError ) then
					print( "Network error: ", event.response )
				else
					local reply = json.decode(event.response)
					local replymessage = reply.callback
					gid = reply.gid
					if(replymessage == "invalid") then
						local alert = native.showAlert("Error Input", "Invalid Groupname", {"Ok"}, onComplete)
					elseif(replymessage == "valid1") then
						local options1 = {
							effect = "fromRight",
							time = 300,
							params = {
								uid = uid,
								username = username,
								groupname = groupname,
								gid = gid
							}
						}
						composer.removeScene("viewgroup")
						composer.gotoScene("verifygroup", options1)
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
						composer.removeScene("viewgroup")
						composer.gotoScene("choice", options)
					end
				end
			end
			network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/join/"..groupname.."/"..uid), "GET", networkListener)
			-- network.request( ("http://localhost:8080/studybuddies/groupchat/join/"..groupname.."/"..uid), "GET", networkListener)
		end
	end
end

local joingroupButton = widget.newButton{
	left = 505,
	top = 820,
	width = 175,
	height = 65,
	defaultFile = "j1.png",
	overFile = "j2.png",
	onEvent = handleButtonEvent
}

local logoutButton = widget.newButton{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = logout
}

local createGroupButton = widget.newButton{
	left = 250,
	top = 925,
	width = 250,
	height = 65,
	defaultFile = "c1.png",
	overFile = "c2.png",
	onEvent = gotoCreateGroupChat
}


function scene:create( event )
	
	local sceneGroup = self.view

	uid = event.params.uid -- userid of current user
	username = event.params.username -- username of current user

	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)

	local background = display.newImageRect( sceneGroup, "5.jpg", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "studyBuddies.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200

	labelGroupname = display.newText( sceneGroup, "Hi, "..username.."!", 300, 75, native.systemFont, 35)
	sceneGroup:insert( labelGroupname )
	sceneGroup:insert(logoutButton)
	sceneGroup:insert(joingroupButton)
	sceneGroup:insert(createGroupButton)
	UIGroup:insert(joingroupButton)

	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	local checker

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		local grouplist = native.newTextBox(382, 500, 500, 500)
		grouplist.isEditable = false
		grouplist.size = 30
		sceneGroup:insert(grouplist)
		UIGroup:insert(grouplist)

		textJoinGroup = native.newTextField(300, 853, 400, 65)
		textJoinGroup:addEventListener("userInput", fieldHandler(function() return textJoinGroup end))
		textJoinGroup.size = 38
		textJoinGroup.placeholder = "Groupname"
		textJoinGroup:addEventListener("userInput", textJoinGroup)
		UIGroup:insert(textJoinGroup)

		function textJoinGroup:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif (event.phase == "ended") then
				groupname = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        groupname = event.newCharacters
			end
		end

		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				decodedresponse1 = json.decode(event.response)
				local i=1
				local groups = ""
				while decodedresponse1.chat[i] do
					response1 = decodedresponse1.chat[i].groupname
					groups = groups .. "\n" .. response1
					i = i+1
				end
				grouplist.text = groups
				checker = i
			end
		end

		network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/select"), "GET", networkListener)
		-- network.request( ("http://localhost:8080/studybuddies/groupchat/select"), "GET", networkListener)

		local function reloadGroups( event )
			-- body
			network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/select"), "GET", networkListener)
			-- network.request( ("http://localhost:8080/studybuddies/groupchat/select"), "GET", networkListener2)

			local function networkListener2( event )
				if (event.isError) then
					print("Network error: ", event.response)
				else
					decodedresponse2 = json.decode(event.response)
					if(decodedresponse2.chat[checker].groupname ~= decodedresponse1.chat[checker].groupname) then
						timer.cancel(timerperform)
						local options = {
							params = {
								uid = uid,
								username = username
							}
						}
						composer.removeScene("viewgroup")
					    composer.gotoScene( "viewgroup", options)
					end
				end
			end
		end
		timerperform = timer.performWithDelay(2000, reloadGroups, 0)
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
	textJoinGroup:removeSelf()
	textJoinGroup = nil
	-- grouplist:removeSelf()
	-- grouplist = nil
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
