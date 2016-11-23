local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")
local uid
local username
local groupname
local gid
local textChooseQuestion
local subject
local response1
local decodedresponse1
local response2
local decodedresponse2
local UIGroup
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

local function handleButtonEventToAnswerQuestion( event )
	local options = {
		effect = "fromRight",
		time = 300,
		params = {
			uid = uid,
			username = username,
			groupname = groupname,
			gid = gid,
			subject = subject
		}
	}
	composer.removeScene("timeline")
	composer.gotoScene("answerquestion", options)
end

local function gotoCreateQuestion(event)
	local options = {
		effect = "fromRight",
		time = 300,
		params = {
			uid = uid,
			username = username,
			groupname = groupname,
			gid = gid
		}
	}
	composer.removeScene("timeline")
	composer.gotoScene("question", options)
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

local answerQuestionButton = widget.newButton
{
	x = 600,
	y = 875,
	shape = "rect",
	id = "answer",
	label = "ANSWER",
	fontSize = 25,
	fillColor = { default={ 1, 0.5, 0.5, 0.5 }, over={ 1, 0.2, 0.5, 1 } },
	onEvent = handleButtonEventToAnswerQuestion
}

local addQuestion = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 65,
	fontSize = 25,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "ADD QUESTION",
	onEvent = gotoCreateQuestion,
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

	sceneGroup:insert(answerQuestionButton)
	sceneGroup:insert(myBack)
	sceneGroup:insert(addQuestion)
	background:addEventListener("tap", background)
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	local checker

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		textChooseQuestion = native.newTextField(300, 875, 400, 60)
		textChooseQuestion:addEventListener("userInput", fieldHandler(function() return textChooseQuestion end))
		textChooseQuestion.size = 38
		textChooseQuestion.placeholder = "Subject"
		textChooseQuestion:addEventListener("userInput", textChooseQuestion)

		function textChooseQuestion:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				subject = event.target.text
				print(subject)
			elseif event.phase == "Submitted" then
			end
		end

		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				decodedresponse1 = json.decode(event.response)
				local i=1
				while decodedresponse1.chat[i] do
					response1 = decodedresponse1.chat[i].subject
					dgroupname = display.newText( sceneGroup, response1, display.contentCenterX, 400+(30*(i-1)), native.systemFont, 30 )
					sceneGroup:insert( dgroupname )
					i = i+1
				end
				checker = i
			end
		end
		-- network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/viewquestions/"..gid), "GET", networkListener)
		network.request( ("http://localhost:8080/studybuddies/groupchat/viewquestions/"..gid), "GET", networkListener)
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
	textChooseQuestion:removeSelf()
	textChooseQuestion = nil
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
