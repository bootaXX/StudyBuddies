
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json")

local textNote
local username
local uid
local groupname
local gidsent
local note=""
local textTitle
local titlet=""
local currIndex
local UIGroup
UIGroup = display.newGroup()
UIGroup.y = -5

local function goMenu()
	local options = {
		effect = "slideRight",
		time = 300,
		params = {
			uid = uid,
			username = username,
			groupname = groupname,
			gid = gidsent
		}
	}
	composer.removeScene("newnote")
    composer.gotoScene( "mainnotes", options)
end

local function onComplete( event )
	if (event.action == "clicked") then
		local i = event.index
		if(i==1) then
		end
	end
end

local function handleCreateNote(event)
	if(event.phase == "ended") then
		if (titlet==nil or note==nil or titlet=="" or note=="") then
			local alert = native.showAlert("Input Error", "Invalid Input: Lacking input", {"Ok"}, onComplete)
		else
			local function networkListener( event)
				if(event.isError) then
					print( "Network error: ",event.response )
				else
					local reply = json.decode(event.response)
					local replyvalidation = reply.validation
					local replymessage = reply.message

					if(replyvalidation == "invalid") then
						local alert = native.showAlert("Error Input", replymessage, {"Ok"}, onComplete)
					else
						local alert2 = native.showAlert( "Successful", replymessage , {"Ok"},onComplete)
						print( "Response: ",event.response )
					end
					local options = {
						effect = "slideRight",
						time = 300,
						params = {
							uid = uid,
							username = username,
							groupname = groupname,
							gid = gidsent
						}
					}
					composer.removeScene("newnote")
				    composer.gotoScene( "mainnotes", options)
				end
			end
			local params = {}
			print(gidsent)
			params.body = "gid="..gidsent.."&notes="..note.."&titlee="..titlet.."&username="..username.."&currIndex="..currIndex

			network.request( ("http://192.168.43.114:8080/studybuddies/postnotes"), "POST", networkListener, params)
			-- network.request( ("http://localhost:8080/studybuddies/postnotes"), "POST", networkListener, params)
		end
	end
end
local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			transition.to( UIGroup, { time=100, y=-330} )
		elseif ( "ended" == event.phase ) then
			transition.to( UIGroup, { time = 100, y = -5})
		elseif ( "editing" == event.phase ) then
		
		elseif ( "submitted" == event.phase ) then
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
	defaultFile = "cr1.png",
	overFile = "cr2.png",
	onEvent = handleCreateNote,
}


local myBack = widget.newButton
{
	left = 125,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = goMenu,
}

function scene:create( event )

	local sceneGroup = self.view
	
	uid = event.params.uid
	username = event.params.username
	gidsent = event.params.gid
	groupname = event.params.groupname
	currIndex = event.params.currIndex

	local background = display.newImageRect( sceneGroup, "5.jpg", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "studyBuddies.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 150

	local notetitle = display.newText( sceneGroup, "Title: ", 200, 250 ,native.systemFont, 30 )
	
	sceneGroup:insert( myPost )
	sceneGroup:insert( myBack )
	sceneGroup:insert( notetitle )


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
		textTitle = native.newTextField(450, 250, 300, 50)
		textTitle.placeholder = "Title"
		textTitle:addEventListener("userInput", textTitle)
		sceneGroup:insert( textTitle )
		UIGroup:insert(textTitle)

		function textTitle:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				titlet = event.target.text
			elseif event.phase == "Submitted" then
			end
		end

		textNote = native.newTextBox(382, 600, 500, 560)
		textNote:addEventListener("userInput", fieldHandler(function() return textNote end))
		textNote.isEditable = true
		textNote.size = 20
		sceneGroup:insert(textNote)
		UIGroup:insert(textNote)

		function textNote:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				note = event.target.text
			elseif event.phase == "Submitted" then 
			end
		end
		textNote:addEventListener("userInput", textNote)
		
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
	textTitle:removeSelf()
	textTitle = nil
	textNote:removeSelf()
	textNote = nil

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
