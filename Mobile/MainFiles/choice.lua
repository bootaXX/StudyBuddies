
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

local function handleButtonEventPostQuestion( event )
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
		composer.gotoScene("question", options)
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

	-- if "ended" == phase then
	-- 	local options = {
	-- 		effect = "crossFade",
	-- 		time = 300,
	-- 		params = {
	-- 			uid = uid,
	-- 			username = username
	-- 		}
	-- 	}
	-- 	composer.removeScene("viewgroup")
	-- 	composer.gotoScene("viewgroup", options)
	-- end
end

local function handleButtonEventNewNote( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "fromRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid
			}
		}
		composer.gotoScene("newnote", options)
	end
end
------------------------------------------------------------------------------------------------------------------------
local myTimeline = widget.newButton
{
	left = 200,
	top = 300,
	width = 350,
	height = 50,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "TIMELINE",
	onEvent = handleButtonEventTimeline
}

local myMessage = widget.newButton
{
	left = 200,
	top = 360,
	width = 350,
	height = 50,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "SEND MESSAGE",
	onEvent = handleButtonEventSendMessage
}
local myPost = widget.newButton
{
	left = 200,
	top = 420,	
	width = 350,
	height = 50,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "POST QUESTION",
	onEvent = handleButtonEventPostQuestion
}

local myCalendar = widget.newButton
{
	left = 200,
	top = 480,	
	width = 350,
	height = 50,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "CALENDAR",
	onEvent = handleButtonEventGoToCalendar,

}
local myCreateNotes = widget.newButton
{
	left = 200,
	top = 540,	
	width = 350,
	height = 50,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "CREATE NOTES",
	onEvent = handleButtonEventNewNote,

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
	sceneGroup:insert( myPost )
	sceneGroup:insert( myBack )
	sceneGroup:insert( myCalendar )
	sceneGroup:insert( myCreateNotes )

background:addEventListener("tap", background)
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		print(username)

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
