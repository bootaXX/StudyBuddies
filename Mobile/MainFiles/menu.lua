
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require("json");

local jsonstr
local fin

local labelUsername
local labelPassword
local labelFeedback
local textUsername
local textPassword

local uname = ""
local pword = ""

local function gotoRegister()
    composer.gotoScene( "register", { 
    	time=300, effect="fromRight"
    })
end

local myRegister = widget.newButton
{
	left = 230,
	top = 620,
	width = 300,
	height = 50,
	defaultFile = "button2.png",
	overFile = "obutton2.png",
}

local myLogin = widget.newButton
{
	left = 230,
	top = 550,
	width = 300,
	height = 50,
	defaultFile = "button1.png",
	overFile = "obutton1.png",
}

local function onComplete( event )
	if (event.action == "clicked") then
		local i = event.index
		if(i==1) then

		elseif (i==2) then
			gotoRegister()
		end
	end
end

local function gotoLogin()
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error: ", event.response )
		else
			jsonstr = event.response
			if(jsonstr=='[]') then
				print(jsonstr)
				local alert = native.showAlert("Error on Log-in", "Invalid Username or Password", {"Ok", "Register"}, onComplete)
			else 
				local infos = json.decode(jsonstr)
				local options = {
					effect = "crossFade",
					time = 300,
					params = {
						uid = infos[1].userid,
						username = infos[1].username
					}
				}
				print(jsonstr)
				composer.gotoScene("viewgroup", options)
			end
		end
	end

	network.request( ("http://192.168.43.114:8080/studybuddies/buddy/login/"..uname.."/"..pword), "GET", networkListener)
	-- network.request( ("http://localhost:8080/studybuddies/buddy/login/"..uname.."/"..pword), "GET", networkListener)
end

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

	local background = display.newImageRect( sceneGroup, "5.jpg", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "studyBuddies.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200


	labelFeedback = display.newText( sceneGroup, "", 250, 300, native.systemFont, 28 )

	
	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
	sceneGroup:insert( myRegister )
	sceneGroup:insert( myLogin )
	myRegister:addEventListener("tap", gotoRegister)
	myLogin:addEventListener("tap", gotoLogin)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		textUsername = native.newTextField(385, 390, 400, 60)
		textUsername:addEventListener("userInput", fieldHandler(function() return textUsername end))
		textUsername.size = 38
		textUsername.placeholder = "Username"

		textPassword = native.newTextField(385, 470, 400, 60)
		textPassword:addEventListener("userInput", fieldHandler(function() return textPassword end))
		textPassword.size = 38
		textPassword.isSecure = true
		textPassword.placeholder = "Password"

		function textUsername:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif (event.phase == "ended") then
				-- uname = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        uname = uname..event.newCharacters
			end
		end

		function textPassword:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif (event.phase == "ended") then
				-- pword = event.target.text
			elseif (event.phase == "submitted") then
			elseif event.phase == "editing" then
		        pword = pword..event.newCharacters
			end
		end
		print(uname.." : "..pword)
		textUsername:addEventListener("userInput", textUsername)
		textPassword:addEventListener("userInput", textPassword)
	
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		textPassword:removeSelf()
		textPassword = nil
		textUsername:removeSelf()
		textUsername = nil
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
