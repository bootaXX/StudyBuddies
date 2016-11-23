
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local username
local gid
local uid
local groupname
local textChooseNote
local notetitle
local decodedresponse1
local response1
local dgroupname

local function handleButtonEvent( event )
	local phase = event.phase

	if "ended" == phase then
		print("you pressed and released a button")
	end
end

local function handleButtonEventgoBack( event )
	local phase = event.phase

	if "ended" == phase then
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
		composer.removeScene("mainnotes")
		composer.gotoScene("choice", options)
	end
end

local function handleButtonEventCreateNote( event )
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
		composer.removeScene("mainnotes")
		composer.gotoScene("newnote", options)
	end
end

local function handleButtonEventViewNote( event )
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
		composer.removeScene("viewnotes")
		composer.gotoScene("newnote", options)
	end
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
------------------------------------------------------------------------------------------------------------------------
local myPost = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 75,
	defaultFile = "default.png",
	overFile = "over.png",
	fontSize = 30,
	label = "ADD NOTES",
	onEvent = handleButtonEventCreateNote,
}

local myViewNote = widget.newButton
{
	left = 520,
	top = 800,
	width = 150,
	height = 75,
	defaultFile = "default.png",
	overFile = "over.png",
	fontSize = 30,
	label = "View",
	onEvent = handleButtonEventViewNote,
}

local myBack = widget.newButton
{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = handleButtonEventgoBack,
}

function scene:create( event )

	local sceneGroup = self.view
	
	username = event.params.username
	gid = event.params.gid
	uid = event.params.uid
	groupname = event.params.groupname

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "notes.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 150	

	sceneGroup:insert( myPost )
	sceneGroup:insert( myViewNote )
	sceneGroup:insert( myBack )

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
		textNoteQuestion = native.newTextField(300, 835, 400, 72)
		textNoteQuestion:addEventListener("userInput", fieldHandler(function() return textNoteQuestion end))
		textNoteQuestion.size = 38
		textNoteQuestion.placeholder = "Note Title"
		textNoteQuestion:addEventListener("userInput", textNoteQuestion)

		function textNoteQuestion:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				notetitle = event.target.text
				print(notetitle)
			elseif event.phase == "Submitted" then
			end
		end

		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				decodedresponse1 = json.decode(event.response)
				local i=1
				while decodedresponse1.title[i] do
					response1 = decodedresponse1.title[i].title
					dgroupname = display.newText( sceneGroup, response1, display.contentCenterX, 400+(30*(i-1)), native.systemFont, 30 )
					sceneGroup:insert( dgroupname )
					i = i+1
				end
				checker = i
			end
		end

		-- network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/viewlistnotes/"..gid), "GET", networkListener)
		network.request( ("http://localhost:8080/studybuddies/groupchat/viewlistnotes/"..gid), "GET", networkListener)
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
	textNoteQuestion:removeSelf()
	textNoteQuestion = nil

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
