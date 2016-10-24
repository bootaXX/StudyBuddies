
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )


local backGroup
local createGroupChatButton
local viewGroupsButton
local viewjoinedgroup
local function gotoCreateGroupChat()
	composer.removeScene( "creategroupchat" )
    composer.gotoScene( "creategroupchat", { time=800, effect="crossFade" })
end
local function gotoViewGroup()
	composer.removeScene("viewgroup")
	composer.gotoScene("viewgroup")
end
local function gotoJoinedGroup()
	composer.removeScene("viewjoinedgroup")
	composer.gotoScene("viewjoinedgroup")
end
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )

	local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY


	local register = display.newImageRect( backGroup, "welcome.png", 500, 80 )
	register.x = display.contentCenterX
	register.y = 200

	createGroupChatButton = display.newText( sceneGroup, "Create Group", display.contentCenterX, 450, native.systemFont, 44 )
	createGroupChatButton:setFillColor( 0.75, 0.78, 1 )
	viewGroupsButton = display.newText(sceneGroup,"View Groups",display.contentCenterX,500,native.systemFont,44)
	viewGroupsButton:setFillColor(0.75, 0.78, 1)
	viewjoinedgroup = display.newText(sceneGroup,"View Joined Groups",display.contentCenterX,550,native.systemFont,44)
	viewjoinedgroup:setFillColor(0.75, 0.78, 1)

	createGroupChatButton:addEventListener("tap", gotoCreateGroupChat)
	viewGroupsButton:addEventListener("tap",gotoViewGroup)
	viewjoinedgroup:addEventListener("tap",gotoJoinedGroup)
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
