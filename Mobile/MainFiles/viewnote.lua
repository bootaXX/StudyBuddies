local composer = require ("composer")
local scene = composer.newScene()
local widget = require ("widget")
local json = require("json")
local lfs = require "lfs"

local sampNote
local titlee
local note
local uid
local username
local groupname
local gid
local rowIndex
local decresponse
local ftitle
---------------------------------------------------------------------------------------------------------
local function handleButtonEventGoBack( event )
	local phase = event.phase

	if "ended" == phase then
		local options = {
			effect = "slideRight",
			time = 300,
			params = {
				uid = uid,
				username = username,
				gid = gid,
				groupname = groupname
			}
		}
		composer.removeScene("viewnote")
		composer.gotoScene("mainnotes", options)
	end
end
---------------------------------------------------------------------------------------------------------
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
local export = widget.newButton
{
	left = 600,
	top = 50,
	width = 50,
	height = 45,
	defaultFile = "back.png",
	overFile = "back2.png",
	onEvent = handleButtonEventGoBack
}
----------------------------------------------------------------------------------------------------------

function scene:create (event)

	-- get raw path to app's Documents directory
	local docs_path = system.pathForFile( "", system.ResourceDirectory )

	-- change current working directory
	local success = lfs.chdir( docs_path ) -- returns true on success
	local new_folder_path
	local dname = "Images"
	if success then
	    lfs.mkdir( dname )
	    new_folder_path = lfs.currentdir() .. "/" .. dname
	end

	local sceneGroup = self.view

	uid = event.params.uid
	username = event.params.username
	groupname = event.params.groupname
	gid = event.params.gid
	rowIndex = event.params.rowIndex

	local background = display.newImageRect (sceneGroup, "background.png", display.viewableContentWidth, display.viewableContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	titlee = display.newText (sceneGroup, "Notes", display.contentCenterX, 90, native.systemFont, 50)
	sceneGroup:insert (titlee)
	sceneGroup:insert (myBack)
	sceneGroup:insert (export)
		
	function  background:tap(event)
		native.setKeyboardFocus( nil )
	end

	background:addEventListener("tap", background)
end

function scene:show ( event )

	local sceneGroup = self.view 
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then 
		textNote = native.newTextBox(382, 600, 500, 560)
		textNote.isEditable = false
		textNote.size = 30
		sceneGroup:insert(textNote)

		local function networkListener( event )
		    if ( event.isError ) then
		        print( "Network error: ", event.response )
		    else
		        print ( "RESPONSE: " .. event.response )
		        decresponse = json.decode(event.response)
		        note = decresponse.notes[1].notes
		        textNote.text = note
		        ftitle = decresponse.notes[1].title

		        local path = system.pathForFile(ftitle..".txt", system.DocumentsDirectory)
		        --Open file handle
		        local file, errorString = io.open(path,"w")
		        if not file then
		        	print("File error"..errorString)
		        else
		        	file:write(note)
		        	io.close(file)
		        end
		        file = nil
		    end
		end
		network.request( "http://192.168.43.114:8080/studybuddies/groupchat/viewnotes/"..gid.."/"..rowIndex, "GET", networkListener )
		-- network.request( "http://localhost:8080/studybuddies/groupchat/viewnotes/"..gid.."/"..rowIndex, "GET", networkListener )
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
