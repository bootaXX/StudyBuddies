
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local textNote
local username
local uid
local groupname
local gid
local note

local function goMenu()
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
	composer.removeScene("newnote")
    composer.gotoScene( "choice", options)
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
	label = "CREATE",
	onEvent = goMenu,
}

local myBack = widget.newButton
{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = goMenu,
}

function scene:create( event )

	local sceneGroup = self.view
	
	uid = event.params.uid
	username = event.params.username
	gid = event.params.gid
	groupname = event.params.groupname

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "cool.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 150
	
	sceneGroup:insert( myPost )
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
		textNote = native.newTextField(382, 520, 500, 660)
		textNote:addEventListener("userInput", fieldHandler(function() return textNote end))
		textNote.size = 20
		function textNote:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				note = event.target.text
			elseif event.phase == "Submitted" then 
			end
		end
		textNote:addEventListener("userInput", textNote)
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
	textNote:removeSelf()
	textNote = nil

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