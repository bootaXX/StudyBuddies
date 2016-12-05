local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local uid
local username
local groupname
local gid
local currIndex
local rowIndex
local topic
local textTopic
-- ************************************************************
local function addTopic()
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error: ", event.response )
		else
			print ( "RESPONSE: " .. event.response )
		end
	end
	local params = {}
	params.body = "gid="..gid.."&topic="..topic.."&rowIndex="..rowIndex
	network.request( "http://192.168.43.114:8080/studybuddies/groupchat/questions/addtopic", "POST", networkListener, params)
	-- network.request( "http://localhost:8080/studybuddies/groupchat/questions/addtopic", "POST", networkListener, params)
	goBack()
end

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
	composer.removeScene("question")
	composer.gotoScene("timeline", options)
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
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
	end
end

local myAdd = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 75,
	fontSize = 25,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "ADD",
	onEvent = addTopic
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
-- ************************************************************

function scene:create( event )
	local sceneGroup = self.view

	uid = event.params.uid
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid
	currIndex = event.params.currIndex
	rowIndex = currIndex

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "cool.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200

	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end
	background:addEventListener("tap", background)
	sceneGroup:insert(myAdd)
	sceneGroup:insert(myBack)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if(phase == will) then
	-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif (phase == did) then
	-- Code here runs when the scene is entirely on screen
		textTopic = native.newTextField(375, 370, 500, 60)
		textTopic:addEventListener("userInput", fieldHandler(function() return textTopic end))
		textTopic.size = 38
		textTopic.placeholder = "Group name"

		function textTopic:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				topic = event.target.text
			elseif event.phase == "Submitted" then
			end
		end
		textTopic:addEventListener("userInput", textTopic)
	end
	-- body
end

function scene:hide( event )
	if (phase == will) then

	elseif (phase == did) then

	end
	-- body
end

function scene:destroy( event )
	-- body
	textTopic:removeSelf()
	textTopic = nil
end