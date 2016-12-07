
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local labelUsername
local labelPassword
local labelFeedback
local textUsername
local textPassword
local username
local groupname
local uid
local gid
-----------------------------------------------------------------------------------------------------------------------
local function handleButtonEventTimeline( event )
	local phase = event.phase

	if "ended" == phase then
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
		composer.gotoScene("timeline", options)
	end
end

local function handleButtonEventSendMessage( event )
	local phase = event.phase

	if "ended" == phase then
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
		composer.gotoScene("sendmsg", options)
	end
end

local function handleButtonEventGoBack( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "slideRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid
			}
		}
		composer.removeScene("choice")
		composer.gotoScene("viewgroup", options)
	end
end

local function handleButtonEventGoToCalendar( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "crossFade",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid,
				groupname = groupname
			}
		}
		composer.gotoScene("maincalendar", options)
	end
end

local function handleButtonEventNotes( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "fromRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid,
				groupname = groupname
			}
		}
		composer.gotoScene("mainnotes", options)
	end
end

local function handleButtonEventNotes( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "fromRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid,
				groupname = groupname
			}
		}
		composer.gotoScene("Dictionary", options)
	end
end

local function handleButtonEventTableOfElements( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "fromRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid,
				groupname = groupname
			}
		}
		composer.gotoScene("toe", options)
	end
end
------------------------------------------------------------------------------------------------------------------------
local myTimeline = widget.newButton
{
	left = 200,
	top = 300,
	width = 350,
	height = 80,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "QUESTIONS",
	fontSize = 30,
	onEvent = handleButtonEventTimeline
}
local myMessage = widget.newButton
{
	left = 200,
	top = 390,
	width = 350,
	height = 80,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "MESSAGES",
	fontSize = 30,
	onEvent = handleButtonEventSendMessage
}
local myCalendar = widget.newButton
{
	left = 200,
	top = 480,	
	width = 350,
	height = 80,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "CALENDAR",
	fontSize = 30,
	onEvent = handleButtonEventGoToCalendar,

}
local myCreateNotes = widget.newButton
{
	left = 200,
	top = 570,	
	width = 350,
	height = 80,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "NOTES",
	fontSize = 30,
	onEvent = handleButtonEventNotes,

}
local myDictionary = widget.newButton
{
	left = 200,
	top = 660,	
	width = 350,
	height = 80,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "DICTIONARY",
	fontSize = 30,
	onEvent = gotoWeb

}
local myTableOfElements = widget.newButton
{
	left = 200,
	top = 750,	
	width = 350,
	height = 80,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "TABLE OF ELEMENTS",
	fontSize = 30,
	onEvent = handleButtonEventTableOfElements

}
local myBack = widget.newButton
{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = handleButtonEventGoBack
}
---------------------------------------------------------------------------------------------------------------------------
function scene:create( event )

	local sceneGroup = self.view

	groupname = event.params.groupname
	username = event.params.username
	uid = event.params.uid
	gid = event.params.gid

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "cool.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200

	sceneGroup:insert( myTimeline )
	sceneGroup:insert( myMessage )
	sceneGroup:insert( myBack )
	sceneGroup:insert( myCalendar )
	sceneGroup:insert( myCreateNotes )
	sceneGroup:insert( myDictionary )
	sceneGroup:insert( myTableOfElements )

background:addEventListener("tap", background)
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		print("choice " .. username .. " : " .. gid)

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
