local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local labelQuestion
local labelSubject
local labelAnswer
local textQuestion
local textAnswer
local textSubject
local question = ""
local answer = ""
local subject = ""
local uid
local username
local groupname
local gid
local UIGroup
local currIndex
local topicid
local rowIndexOfTimeline
UIGroup = display.newGroup()
UIGroup.y = -5

local function goBack()
	local options = {
		effect = "slideRight",
		time = 300,
		params = {
			uid = uid,
			username = username,
			groupname = groupname,
			gid = gid,
			rowIndexOfTimeline = rowIndexOfTimeline
		}
	}
	composer.removeScene("question")
	composer.gotoScene("timeline", options)
end

local function postQuestion( event )
	if(event.phase == "ended") then
		local function networkListener( event )
			if ( event.isError ) then
				print( "Network error: ", event.response )
			else
				print( "RESPONSE: ", event.response )
			end
		end
		print("postQuestion")
		local params = {}
		params.body = "subject="..subject.."&question="..question.."&answer="..answer.."&gid="..gid.."&username="..username.."&currIndex="..currIndex.."&topicid="..topicid
		
		network.request( ("http://192.168.43.114:8080/studybuddies/groupchat/postquestion"), "POST", networkListener, params)
		-- network.request( ("http://localhost:8080/studybuddies/groupchat/postquestion"), "POST", networkListener, params)

		local options = {
			effect = "crossFade",
			time = 300,
			params = {
				uid = uid,
				username = username,
				groupname = groupname,
				gid = gid,
				rowIndexOfTimeline = rowIndexOfTimeline
			}
		}
		composer.removeScene("question")
		composer.gotoScene("viewquestions", options)
	end
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
------------------------------------------------------------------------------------------------------------------------
local myPost = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 75,
	defaultFile = "default.png",
	overFile = "over.png",
	label = "POST",
	onEvent = postQuestion
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
	rowIndexOfTimeline = event.params.rowIndexOfTimeline
	currIndex = event.params.currIndex
	topicid = event.params.topicid

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "cool.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 150

	labelSubject = display.newText( sceneGroup, "Question Title", 240, 250, native.systemFont, 40)
	labelQuestion = display.newText( sceneGroup, "Question", 205, 390, native.systemFont, 40)
	labelAnswer = display.newText( sceneGroup, "Answer", 200, 765, native.systemFont, 40)

	sceneGroup:insert( myPost )
	sceneGroup:insert( myBack )

	UIGroup:insert(labelSubject)
	UIGroup:insert(labelQuestion)
	UIGroup:insert(labelAnswer)
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
		textSubject = native.newTextField(375, 320, 500, 60)
		textSubject:addEventListener("userInput", fieldHandler(function() return textSubject end))
		sceneGroup:insert( textSubject )
		textSubject.size = 38

		textQuestion = native.newTextBox(375, 550, 500, 260)
		textQuestion:addEventListener("userInput", fieldHandler1(function() return textQuestion end))
		sceneGroup:insert( textQuestion )
		textQuestion.isEditable = true
		textQuestion.size = 30

		textAnswer = native.newTextField(375, 820, 500, 60)
		textAnswer:addEventListener("userInput", fieldHandler1(function() return textAnswer end))
		sceneGroup:insert( textAnswer )
		textAnswer.size = 38

		UIGroup:insert(textSubject)
		UIGroup:insert(textQuestion)
		UIGroup:insert(textAnswer)

		function textSubject:userInput(event)
			if event.phase == "began" then
				event.target.text = subject
			elseif (event.phase == "ended") then
				subject = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        subject = event.newCharacters
			end
		end
		function textQuestion:userInput(event)
			if event.phase == "began" then
				event.target.text = question
			elseif (event.phase == "ended") then
				question = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        question = event.newCharacters
			end
		end
		function textAnswer:userInput(event)
			if event.phase == "began" then
				event.target.text = answer
			elseif (event.phase == "ended") then
				answer = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        answer = event.newCharacters
			end
		end
		textSubject:addEventListener("userInput", textSubject)
		textQuestion:addEventListener("userInput", textQuestion)
		textAnswer:addEventListener("userInput", textAnswer)
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
	textSubject:removeSelf()
	textSubject = nil
	textAnswer:removeSelf()
	textAnswer = nil
	textQuestion:removeSelf()
	textQuestion = nil
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
