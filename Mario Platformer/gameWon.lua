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
	-- *** Check to see if we got a highscore.. ***
	--------
	--Get the highest score that we had previously.
	local highScore = 0
	local dbPath = system.pathForFile("levelScores.db3", system.DocumentsDirectory)
	local db = sqlite3.open( dbPath )	
	for row in db:nrows("SELECT * FROM scores WHERE id = "..currentLevel) do
		highScore = tonumber(row.highscore)
	end
	
	--Compare what we got this level and save it if its higher..
	if levelScore > highScore then
		highScore = levelScore
		local update = "UPDATE scores SET highscore ='"..levelScore.."' WHERE id = "..currentLevel
		db:exec(update)
	end
	db:close()



	--------
	-- *** Iterate the currentLevel
	--This is done so that when we press next it will go to the next level
	--------
	currentLevel = currentLevel + 1 --Our global var from the main.lua



	--------
	-- *** Create the background and Next/menu Buttons ***
	--------
	--Background images first...
	local bg1 = display.newImageRect( "images/gameWon.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
	mainGroup:insert(bg1)
	
	--Next level/Menu button
	local function gotoGame() 
		if currentLevel > amountofLevels then director:changeScene("menu", "moveFromLeft")
		else director:changeScene("game", "moveFromRight") end
	end
	local nextBtn = display.newRect(0,0, 280, 80)
	nextBtn.x = _W*0.5; nextBtn.y = _H*0.72; nextBtn.alpha = 0.01
	nextBtn:addEventListener("tap", gotoGame)
	mainGroup:insert(nextBtn)
	
	local function gotoMenu() director:changeScene("menu", "moveFromLeft") end
	local menu = display.newRect(0,0, 80, 30)
	menu.x = 40; menu.y = _H-24; menu.alpha = 0.01
	menu:addEventListener("tap", gotoMenu)
	mainGroup:insert(menu)
	

	--Now show the score text and highscore text...
	local score1 = display.newText(mainGroup, levelScore, 0,0, native.systemFontBold, 18)
	score1:setReferencePoint(display.CenterLeftReferencePoint); score1:setTextColor(40)
	score1.x = (_W*0.5)+10; score1.y = _H*0.472

	local score2 = display.newText(mainGroup, highScore, 0,0, native.systemFontBold, 18)
	score2:setReferencePoint(display.CenterLeftReferencePoint); score2:setTextColor(40)
	score2.x = (_W*0.5)+10; score2.y = _H*0.57




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