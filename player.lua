Player = {}
Player.__index = Player

local wf = require "libraries/windfield"


function Player:new(world, x_pos, y_pos, health)

    local entity = {
        x = x_pos,
        y = y_pos,
        hp = health,
        image = love.graphics.newImage('/sprites/Placeholder_Human.png'),
        direction = 1
    }

    entity.collider = world:newRectangleCollider(x_pos, y_pos, 32, 48)
    entity.collider:setFixedRotation(true)

    setmetatable(entity, Player)

    return entity
end

function movePlayer(p, leftKey, rightKey, upKey, downKey) 
    local px, py = p.collider:getLinearVelocity()
    
    if love.keyboard.isDown('left') and px > -200 then
        p.collider:applyForce(-5000, 0)
        p.direction = -1
    
    end

    if love.keyboard.isDown('right') and px < 200 then
        p.collider:applyForce(5000, 0)
        p.direction = 1

    end
    if love.keypressed("up") and py > -200 then
        p.collider:applyLinearImpulse(0, -900)
    end
end

function Player:update(dt)
    movePlayer(self, "left", "right", "up", "down")

    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 20, 20)
end

return Player