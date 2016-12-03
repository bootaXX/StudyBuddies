
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
display.setStatusBar(display.HiddenStatusBar)

-- Get month and year
local date = os.date('*t')
local month = date.month
local year = date.year


local view
local username
local uid
local gid
local groupname
-----------------------------------------------------------------------------------------------------------------------
local function goBack()
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
	composer.removeScene("maincalendar")
	composer.gotoScene("choice", options)
end

local myBack = widget.newButton
{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = goBack,
}

------------------------------------------------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view
	local _W = display.contentWidth
	local _H = display.contentHeight
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY

	uid = event.params.uid
    username = event.params.username
    gid = event.params.gid
    groupname = event.params.groupname
	-- Background
	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Create calendar widget
	local newCalendarView = require('newCalendarView')
	view = newCalendarView.new(month, year)

	
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
	view:removeSelf()
	view = nil

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
