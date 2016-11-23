local composer = require ("composer")
local scene = composer.newScene()
local widget = require ("widget")

local sampNote
local titlee

---------------------------------------------------------------------------------------------------------
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
		composer.removeScene("viewnote")
		composer.gotoScene("mainnotes", options)
	end
end
---------------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------------

function scene:create (event)

	local sceneGroup = self.view

	local background = display.newImageRect (sceneGroup, "background.jpg", display.viewableContentWidth, display.viewableContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	titlee = display.newText (sceneGroup, "Notes", display.contentCenterX, 90, native.systemFont, 25)
	sceneGroup:insert (titlee)

		
		
	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
end

function scene:show ( event )

	local sceneGroup = self.view 
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then 

		local options = {
			parent = sceneGroup,
			x = display.contentCenterX,
			y = display.contentCenterY,
			fontSize = 16,
			anchorX = 270,
			text = note,
			width = 220,
		}
		sampNote = display.newText ( options )
		sceneGroup:insert (sampNote)
	
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
