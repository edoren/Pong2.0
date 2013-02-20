require("math")

function love.load()
    love.physics.setMeter(50) --the height of a meter our worlds will be 50px
    world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    
    -- initial graphics setup
    worldX = 300
    worldY = 400
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setMode(worldX, worldY, false, true, 0) --set the window dimensions to 500 by 500

    objects = {} -- Table to hold all our physical objects

    -- Pong
    objects.pong = {}
        objects.pong.body = love.physics.newBody(world, worldX/2, worldY-25, "static") --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (500/2, 500-50/2)
            objects.pong.body:setMass(1)
        objects.pong.shape = love.physics.newRectangleShape(70, 13) --make a rectangle with a width of 500 and a height of 50
        objects.pong.fixture = love.physics.newFixture(objects.pong.body, objects.pong.shape); --attach shape to body
        objects.pong.fixture:setUserData("Pong")


    -- Ball
    objects.ball = {}
        objects.ball.body = love.physics.newBody(world, worldX/2, math.random(1, worldY/4), "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
            objects.ball.body:setMass(1)
        objects.ball.shape = love.physics.newCircleShape(10) --the ball's shape has a radius of 20
        objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape) -- Attach fixture to body and give it a density of 1.
            objects.ball.fixture:setRestitution(1) --let the ball bounce
            objects.ball.fixture:setUserData("Ball")
    

    -- Walls
    objects.wallL = {}
        objects.wallL.body = love.physics.newBody(world, 1, worldY/2)
        objects.wallL.shape = love.physics.newRectangleShape(2, worldY)
        objects.wallL.fixture = love.physics.newFixture(objects.wallL.body, objects.wallL.shape)
            objects.wallL.fixture:setUserData("WallL")

    objects.wallR = {}
        objects.wallR.body = love.physics.newBody(world, worldX-1, worldY/2)
        objects.wallR.shape = love.physics.newRectangleShape(2, worldY)
        objects.wallR.fixture = love.physics.newFixture(objects.wallR.body, objects.wallR.shape)
            objects.wallR.fixture:setUserData("WallR")

    objects.wallU = {}
    objects.wallU.body = love.physics.newBody(world, worldX/2, 1)
    objects.wallU.shape = love.physics.newRectangleShape(worldX, 2)
    objects.wallU.fixture = love.physics.newFixture(objects.wallU.body, objects.wallU.shape)
        objects.wallU.fixture:setUserData("WallU")
     
    -- Ball movement
    objects.ball.body:applyForce(200, 200)

    -- Sound
    plop = love.audio.newSource("plop.mp3")
        plop:setVolume(0.9) -- 90% of ordinary volume
        plop:setPitch(1.5) -- one octave upper

    -- Fonts
    scoreFont = love.graphics.newFont("score.ttf", 20)

    -- Used variables
    score = 0              -- stores the obtained score in the game
    persisting = 0
    lastTime = os.time()+5 -- set the time to increse the score

end

function love.keypressed(key)   -- we do not need the unicode, so we can leave it out
   if key == "escape" then
      love.event.push("quit")   -- actually causes the app to quit
   end
end

function love.update(dt)
    world:update(dt) --this puts the world into motion
    --here we are going to create some keyboard events
    objects.pong.body:setPosition(objects.pong.body:getX() , worldY-25)

    if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
        -- objects.pong.body:applyForce(50, 0)
        objects.pong.body:setX(objects.pong.body:getX()+5)
    elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
        -- objects.pong.body:applyForce(-50, 0)
        objects.pong.body:setX(objects.pong.body:getX()-5)
    elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
        objects.ball.body:setPosition( math.random(1, worldX-objects.ball.shape:getRadius()), math.random(1, worldY/4))
        objects.ball.body:setLinearVelocity(100, 100)
    elseif love.keyboard.isDown("a") then 
        objects.ball.body:applyForce(-30, 0)
    elseif love.keyboard.isDown("d") then 
        objects.ball.body:applyForce(30, 0)
    end

    -- increses de Ball Linear Velocity
    vx, vy = objects.ball.body:getLinearVelocity()
    if vx < 0 then
        increseX = -0.04
    else
        increseX = 0.04
    end
    if vy < 0 then
        increseY = -0.04
    else
        increseY = 0.04
    end
    objects.ball.body:setLinearVelocity(vx+increseX, vy+increseY)

    -- increses the score each 5 seconds
    if os.time() == lastTime then
        score = score + math.floor(math.sqrt(vx^2+vy^2)/60)
        lastTime = os.time()+5
    end

    fps = love.timer.getFPS()
end

function love.draw()
    love.graphics.setColor(255, 255, 255) -- set the drawing color to white for the pong and walls
    love.graphics.rectangle("fill", objects.pong.body:getX()-70/2, objects.pong.body:getY()-13/2, 70, 13)

    love.graphics.polygon("fill", objects.wallR.body:getWorldPoints(objects.wallR.shape:getPoints()))
    love.graphics.polygon("fill", objects.wallL.body:getWorldPoints(objects.wallL.shape:getPoints()))
    love.graphics.polygon("fill", objects.wallU.body:getWorldPoints(objects.wallU.shape:getPoints()))

    love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

    love.graphics.setColor(255,255,255) -- set the color to white for score text
    love.graphics.setFont(scoreFont) -- set the font for score text
    love.graphics.print("Score "..score, 10, 10)

    if love.keyboard.isDown("f") then 
        love.graphics.print("FPS "..fps, worldX-(tostring(fps):len()+3)*17, 10)
    end
end

function beginContact(a, b, coll)
    coll:setFriction(0)
    if a:getUserData() == "Pong" then
        love.audio.play(plop)
    end
    -- score = score+1
end

function endContact(a, b, coll)
    persisting = 0
end

function preSolve(a, b, coll)
    if persisting == 50 then
        if a:getUserData() == "WallL" then
            objects.ball.body:applyForce(400, 0)
        elseif a:getUserData() == "WallR" then
            objects.ball.body:applyForce(-400, 0)
        elseif a:getUserData() == "WallU" then
            objects.ball.body:applyForce(0, 400)
        end
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end

function postSolve(a, b, coll)
end
