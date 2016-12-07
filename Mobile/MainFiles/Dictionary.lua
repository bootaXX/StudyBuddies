local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local uid
local username
local groupname
local gid
-----------------------------------------------------------------------------------------------------------------------
local function webListener( event )
    if event.url then
        print( "You are visiting: " .. event.url )
    end

    if event.type then
        print( "The event.type is " .. event.type ) -- print the type of request
    end

    if event.errorCode then
        native.showAlert( "Error!", event.errorMessage, { "OK" } )
    end
end


local webView = native.newWebView( display.contentCenterX, display.contentCenterY, 480, 880)
webView:request( "http://www.merriam-webster.com/" )
webView:addEventListener( "urlRequest", webListener )

	
local function goBack(event)
	local phase = event.phase
	if(phase == "ended") then
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
		composer.removeScene("Dictionary")
		composer.gotoScene("choice", options)
	end
end

------------------------------------------------------------------------------------------------------------------------
local myBack = widget.newButton
{
	left = 365,
	top = 965,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = goBack
}

function scene:create( event )

	local sceneGroup = self.view

	uid = event.params.uid
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	sceneGroup:insert( myBack )
	
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
