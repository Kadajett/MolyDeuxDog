
local M = {}


--====================================================================--
-- DIRECTOR CLASS
--====================================================================--
print( "-----------------------------------------------" )
showDebug = false
local _W = display.contentWidth
local _H = display.contentHeight

--====================================================================--
-- DISPLAY GROUPS
--====================================================================--

local directorView = display.newGroup()
M.directorView = directorView

--
local currView       = display.newGroup()
local prevView       = display.newGroup()
local nextView       = display.newGroup()
local protectionView = display.newGroup()
local effectView     = display.newGroup()
--
local initViews = function()
	directorView:insert( currView )
	directorView:insert( prevView )
	directorView:insert( nextView )
	directorView:insert( protectionView )
	directorView:insert( effectView )
end

--====================================================================--
-- VARIABLES
--====================================================================--

local prevScreen, currScreen, nextScreen, popupScreen
local prevScene, currScene, nextScene = "main", "main", "main"
local newScene
local fxTime = 500
local safeDelay = 50
local isChangingScene = false

prevView.x = -_W
prevView.y = 0
currView.x = 0
currView.y = 0
nextView.x = _W
nextView.y = 0

--====================================================================--
-- SHOW ERRORS
--====================================================================--

local showError = function( errorMessage, debugMessage )
	local message = "ERROR: " .. tostring( errorMessage )
	local function onComplete( event )
		print()
		print( "-----------------------" )
		print( message )
		print( "-----------------------" )
		print( debugMessage )
		print( "-----------------------" )
		error()
	end
	--
	if showDebug then
		local alert = native.showAlert( "Error/Bug: Please contact support", message, { "OK" }, onComplete )
	else
		onComplete()
	end
end

--====================================================================--
-- GARBAGE COLLECTOR
--====================================================================--

local garbageCollect = function( event )
	collectgarbage( "collect" )
end

--====================================================================--
-- IS DISPLAY OBJECT ?
--====================================================================--

local coronaMetaTable = getmetatable( display.getCurrentStage() )
--
local isDisplayObject = function( aDisplayObject )
	return( type( aDisplayObject ) == "table" and getmetatable( aDisplayObject ) == coronaMetaTable )
end

--====================================================================--
-- PROTECTION
--====================================================================--

------------------
-- Rectangle
------------------

local protection = display.newRect( -_W, -_H, _W * 3, _H * 3 )
protection:setFillColor( 255, 255, 255 )
protection.alpha = 0.01
protection.isVisible = false
protectionView:insert( protection )

------------------
-- Listener
------------------

local fncProtection = function( event )
	return true
end
protection:addEventListener( "touch", fncProtection )
protection:addEventListener( "tap", fncProtection )

--====================================================================--
-- REBUILD GROUP
--====================================================================--
local rebuildGroup = function( target )
	
	------------------
	-- Verify which group
	------------------
	
	-- Prev
	if target == "prev" then
		
		------------------
		-- Clean Group
		------------------
		
		prevView:removeSelf()
		
		------------------
		-- Search for the localGroup.clean() function
		------------------
		
		if prevScreen then
			if prevScreen.clean then
				
				------------------
				-- Clean Object
				------------------
				
				local handler, message = pcall( prevScreen.clean )
				--
				if not handler then
					showError( "Failed to clean object '" .. prevScene .. "' - Please verify the localGroup.clean() function.", message )
					return false
				end
			
			end
			
		end
		
		------------------
		-- Create Group
		------------------
		
		prevView = display.newGroup()
		
	-- Curr
	elseif target == "curr" then
		
		------------------
		-- Clean Group
		------------------
		
		currView:removeSelf()
		
		------------------
		-- Search for the localGroup.clean() function
		------------------
		
		if currScreen then
			if currScreen.clean then
				
				------------------
				-- Clean Object
				------------------
				
				local handler, message = pcall( currScreen.clean )
				--
				if not handler then
					showError( "Failed to clean object '" .. currScene .. "' - Please verify the localGroup.clean() function.", message )
					return false
				end
			
			end
			
		end
		
		------------------
		-- Create Group
		------------------
		
		currView = display.newGroup()
		
	-- Next
	elseif target == "next" then
		
		------------------
		-- Clean Group
		------------------
		
		nextView:removeSelf()
		
		------------------
		-- Search for the localGroup.clean() function
		------------------
		
		if nextScreen then
			if nextScreen.clean then
				
				------------------
				-- Clean Object
				------------------
				
				local handler, message = pcall( nextScreen.clean )
				--
				if not handler then
					showError( "Failed to clean object '" .. nextScene .. "' - Please verify the localGroup.clean() function.", message )
					return false
				end
			
			end
			
		end
		
		------------------
		-- Create Group
		------------------
		
		nextView = display.newGroup()
	end
	
	------------------
	-- Init
	------------------
	
	initViews()
	
end


--====================================================================--
-- INITIATE VARIABLES
--====================================================================--
local initVars = function( target )
	
	------------------
	-- Verify which group
	------------------
	
	-- Prev
	if target == "prev" then
		
		------------------
		-- Search for the localGroup.initVars() function
		------------------
		
		if prevScreen then
			if prevScreen.initVars then
				
				------------------
				-- Init Vars
				------------------
				
				local handler, message = pcall( prevScreen.initVars )
				--
				if not handler then
					showError( "Failed to initiate variables of object '" .. prevScene .. "' - Please verify the localGroup.initVars() function.", message )
					return false
				end
			
			end
		end
		
	-- Curr
	elseif target == "curr" then
		
		------------------
		-- Search for the localGroup.initVars() function
		------------------
		
		if currScreen then
			if currScreen.initVars then
				
				------------------
				-- Init Vars
				------------------
				
				local handler, message = pcall( currScreen.initVars )
				--
				if not handler then
					showError( "Failed to initiate variables of object '" .. currScene .. "' - Please verify the localGroup.initVars() function.", message )
					return false
				end
			
			end
			
		end
		
	-- Next
	elseif target == "next" then
		
		------------------
		-- Search for the localGroup.initVars() function
		------------------
		
		if nextScreen then
			if nextScreen.initVars then
				
				------------------
				-- Init Vars
				------------------
				
				local handler, message = pcall( nextScreen.initVars )
				--
				if not handler then
					showError( "Failed to initiate variables of object '" .. nextScene .. "' - Please verify the localGroup.initVars() function.", message )
					return false
				end
			
			end
			
		end
	
	end
	
end


--====================================================================--
-- UNLOAD SCENE
--====================================================================--
local unloadScene = function( moduleName )
	
	------------------
	-- Test parameters
	------------------
	
	if moduleName ~= "main" then
		
		------------------
		-- Verify if it was loaded
		------------------
		
		if type( package.loaded[ moduleName ] ) ~= "nil" then
			
			------------------
			-- Search for the clean() function
			------------------
			
			if package.loaded[ moduleName ].clean then
				
				------------------
				-- Execute
				------------------
				
				local handler, message = pcall( package.loaded[ moduleName ].clean )
				--
				if not handler then
					showError( "Failed to clean module '" .. moduleName .. "' - Please verify the clean() function.", message )
					return false
				end
				
			end
			
			------------------
			-- Try to free memory
			------------------
			
			package.loaded[ moduleName ] = nil
			--
			local function garbage( event )
				garbageCollect()
			end
			--
			timer.performWithDelay( fxTime, garbage )
			
		end
		
	end
	
end


--====================================================================--
-- LOAD SCENE
--====================================================================--
local loadScene = function( moduleName, target, params )
	
	------------------
	-- Test parameters
	------------------
	
	if type( moduleName ) ~= "string" then
		showError( "Module name must be a string. moduleName = " .. tostring( moduleName ) )
		return false
	end
	
	------------------
	-- Load Module
	------------------
	
	if not package.loaded[ moduleName ] then
		local handler, message = pcall( require, moduleName )
		if not handler then
			showError( "Failed to load module '" .. moduleName .. "' - Please check if the file exists and it is correct.", message )
			return false
		end
	end
	
	------------------
	-- Serach new() Function
	------------------
	
	if not package.loaded[ moduleName ].new then
		showError( "Module '" .. tostring( moduleName ) .. "' must have a new() function." )
		return false
	end
	--
	local functionName = package.loaded[ moduleName ].new
	
	------------------
	-- Variables
	------------------
	
	local handler
	
	------------------
	-- Load choosed scene
	------------------
	
	-- Prev
	if string.lower( target ) == "prev" then
		
		------------------
		-- Rebuild Group
		------------------
		
		rebuildGroup( "prev" )
		
		------------------
		-- Unload Scene
		------------------
		
		if prevScene ~= currScene and prevScene ~= nextScene then
			unloadScene( moduleName )
		end
		
		------------------
		-- Start Scene
		------------------
		
		handler, prevScreen = pcall( functionName, params )
		--
		if not handler then
			showError( "Failed to execute new( params ) function on '" .. tostring( moduleName ) .. "'.", prevScreen )
			return false
		end
		
		------------------
		-- Check if it returned an object
		------------------
		
		if not isDisplayObject( currScreen ) then
			showError( "Module " .. moduleName .. " must return a display.newGroup()." )
			return false
		end
		
		------------------
		-- Finish
		------------------
		
		prevView:insert( prevScreen )
		prevScene = moduleName
		
		------------------
		-- Initiate Variables
		------------------
		
		initVars( "prev" )
		
	-- Curr
	elseif string.lower( target ) == "curr" then
		
		------------------
		-- Rebuild Group
		------------------
		
		rebuildGroup( "curr" )
		
		------------------
		-- Unload Scene
		------------------
		
		if prevScene ~= currScene and currScene ~= nextScene then
			unloadScene( moduleName )
		end
		
		------------------
		-- Start Scene
		------------------
		
		handler, currScreen = pcall( functionName, params )
		--
		if not handler then
			showError( "Failed to execute new( params ) function on '" .. tostring( moduleName ) .. "'.", currScreen )
			return false
		end
		
		------------------
		-- Check if it returned an object
		------------------
		
		if not isDisplayObject( currScreen ) then
			showError( "Module " .. moduleName .. " must return a display.newGroup()." )
			return false
		end
		
		------------------
		-- Finish
		------------------
		
		currView:insert( currScreen )
		currScene = moduleName
		
		------------------
		-- Initiate Variables
		------------------
		
		initVars( "curr" )
		
	-- Next
	else
		
		------------------
		-- Rebuild Group
		------------------
		
		rebuildGroup( "next" )
		
		------------------
		-- Unload Scene
		------------------
		
		if prevScene ~= nextScene and currScene ~= nextScene then
	 		unloadScene( moduleName )
	 	end
		
		------------------
		-- Start Scene
		------------------
		
		handler, nextScreen = pcall( functionName, params )
		--
		if not handler then
			showError( "Failed to execute new( params ) function on '" .. tostring( moduleName ) .. "'.", nextScreen )
			return false
		end
		
		------------------
		-- Check if it returned an object
		------------------
		
		if not isDisplayObject( nextScreen ) then
			showError( "Module " .. moduleName .. " must return a display.newGroup()." )
			return false
		end
		
		------------------
		-- Finish
		------------------
		
		nextView:insert( nextScreen )
		nextScene = moduleName
		
		------------------
		-- Initiate Variables
		------------------
		
		initVars( "next" )
		
	end
	
	------------------
	-- Return
	------------------
	
	return true
	
end


------------------
-- Load prev screen
------------------
local loadPrevScene = function( moduleName, params )
	loadScene( moduleName, "prev", params )
	prevView.x = -_W
end


------------------
-- Load curr screen
------------------
local loadCurrScene = function( moduleName, params )
	loadScene( moduleName, "curr", params )
	currView.x = 0
end


------------------
-- Load next screen
------------------
local loadNextScene = function( moduleName, params )
	loadScene( moduleName, "next", params )
	nextView.x = _W
end


--====================================================================--
-- EFFECT ENDED
--====================================================================--
local fxEnded = function( event )
	
	------------------
	-- Reset current view
	------------------
	
	currView.x = 0
	currView.y = 0
	currView.xScale = 1
	currView.yScale = 1
	
	------------------
	-- Rebuild Group
	------------------
	
	rebuildGroup( "curr" )
	
	------------------
	-- Unload scene
	------------------
	
	if currScene ~= nextScene then
		unloadScene( currScene )
	end
	
	------------------
	-- Next -> Current
	------------------
	
	currScreen = nextScreen
	currScene = newScene
	currView:insert( currScreen )
	
	------------------
	-- Reset next view
	------------------
	
	nextView.x = _W
	nextView.y = 0
	nextView.xScale = 1
	nextView.yScale = 1
	nextScene = "main"
	nextScreen = nil
	
	------------------
	-- Finish
	------------------
	
	isChangingScene = false
	protection.isVisible = false
	
	------------------
	-- Return
	------------------
	
	return true
	
end


--====================================================================--
-- CHANGE SCENE
--====================================================================--	
local function changeScene( params,
							   nextLoadScene,
							   effect,
							   arg1,
							   arg2,
							   arg3 )
	
	------------------
	-- If is changing scene, return without do anything
	------------------
	
	if isChangingScene then
		return true
	else
		isChangingScene = true
	end
	
	------------------
	-- Test parameters
	------------------
	
	if type( params ) ~= "table" then
		arg3 = arg2
		arg2 = arg1
		arg1 = effect
		effect = nextLoadScene
		nextLoadScene = params
		params = nil
	end
	--
	if type( nextLoadScene ) ~= "string" then
		showError( "The scene name must be a string. scene = " .. tostring( nextLoadScene ) )
		return false
	end
	
	------------------
	-- Verify objects on current stage
	------------------
	
	local currentStage = display.getCurrentStage()
	--
	for i = currentStage.numChildren, 1, -1 do
		
		------------------
		-- Verify directorId
		------------------
	
		if type( currentStage[i].directorId ) == "nil" then
			currentStage[i].directorId = currScene
		end
		
		------------------
		-- Insert into the CURR group if it's needed
		------------------
	
		if currentStage[i].directorId == currScene
		and currentStage[i].directorId ~= "main" then			
			currScreen:insert( currentStage[i] )
		end
		
	end
	
	------------------
	-- Prevent change to main
	------------------
	
	if nextLoadScene == "main" then
		return true
	end
	
	------------------
	-- Protection
	------------------
	
	protection.isVisible = true
	
	------------------
	-- Variables
	------------------
	
	newScene = nextLoadScene
	local showFx
	
	------------------
	-- Load Scene
	------------------
	
	loadNextScene( newScene, params )
	
	------------------
	-- Verify objects on current stage
	------------------
	
	for i = currentStage.numChildren, 1, -1 do
		
		------------------
		-- Verify directorId
		------------------
	
		if type( currentStage[i].directorId ) == "nil" then
			currentStage[i].directorId = newScene
		end
		
		------------------
		-- Insert into the NEXT group if it's needed
		------------------
	
		if currentStage[i].directorId == newScene
		and currentStage[i].directorId ~= "main" then			
			nextScreen:insert( currentStage[i] )
		end
		
	end
	
	------------------
	-- EFFECT: Move From Right
	------------------
	
	if effect == "moveFromRight" then
		
		nextView.x = _W
		nextView.y = 0
		--
		showFx = transition.to( nextView, { x = 0,   time = fxTime } )
		showFx = transition.to( currView, { x = -_W, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Over From Right
	------------------
	
	elseif effect == "overFromRight" then
		
		nextView.x = _W
		nextView.y = 0
		--
		showFx = transition.to( nextView, { x = 0, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Move From Left
	------------------
	
	elseif effect == "moveFromLeft" then
		
		nextView.x = -_W
		nextView.y = 0
		--
		showFx = transition.to( nextView, { x = 0,  time = fxTime } )
		showFx = transition.to( currView, { x = _W, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Over From Left
	------------------
	
	elseif effect == "overFromLeft" then
		
		nextView.x = -_W
		nextView.y = 0
		--
		showFx = transition.to( nextView, { x = 0, time = fxTime, onComplete = fxEnded } )
		
	------------------
	-- EFFECT: Move From Top
	------------------
	
	elseif effect == "moveFromTop" then
		
		nextView.x = 0
		nextView.y = -_H
		--
		showFx = transition.to( nextView, { y = 0,  time = fxTime } )
		showFx = transition.to( currView, { y = _H, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Over From Top
	------------------
	
	elseif effect == "overFromTop" then
		
		nextView.x = 0
		nextView.y = -_H
		--
		showFx = transition.to( nextView, { y = 0, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Move From Bottom
	------------------
	
	elseif effect == "moveFromBottom" then
		
		nextView.x = 0
		nextView.y = _H
		--
		showFx = transition.to( nextView, { y = 0,   time = fxTime } )
		showFx = transition.to( currView, { y = -_H, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Over From Bottom
	------------------
	
	elseif effect == "overFromBottom" then
		
		nextView.x = 0
		nextView.y = _H
		--
		showFx = transition.to( nextView, { y = 0, time = fxTime, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Crossfade
	------------------
	
	elseif effect == "crossfade" then
		
		nextView.x = 0
		nextView.y = 0
		--
		nextView.alpha = 0
		--
		showFx = transition.to( currView, { alpha = 0, time = fxTime * 2 } )
		showFx = transition.to( nextView, { alpha = 1, time = fxTime * 2, onComplete = fxEnded } )
	
	------------------
	-- EFFECT: Fade
	------------------
	-- ARG1 = color [ string ]
	------------------
	-- ARG1 = red   [ number ]
	-- ARG2 = green [ number ]
	-- ARG3 = blue  [ number ]
	------------------
	
	elseif effect == "fade" then
		
		nextView.x = _W
		nextView.y = 0
		--
		local fade = display.newRect( -_W, -_H, _W * 3, _H * 3 )
		fade.alpha = 0
		fade:setFillColor( 0,0,0 )
		effectView:insert( fade )
		--
		local function returnFade( event )
			currView.x = _W
			nextView.x = 0
			--
			local function removeFade( event )
				fade:removeSelf()
				fxEnded()
			end
			--
			showFx = transition.to( fade, { alpha = 0, time = fxTime, onComplete = removeFade } )
		end
		--
		showFx = transition.to( fade, { alpha = 1.0, time = fxTime, onComplete = returnFade } )
	
	------------------
	-- EFFECT: Flip
	------------------
	
	elseif effect == "flip" then
		
		nextView.xScale = 0.001
		--
		nextView.x = _W / 2
		--
		local phase1, phase2
		--
		showFx = transition.to( currView, { xScale = 0.001,  time = fxTime } )
		showFx = transition.to( currView, { x      = _W / 2, time = fxTime } )
		--
		phase1 = function( e )
			showFx = transition.to( nextView, { xScale = 0.001, x = _W / 2, time = fxTime, onComplete = phase2 } )
		end
		--
		phase2 = function( e )
			showFx = transition.to( nextView, { xScale = 1, x = 0, time = fxTime, onComplete = fxEnded } )
		end
		--
		showFx = transition.to( nextView, { time = 0, onComplete = phase1 } )
	
	------------------
	-- EFFECT: Down Flip
	------------------
	
	elseif effect == "downFlip" then
		
		nextView.x = _W / 2
		nextView.y = _H * 0.15
		--
		nextView.xScale = 0.001
		nextView.yScale = 0.7
		--
		local phase1, phase2, phase3, phase4
		--
		phase1 = function( e )
			showFx = transition.to( currView, { xScale = 0.7, yScale = 0.7, x = _W * 0.15, y = _H * 0.15, time = fxTime, onComplete = phase2 } )
		end
		--
		phase2 = function( e )
			showFx = transition.to( currView, { xScale = 0.001, x = _W / 2, time = fxTime, onComplete = phase3 } )
		end
		--
		phase3 = function( e )
			showFx = transition.to( nextView, { x = _W * 0.15, xScale = 0.7, time = fxTime, onComplete = phase4 } )
		end
		--
		phase4 = function( e )
			showFx = transition.to( nextView, { xScale = 1, yScale = 1, x = 0, y = 0, time = fxTime, onComplete = fxEnded } )
		end
		--
		showFx = transition.to( currView, { time = 0, onComplete = phase1 } )
	
	------------------
	-- EFFECT: None
	------------------
	
	else
		timer.performWithDelay( safeDelay, fxEnded )
	end
	
	------------------
	-- Return
	------------------
	return true
	
end
M.changeScene = changeScene


return M



