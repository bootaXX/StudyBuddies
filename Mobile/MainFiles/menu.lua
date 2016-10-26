
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

local uname 
local pword 

local function gotoRegister()
	composer.removeScene("register")
    composer.gotoScene( "register", { time=800, effect="crossFade" })
end

local function onComplete( event )
	if (event.action == "clicked") then
		local i = event.index
		if(i==1) then

		elseif (i==2) then
			composer.removeScene("register")
			composer.gotoScene("register")
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
					time = 800,
					params = {
						uid = infos[1].userid,
						username = infos[1].username
					}
				}
				print(jsonstr)
				composer.removeScene("viewgroup")
				composer.gotoScene("viewgroup", options)
			end
		end
	end

	-- network.request( ("http://192.168.43.114:8080/studybuddies/buddy/login/"..uname.."/"..pword), "GET", networkListener)
	network.request( ("http://localhost:8080/studybuddies/buddy/login/"..uname.."/"..pword), "GET", networkListener)
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

	local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "study.png", 500, 80 )
	title.x = display.contentCenterX
	title.y = 200


	labelUsername = display.newText( sceneGroup, "Username:", 375, 400, native.systemFont, 40)
	sceneGroup:insert( labelUsername )

	labelPassword = display.newText( sceneGroup, "Password:", 375, 545, native.systemFont, 40)
	sceneGroup:insert( labelPassword )	

	
	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
	
	local loginButton = display.newText( sceneGroup, "Login", display.contentCenterX, 700, native.systemFont, 44 )
	loginButton:setFillColor( 0.82, 0.86, 1 )

	local registerButton = display.newText( sceneGroup, "Register", display.contentCenterX, 810, native.systemFont, 44 )
	registerButton:setFillColor( 0.75, 0.78, 1 )

	registerButton:addEventListener("tap", gotoRegister)
	loginButton:addEventListener("tap", gotoLogin)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		textUsername = native.newTextField(375, 470, 500, 60)
		textUsername:addEventListener("userInput", fieldHandler(function() return textUsername end))
		sceneGroup:insert( textUsername )
		textUsername.size = 38
		textUsername.placeholder = "Username"

		textPassword = native.newTextField(375, 610, 500, 60)
		textPassword:addEventListener("userInput", fieldHandler(function() return textPassword end))
		sceneGroup:insert( textPassword )
		textPassword.size = 38
		textPassword.isSecure = true
		textPassword.placeholder = "Password"

		function textUsername:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				uname = event.target.text
				print(uname)
			elseif event.phase == "Submitted" then
			end
		end

		function textPassword:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
			elseif event.phase == "ended" then
				pword = event.target.text
				print(pword)
			elseif event.phase == "Submitted" then
			end
		end

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
