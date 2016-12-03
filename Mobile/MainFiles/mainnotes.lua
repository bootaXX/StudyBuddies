local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local username
local gid
local uid
local groupname
local notetitle
local decodedresponse1
local response1
local dgroupname
local currIndex

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
				gid = gid,
				currIndex = currIndex
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
				gid = gid,
				currIndex = currIndex
			}
		}
		composer.removeScene("mainnotes")
		composer.gotoScene("newnote", options)
	end
end

local function handleButtonEventViewNote( event , rowIndex)
	local options = {
		effect = "fromRight",
		time = 300,
		params = {
			uid = uid,
			username = username,
			groupname = groupname,
			gid = gid,
			rowIndex = rowIndex
		}
	}
	composer.removeScene("mainnotes")
	composer.gotoScene("viewnote", options)
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

	local group = display.newGroup()
	sceneGroup:insert(group)

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		local function onRowRender ( event )
			local row = event.row
			local rowSize = 24
			local rowHeight = row.height / 2

			local options_id = {
				parent = row,
				text = response1,
				x = 30,
				y = rowHeight + 40,
				fontSize = 25
			}
			rowTitle = display.newText ( options_id )
			rowTitle:setTextColor( 0, 0, 0 )
			rowTitle.anchorX = 0
			rowTitle.y = rowHeight * 0.85
		end

		local function onRowTouch( event )
			local phase = event.phase
			local row = event.target

			if "press" == phase then
				handleButtonEventViewNote(event, row.index)
			end
		end

		local myTable = widget.newTableView {
			width = display.viewableContentWidth * 0.7,
			height = display.viewableContentHeight * 0.50,
			x = display.contentCenterX,
			y = 450,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch
		}
		group:insert(myTable)

		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				decodedresponse1 = json.decode(event.response)
				local i=1
				while decodedresponse1.title[i] do
					response1 = decodedresponse1.title[i].title
					myTable:insertRow{}
					i = i+1	
				end
				currIndex = i
			end
		end
		network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/viewlistnotes/"..gid), "GET", networkListener)
		-- network.request( ("http://localhost:8080/studybuddies/groupchat/viewlistnotes/"..gid), "GET", networkListener)
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
