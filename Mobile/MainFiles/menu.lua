
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

-- local function gotoLoginPost()
-- 	print ("test")
	
-- 	sendInfo = {["asked"] = 5, ["correct"] = 3, ["wrong"] = 2}

-- 	print(sendInfo)

-- 	local function networkListener( event )
-- 		if ( event.isError ) then
-- 			print( "Network error!" )
-- 		else
-- 			print( "RESPONSE: "..event.response )
-- 		end
-- 	end

-- 	local headers = {
-- 	["Content-Tpe"] = "application/json", 
-- 	["Accept-Language"] = "en-US"
-- 	}

-- 	local params = {}
	
-- 	params.headers = headers
-- 	params.body = json.encode( sendInfo )
	
-- 	print( "params.body: "..params.body )

-- 	network.request( "/loginpost", "POST", networkListener, params)
-- end
local function gotoLogin()
	
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error: ", event.response )
		else
			jsonstr = event.response
			if(jsonstr=='[]') then
				print(jsonstr)
				scene:addEventListener( "create", scene )
				scene:addEventListener( "show", scene )
			else 
				print(jsonstr)
				composer.removeScene( "login" )
				composer.gotoScene("login",{ time=800, effect="crossFade" })
			end
		end
	end

	network.request( ("http://localhost:8080/login/"..uname.."/"..pword), "GET", networkListener)

    -- composer.gotoScene( "login", { time=800, effect="crossFade" })
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
	textUsername = native.newTextField(375, 470, 500, 60)
	sceneGroup:insert( textUsername )
	textUsername.size = 38

	labelPassword = display.newText( sceneGroup, "Password:", 375, 545, native.systemFont, 40)
	textPassword = native.newTextField(375, 610, 500, 60)
	sceneGroup:insert( textPassword )
	textPassword.size = 38
	textPassword.isSecure = true


	labelFeedback = display.newText( sceneGroup, "", 250, 300, native.systemFont, 28 )

	

	
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
		function textUsername:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
				--labelFeedback.text = "waiting"
			elseif event.phase == "ended" then
				uname = event.target.text
				print(uname)
				--labelFeedback.text = "Thank you" .. " " .. event.target.text
			elseif event.phase == "Submitted" then
				--	labelFeedback.text = "Hello".. " " .. event.target.text
				--elseif event.phase == "editing" then
				-- labelFeedback.text = event.startPosition
			end
		end

		function textPassword:userInput(event)
			if event.phase == "began" then
				event.target.text = ''
				--labelFeedback.text = "waiting"
			elseif event.phase == "ended" then
				pword = event.target.text
				print(pword)
				--labelFeedback.text = "Thank you" .. " " .. event.target.text
			elseif event.phase == "Submitted" then
				--labelFeedback.text = "Hello".. " " .. event.target.text
			--elseif event.phase == "editing" then
				--labelFeedback.text = event.startPosition
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
