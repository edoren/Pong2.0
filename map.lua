map = {} --Table to hold all the map's objects

--====================================================================--
-- MAP'S FILE
--====================================================================--


------------------------------------------------------------------------
--- Load Map
------------------------------------------------------------------------

function loadMap(world, screenWidth, screenHeight)
    -- Walls
    map.wallL = {}
        map.wallL.body = love.physics.newBody(world, 1, screenHeight/2)
        map.wallL.shape = love.physics.newRectangleShape(2, screenHeight)
        map.wallL.fixture = love.physics.newFixture(map.wallL.body, map.wallL.shape)
            map.wallL.fixture:setUserData("WallL")

    map.wallR = {}
        map.wallR.body = love.physics.newBody(world, screenWidth-1, screenHeight/2)
        map.wallR.shape = love.physics.newRectangleShape(2, screenHeight)
        map.wallR.fixture = love.physics.newFixture(map.wallR.body, map.wallR.shape)
            map.wallR.fixture:setUserData("WallR")

    map.wallU = {}
    map.wallU.body = love.physics.newBody(world, screenWidth/2, 1)
    map.wallU.shape = love.physics.newRectangleShape(screenWidth, 2)
    map.wallU.fixture = love.physics.newFixture(map.wallU.body, map.wallU.shape)
        map.wallU.fixture:setUserData("WallU")
end
    
------------------------------------------------------------------------
--- Draw Map
------------------------------------------------------------------------

function drawMap()
    love.graphics.setColor(255, 255, 255) -- set the drawing color to white for the walls
    love.graphics.polygon("fill", map.wallR.body:getWorldPoints(map.wallR.shape:getPoints()))
    love.graphics.polygon("fill", map.wallL.body:getWorldPoints(map.wallL.shape:getPoints()))
    love.graphics.polygon("fill", map.wallU.body:getWorldPoints(map.wallU.shape:getPoints()))
end
