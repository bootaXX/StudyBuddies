local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local 

-- ************************************************************
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

local myAdd = widget.newButton
{
	left = 250,
	top = 900,
	width = 250,
	height = 75,
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