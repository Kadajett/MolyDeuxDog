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



	--------
	-- *** Create the background and Restart/Menu Button ***
	--------
	--Background image first...
	local bg1 = display.newImageRect( "images/gameOver.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
	mainGroup:insert(bg1)
	
	--Restart/Menu button
	local function gotoGame() director:changeScene("game", "moveFromRight") end
	local playGame = display.newRect(0,0, 280, 80)
	playGame.x = _W*0.5; playGame.y = _H*0.66; playGame.alpha = 0.01
	playGame:addEventListener("tap", gotoGame)
	mainGroup:insert(playGame)
	
	local function gotoMenu() director:changeScene("menu", "moveFromLeft") end
	local menu = display.newRect(0,0, 80, 30)
	menu.x = 40; menu.y = _H-24; menu.alpha = 0.01
	menu:addEventListener("tap", gotoMenu)
	mainGroup:insert(menu)



	---------
	--Clean function...
	---------
	local function clean()
		--Nothing needs to be cleaned.
	end
	M.clean=clean

	return mainGroup
end
M.new = new

return M