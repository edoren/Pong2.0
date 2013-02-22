object = {} -- Table to hold all the physical objects

--====================================================================--
-- OBJECT'S FILE
--====================================================================--


------------------------------------------------------------------------
--- Load Objects
------------------------------------------------------------------------

pongWidth = 70
pongHeight = 13

function loadObjects(world, screenWidth, screenHeight)
    -- Pong
    object.pong = {}
        object.pong.body = love.physics.newBody(world, screenWidth/2, screenHeight-25, "static") 
            object.pong.body:setMass(1)
        object.pong.shape = love.physics.newRectangleShape(pongWidth, pongHeight) 
        object.pong.fixture = love.physics.newFixture(object.pong.body, object.pong.shape); -- Attach fixture to pong body.
        object.pong.fixture:setUserData("Pong")

    -- Ball
    object.ball = {}
        object.ball.body = love.physics.newBody(world, screenWidth/2, math.random(1, screenHeight/4), "dynamic")
        object.ball.shape = love.physics.newCircleShape(10) --the ball's shape has a radius of 20
        object.ball.fixture = love.physics.newFixture(object.ball.body, object.ball.shape) -- Attach fixture to ball body.
            object.ball.fixture:setRestitution(1) --let the ball bounce
            object.ball.fixture:setUserData("Ball")
     
    -- Ball initial movement
    object.ball.body:setLinearVelocity(160, 160)
end

------------------------------------------------------------------------
--- Draw Objects
------------------------------------------------------------------------

function drawObjects()
    love.graphics.setColor(255, 255, 255) -- set the drawing color to white for the pong
    love.graphics.rectangle("fill", object.pong.body:getX()-pongWidth/2, object.pong.body:getY()-pongHeight/2, pongWidth, pongHeight)

    love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
    love.graphics.circle("fill", object.ball.body:getX(), object.ball.body:getY(), object.ball.shape:getRadius())
end

------------------------------------------------------------------------
--- Objects Updater
------------------------------------------------------------------------

function updateObjects(screenWidth, screenHeight)
     object.pong.body:setPosition(object.pong.body:getX() , screenHeight-25)

    if love.keyboard.isDown("right") then
        object.pong.body:setX(object.pong.body:getX()+5)
    elseif love.keyboard.isDown("left") then
        object.pong.body:setX(object.pong.body:getX()-5)
    end

    -- increses de Ball Linear Velocity
    vx, vy = object.ball.body:getLinearVelocity()
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
    object.ball.body:setLinearVelocity(vx+increseX, vy+increseY)

    if object.pong.body:getX() < pongWidth/2+1 then
        object.pong.body:setPosition(pongWidth/2+1 , screenHeight-25)
    elseif object.pong.body:getX() > screenWidth-pongWidth/2+1 then
        object.pong.body:setPosition(screenWidth-pongWidth/2+1 , screenHeight-25)
    end
end
