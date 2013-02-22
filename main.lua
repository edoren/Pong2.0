require("conf") -- require to get the screenWidth and the screenHeight variables
require("objects")
require("map")

--====================================================================--
-- Pong2.0
--====================================================================--

--[[

 - Version: v1.1 Stable
 - Made by: Manuel Fernando Sabogal Ocampo

--]]

------------------------------------------------------------------------
--- LOVE.LOAD()
------------------------------------------------------------------------

function love.load()
    love.physics.setMeter(50) --the height of a meter our worlds will be 50px
    world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    
    -- initial graphics setup
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Load the Objects located in object.lua
    loadObjects(world, screenWidth, screenHeight)

    -- Load the Map located in map.lua
    loadMap(world, screenWidth, screenHeight)

    -- Sound
    plop = love.audio.newSource("plop.mp3")
        plop:setVolume(0.9) -- 90% of ordinary volume
        plop:setPitch(1.5) -- 1.5 octaves upper

    -- Fonts
    scoreFont = love.graphics.newFont("score.ttf", 18)
    chubbyFont = love.graphics.newFont("chubby.ttf", 45)

    -- Used variables
    score = 0              -- stores the obtained score in the game
    persisting = 0
    time = 0 -- set the time to increase the score
    gameState = "playing"
    setFPS = false
end


------------------------------------------------------------------------
--- LOVE.KEYPRESSED()
------------------------------------------------------------------------

function love.keypressed(key)
    if key == "escape" then -- Go to menu
        love.event.push("quit")   -- closes the game
    elseif key == "p" then -- Pause the game
        if gameState == "playing" then
            gameState = "paused"
        elseif gameState == "paused" then
            gameState = "playing"
        end
    elseif key == "f" then -- Show FPS
        setFPS = not setFPS
    elseif key == "r" then -- Reset game
        restartGame()
        gameState = "playing"
    end
end


------------------------------------------------------------------------
--- LOVE.UPDATE()
------------------------------------------------------------------------

function love.update(dt)
    if gameState == "playing" then
        world:update(dt) --this puts the world into motion
        time = time + dt

        -- Update the Objects located object.lua
        updateObjects(screenWidth, screenHeight)

        -- Increases the score each 5 seconds
        if math.floor(time) == 5 then
            score = score + math.floor(math.sqrt(vx^2+vy^2)/60)
            time = 0
        end

        if object.ball.body:getY()-object.ball.shape:getRadius() > screenHeight then
            gameState = "lose"
        end

        fps = love.timer.getFPS()
    end
end


------------------------------------------------------------------------
--- LOVE.DRAW()
------------------------------------------------------------------------

function love.draw()
    drawObjects()
    drawMap()

    love.graphics.setColor(255,255,255) -- Set the color to white for score text
    love.graphics.setFont(scoreFont) -- Set the font for score text
    love.graphics.print("Score: "..score.." points", 10, 10)

    if setFPS == true then 
        love.graphics.print("FPS "..fps, screenWidth-(tostring(fps):len()+3)*17, 10)
    end

    if gameState == "paused" then
        love.graphics.setColor(255, 255, 255, 150)
        love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(chubbyFont)
        love.graphics.print("Paused", screenWidth/2-chubbyFont:getWidth("Paused")/2, screenHeight/2-chubbyFont:getHeight())
    end

    if gameState == "lose" then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(chubbyFont)
        love.graphics.print("Score: "..tostring(score).." points", screenWidth/2-chubbyFont:getWidth("Score: "..tostring(score).." points")/4, screenHeight/2-chubbyFont:getHeight()*2, 0 , 0.5)
        love.graphics.print("Game Over", screenWidth/2-chubbyFont:getWidth("Game Over")/2, screenHeight/2-chubbyFont:getHeight())
        love.graphics.print("Press R to try again", screenWidth/2-chubbyFont:getWidth("Press R to try again")/4.5, screenHeight/2+chubbyFont:getHeight()/2, 0 , 0.45)
    end
end

------------------------------------------------------------------------
--- COLLITION
------------------------------------------------------------------------

function beginContact(a, b, coll)
    coll:setFriction(0)
    if a:getUserData() == "Pong" then
        love.audio.play(plop)
    end
end

function endContact(a, b, coll)
    persisting = 0
end

function preSolve(a, b, coll)
    if persisting == 50 then
        if a:getUserData() == "WallL" then
            object.ball.body:applyForce(400, 0)
        elseif a:getUserData() == "WallR" then
            object.ball.body:applyForce(-400, 0)
        elseif a:getUserData() == "WallU" then
            object.ball.body:applyForce(0, 400)
        end
    end
    persisting = persisting + 1    -- Keep track of how many updates they've been touching for
end

function postSolve(a, b, coll)
end

------------------------------------------------------------------------
--- Restart Game
------------------------------------------------------------------------

function restartGame()
    score = 0
    time = 0
    object.ball.body:setPosition( math.random(1, screenWidth-object.ball.shape:getRadius()), math.random(1, screenHeight/4))
    object.ball.body:setLinearVelocity(ballDirection()*160, ballDirection()*160)
    object.pong.body:setPosition(screenWidth/2 , screenHeight-25)
end
