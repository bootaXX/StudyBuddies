local composer = require ("composer")
local scene = composer.newScene()
local widget = require ("widget")
local json = require("json")

local sampNote
local titlee
local note
local uid
local username
local groupname
local gid
local rowIndex
local decresponse
local ftitle
local detail
local pmonth 
local pday 
local pyear 
local view

local months = { 'January', 'February', 'March', 'April', 'May', 'June',
		'July', 'August', 'September', 'October', 'November', 'December'}
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
				gid = gid,
				groupname = groupname
			}
		}
		composer.removeScene("viewcalendar")
		composer.gotoScene("maincalendar", options)
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

	uid = event.params.uid
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid
	rowIndex = event.params.rowIndex

	local background = display.newImageRect (sceneGroup, "background.png", display.viewableContentWidth, display.viewableContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- titlee = display.newText (sceneGroup, "Notes", display.contentCenterX, 90, native.systemFont, 50)
	-- sceneGroup:insert (titlee)
	sceneGroup:insert (myBack)
	local newCalendarView = require('newCalendarView')
	
		
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
		textNote = native.newTextBox(382, 600, 500, 200)
		textNote.isEditable = false
		textNote.size = 30
		sceneGroup:insert(textNote)

		local function networkListener( event )
		    if ( event.isError ) then
		        print( "Network error: ", event.response )
		    else
		        print ( "RESPONSE: " .. event.response )
		        decresponse = json.decode(event.response)
		        
		        detail = decresponse.plans[1].detail
		        ftitle = decresponse.plans[1].title
		        pmonth = decresponse.plans[1].month
		        pday = decresponse.plans[1].day
		        pyear = decresponse.plans[1].year
		        print( pmonth, pyear, event.response )

		        textNote.text =  detail

		        local ctr
		        if(pmonth == 'January') then 
					ctr = 1
				elseif (pmonth == 'February') then
					ctr = 2
				elseif (pmonth == 'March') then
					ctr = 3
				elseif (pmonth == 'April') then
					ctr = 4
				elseif (pmonth == 'May') then
					ctr = 5
				elseif (pmonth == 'June') then
					ctr = 6
				elseif (pmonth == 'July') then
					ctr = 7
				elseif (pmonth == 'August') then
					ctr = 8
				elseif (pmonth == 'September') then
					ctr = 9
				elseif (pmonth == 'October') then
					ctr = 10
				elseif (pmonth == 'November') then
					ctr = 11
				else 
					ctr = 12
				end 

				view  =newCalendarView.new(ctr,pyear)

		    end
		end
		network.request( "http://192.168.43.114:8080/studybuddies/groupchat/viewplans/"..gid.."/"..rowIndex, "GET", networkListener )
		-- network.request( "http://localhost:8080/studybuddies/groupchat/viewplans/"..gid.."/"..rowIndex, "GET", networkListener )

		
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
	view:removeSelf( )
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