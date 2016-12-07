-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ("widget")

local toe
local username
local uid
local gid
local groupname
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
local function handleButtonEventGoBack( event )
    local phase = event.phase

    if "ended" == phase then
        local options = {
            effect = "slideRight",
            time = 300,
            params = {
                uid = uid,
                username = username,
                groupname = groupname,
                gid = gid,
                currIndex = currIndex
            }
        }
        composer.removeScene("toe")
        composer.gotoScene("choice", options)
    end
end
-- -----------------------------------------------------------------------------------
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
-- create()
function scene:create( event )

    local sceneGroup = self.view

    uid = event.params.uid
    username = event.params.username
    gid = event.params.gid
    groupname = event.params.groupname
    toe = display.newImage( sceneGroup, "1.jpg", display.viewableContentWidth, display.viewableContentHeight)    -- Code here runs when the scene is first created but has not yet appeared on screen
    toe.x = display.contentCenterX
	toe.y = display.contentCenterY
    sceneGroup:insert(toe)
    sceneGroup:insert(myBack)

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    local scrollGroup = display.newGroup()
	sceneGroup:insert(scrollGroup)

    local scrollView = widget.newScrollView(
	   {
	   		top = 0,
	   		left = 0,
	        x = display.viewableContentCenterX,
	        y = display.contentCenterY,
	        width = display.viewableContentWidth,
	        height = display.viewableContentHeight,
	        hideBackground = true,
	        listener = scrollListener
	    }
	)
	
	sceneGroup:insert(scrollView)
	scrollGroup:insert(toe)
	scrollView:insert(scrollGroup)
    scrollView:insert(myBack)



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