local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

-- ************************************************************
-- functions
-- ************************************************************

function scene:create( event )
	-- body
end

function scene:show( event )
	phase = will{

	}
	phase = did{

	}
	-- body
end

function scene:hide( event )
	phase = will{

	}
	phase = did{

	}
	-- body
end

function scene:destroy( event )
	-- body
end

uidd = event.params.uid -- userid of current user, gikan sa previous ni
usernamee = event.params.username -- username of current user, gikan sa previous ni

local function gotoCreateGroupChat()
	composer.removeScene( "creategroupchat" )
	local options = {
		effect = "crossFade",
		time = 600,
		params = {					-- ing.ani pagpasa
			uid = uidd,
			username = usernamee
		}
	}
    composer.gotoScene( "creategroupchat", options)
end