
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json");

local res
local decres

local dgroupname
local joingrouptext
local joingroupbutton


	

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			-- This is the "keyboard has appeared" event
			-- In some cases you may want to adjust the interface when the keyboard appears.
		
		elseif ( "ended" == event.phase ) then
			-- This event is called when the user stops editing a field: for example, when they touch a different field
			
		elseif ( "editing" == event.phase ) then
		
		elseif ( "submitted" == event.phase ) then
			-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
			--print( textField().text )
			
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
	end
end

function scene:create( event )
	
	local sceneGroup = self.view

	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "study.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200

	joingrouptext = native.newTextField(375, 300, 400, 60)
	sceneGroup:insert( joingrouptext)
	joingrouptext.size = 20
	joingrouptext.x = 350

	joingroupbutton = display.newText(sceneGroup,"JOIN",600,300)

	

	
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
		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				decres = json.decode(event.response)
				local i=1
				res = decres.chat[1].groupname
				while decres.chat[i] do
					res = decres.chat[i].groupname
					dgroupname = display.newText( sceneGroup, res, display.contentCenterX, 400+(30*(i-1)), native.systemFont, 30 )
					sceneGroup:insert( dgroupname )
					i = i+1
				end
				-- res = decres.chat[1].groupname
				-- print(res)
				-- dgroupname = display.newText( sceneGroup, res, display.contentCenterX, 300, native.systemFont, 30 )
				-- sceneGroup:insert( dgroupname )
				-- res = decres.chat[2].groupname
				-- dgroupname = display.newText( sceneGroup, res, display.contentCenterX, 330, native.systemFont, 30 )
				-- sceneGroup:insert( dgroupname)
			end
		end
		network.request( ("http://localhost:8080/viewGroups"), "GET", networkListener)
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
