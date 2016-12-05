local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local uid
local username
local groupname
local gid
local textChooseQuestion
local response1
local decodedresponse1
local UIGroup
local currIndex
UIGroup = display.newGroup()
UIGroup.y = -5
-----------------------------------------------------------------------------------------------------------------------
local function handleButtonEventGoBack(event)
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
	composer.removeScene("timeline")
	composer.gotoScene("choice", options)
end

local function handleButtonEventGoToTopic( event , rowIndex)
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
	composer.removeScene("timeline")
	composer.gotoScene("viewquestions", options)
end

local function gotoAddTopic(event)
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
	composer.removeScene("timeline")
	composer.gotoScene("createtopic", options)
end

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

local addTopic = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 65,
	fontSize = 25,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "ADD TOPIC",
	onEvent = gotoAddTopic
}

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			 -- Transition group upward to y=50
        transition.to( UIGroup, { time=100, y=-250} )
		elseif ( "editing" == event.phase ) then

		elseif ( "submitted" == event.phase or  "ended" == event.phase ) then
            native.setKeyboardFocus( nil )
            -- Transition group back down to y=300
            transition.to( UIGroup, { time = 100, y = -5})
		end
	end
end
------------------------------------------------------------------------------------------------------------------------
function scene:create( event )

	local sceneGroup = self.view
	
	uid = event.params.uid
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "cool.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200

	sceneGroup:insert(myBack)
	sceneGroup:insert(addTopic)
	background:addEventListener("tap", background)
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	local checker

	local group = display.newGroup()
	sceneGroup:insert(group)

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		local function onRowRender ( event )
			local row = event.row
			local rowSize = 30
			local rowHeight = row.height * 0.75

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
				handleButtonEventGoToTopic(event, row.index)
			end
		end

		local myTable = widget.newTableView {
			width = display.viewableContentWidth * 0.7,
			height = display.viewableContentHeight * 0.50,
			x = display.contentCenterX,
			y = 500,
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
				while decodedresponse1.chat[i] do
					response1 = decodedresponse1.chat[i].topic
					myTable:insertRow{}
					i = i+1
				end
				currIndex = i
			end
		end
		network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/questions/viewtopics/"..gid), "GET", networkListener)
		-- network.request( ("http://localhost:8080/studybuddies/groupchat/viewquestions/"..gid), "GET", networkListener)
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
