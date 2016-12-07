
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require( "json" )
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
local currIndex
-----------------------------------------------------------------------------------------------------------------------
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
		composer.removeScene("maincalendar")
		composer.gotoScene("choice", options)
	end
end
local function handleButtonEventCreateReminder( event )
	-- body
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
	composer.removeScene("maincalendar")
	composer.gotoScene("makereminder", options)

end

local function handleButtonEventViewCalendar( event , rowIndex)
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
	composer.removeScene("maincalendar")
	composer.gotoScene("viewcalendar", options)
end

local myPost = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 75,
	defaultFile = "ap1.png",
	overFile = "ap2.png",
	onEvent = handleButtonEventCreateReminder,
}
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
	local background = display.newImageRect( sceneGroup, "5.jpg", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Create calendar widget
	local newCalendarView = require('newCalendarView')
	view = newCalendarView.new(month, year)

	sceneGroup:insert( myPost )
	sceneGroup:insert (myBack)


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
		print(month)
		print(year)
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
				fontSize = 30
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
				handleButtonEventViewCalendar(event, row.index)
			end
		end

		local myTable = widget.newTableView {
			width = display.viewableContentWidth * 0.90,
			height = display.viewableContentHeight * 0.40,
			x = display.contentCenterX,
			y = 650,
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
				while decodedresponse1.plans[i] do
					response1 = decodedresponse1.plans[i].title
					myTable:insertRow{}
					i = i+1
				end
				currIndex = i
			end
		end
		network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/viewlistplans/"..gid), "GET", networkListener)
		-- network.request( ("http://localhost:8080/studybuddies/groupchat/viewlistplans/"..gid), "GET", networkListener)

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
