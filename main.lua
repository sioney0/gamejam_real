local Player = require('player')

function love.load()
    wf = require "libraries/windfield" 
    love.window.setMode(1920, 1080)

    world = wf.newWorld(0, 500)
    world:addCollisionClass("Ground")
    ground = world:newRectangleCollider(100, 400, 600, 100)
    ground:setType('static')
    ground:setCollisionClass("Ground")

    player_one = Player:new(world, 100, 100, 100)
    love.graphics.setBackgroundColor(0, 1, 0)
end

function love.update(dt)
    
    world:update(dt)

    player_one:update(dt)
end

function love.draw()
    world:draw()

    player_one:draw()

end


