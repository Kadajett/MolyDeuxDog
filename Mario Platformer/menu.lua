-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Jamie Trinder
--www.tandgapps.co.uk

--CoronaSDK version 2012.971 was used for this template.

--The art was sourced from www.vickiwenderlich.com 
--A great site for free art assets

--You are not allowed to publish this template to the Appstore as it is. 
--You need to work on it, improve it and replace a lot of the graphics. 

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------


local M = {}

local function new()  
	--Setup the display groups we want
	local mainGroup = display.newGroup()

	--Set up our basic maths variables
	local _W = display.contentWidth --Width and height parameters
	local _H = display.contentHeight 

	--Set up some of the sounds we want to use....
	--You have to properly remove these.. check the clean funciton.
	local tapChannel --Used later to get an audio channel
	local tapSound = audio.loadSound("sounds/tapsound.wav")



	--------
	-- *** Create the background and Play Button ***
	-------
	--Background images first...
	local bg1 = display.newImageRect( "images/mainMenu.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
	mainGroup:insert(bg1)


	--Play Game button
	local function startGame()
		tapChannel = audio.play( tapSound )
		director:changeScene("levelSelect", "moveFromRight")
	end
	local playGame = display.newRect(0,0, 120, 60)
	playGame.x = _W*0.5; playGame.y = _H*0.8; playGame.alpha = 0.01
	playGame:addEventListener("tap", startGame)
	mainGroup:insert(playGame)
	


	---------
	--Clean function...
	------
	local function clean()
		--Remove any sound effects.
		--They must NOT be playing to be removed.
		audio.dispose( tapSound ); tapSound = nil;
	end
	M.clean=clean


	return mainGroup
end
M.new = new

return M