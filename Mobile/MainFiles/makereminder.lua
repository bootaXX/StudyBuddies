local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local textDate
local textDetails
local textTitle
local textYear

local ttitle  
local tdate
local tdetails
local planIndex
local tyear


UIGroup = display.newGroup()
UIGroup.y = -5

local months = { 'January', 'February', 'March', 'April', 'May', 'June',
		'July', 'August', 'September', 'October', 'November', 'December'}
local days = {1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31}
local columnData =
{
    {
        align = "center",
        width = 120,
        labelPadding = 20,
        startIndex = 6,
        labels = months
    },
    {
        align = "center",
        width = 50,
        labelPadding = 20,
        startIndex = 6,
        labels = days
    }
}
local pickerWheel = widget.newPickerWheel(
{
	left = display.contentWidth * 0.350,
    top = display.contentHeight * 0.3,
    columns = columnData,
    style = "resizable",
    height = 100,
    width = 280,
    rowHeight = 32,
    fontSize = 25
})  

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
	composer.removeScene("makereminder")
	composer.gotoScene("maincalendar", options)
end



local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			 -- Transition group upward to y=50
        -- transition.to( UIGroup, { time=100, y=-250} )
		elseif ( "editing" == event.phase ) then

		elseif ( "submitted" == event.phase or  "ended" == event.phase ) then
            native.setKeyboardFocus( nil )
            -- Transition group back down to y=300
            -- transition.to( UIGroup, { time = 100, y = -5})
		end
	end
end
local function fieldHandler1( textField )
	return function( event )
		if ( "began" == event.phase ) then
			 -- Transition group upward to y=50
        transition.to( UIGroup, { time=100, y=-330} )
		elseif ( "editing" == event.phase ) then

		elseif ( "submitted" == event.phase or  "ended" == event.phase ) then
            native.setKeyboardFocus( nil )
            -- Transition group back down to y=300
            transition.to( UIGroup, { time = 100, y = -5})
		end
	end
end
local function post_Plans( event )
	local values = pickerWheel:getValues()
	-- Get the value for each column in the wheel, by column index
	local currentMonth = values[1].value
	local currentDay = values[2].value
	print( currentMonth, currentDay)

	if(event.phase == "ended") then
		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				
				print( "RESPONSE: ", event.response )
			end
		end
		local params = {}
		params.body = "gid="..gid.."&ptitle="..ttitle.."&month="..currentMonth.."&day="..currentDay.."&year="..tyear.."&detail="..tdetails.."&currIndex="..planIndex

		network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/postplan"), "POST", networkListener, params)
		-- network.request( ("http://localhost:8080/studybuddies/groupchat/postplan"), "POST", networkListener, params)

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
		composer.removeScene("makereminder")
		composer.gotoScene( "maincalendar", options)

	end
end
------------------------------------------------------------------------------------------------------------------------
local myCreate = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 75,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "CREATE",
	onEvent = post_Plans
}

local myBack = widget.newButton
{
	left = 125,
	top = 50,
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
	planIndex = event.params.currIndex

	local background = display.newImageRect( sceneGroup, "5.jpg", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "studyBuddies.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 150

	labelTitle = display.newText( sceneGroup, "Title : ", 195, 250, native.systemFont, 30 )
	labelSubject = display.newText( sceneGroup, "Date: ", 195, 390, native.systemFont, 30)
	labelDetails = display.newText( sceneGroup, "Details: ", 205, 550, native.systemFont, 30)

	sceneGroup:insert( myCreate )
	sceneGroup:insert( myBack )
	sceneGroup:insert(pickerWheel)

	UIGroup:insert(labelDetails)
	UIGroup:insert(myBack)
	UIGroup:insert(title)

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
		print(username)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		textTitle = native.newTextField(450, 250, 400, 50)
		textTitle:addEventListener("userInput", fieldHandler(function() return textDate end))
		sceneGroup:insert( textTitle )
		textTitle.size = 30

		textYear = native.newTextField( 500, 390, 100, 50 )
		textYear:addEventListener("userInput", fieldHandler(function() return textDate end))
		sceneGroup:insert( textYear )
		textYear.size = 20

		textDetails = native.newTextBox(400, 700, 500, 200)
		textDetails:addEventListener("userInput", fieldHandler1(function() return textDetails end))
		sceneGroup:insert( textDetails )
		textDetails.isEditable = true
		textDetails.size = 30



		UIGroup:insert(textYear)
		UIGroup:insert(textDetails)

		function textTitle:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				ttitle = event.target.text
				print(ttitle)
			elseif event.phase == "Submitted" then
			end
		end

		function textYear:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				tyear = event.target.text
				print(tyear)
			elseif event.phase == "Submitted" then
			end
		end

		function textDetails:userInput(event)
			if event.phase == "began" then
				tdetails = event.target.text
			elseif event.phase == "ended" then
				tdetails = event.target.text
				print(tdetails)
			elseif event.phase == "Submitted" then
			end
			tdetails = event.target.text
		end
		textTitle:addEventListener( "userInput", textTitle )
		textYear:addEventListener( "userInput", textYear )
		textDetails:addEventListener("userInput", textDetails)
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
	textTitle:removeSelf( )
	textTitle = nil
	textYear:removeSelf()
	textYear = nil
	textDetails:removeSelf()
	textDetails = nil
	UIGroup:removeSelf()
	UIGroup = nil
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
