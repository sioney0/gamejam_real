Player = {}
Player.__index = Player

local wf = require "libraries/windfield"


function Player:new(world, x_pos, y_pos, health)

    local entity = {
        x = x_pos,
        y = y_pos,
        hp = health,
        image = love.graphics.newImage('/sprites/Placeholder_Human.png'),
        direction = 1,
        canJump = true,
        

        isPunching = false,
        punchTimer = 0,
        punchDuration = 0.15,
        punchCooldown = 0,
        punchCooldownTime = 0.4,
        punchHitbox = nil
    }
   
    entity.collider = world:newRectangleCollider(x_pos, y_pos, 32, 48)
    entity.collider:setFixedRotation(true)
   

    setmetatable(entity, Player)

    return entity
end

function Player:punch(world)
    if self.punchCooldown > 0 then
        return
    end

    self.isPunching = true
    self.punchTimer = self.punchDuration
    self.punchCooldown = self.punchCooldownTime

    local hitboxWidth = 40
    local hitboxHeight = 30

    local hitboxX = self.x + self.direction * 40
    local hitboxY = self.y

    self.punchHitbox = world:newRectangleCollider(
        hitboxX - hitboxWidth / 2,
        hitboxY - hitboxHeight / 2,
        hitboxWidth,
        hitboxHeight
    )

    self.punchHitbox:setType("static")
    self.punchHitbox:setCollisionClass("Punch")
end


function movePlayer(p, leftKey, rightKey, upKey, downKey) 
    local px, py = p.collider:getLinearVelocity()
    
    if love.keyboard.isDown('left') and px > -200 then
        p.collider:applyForce(-5000, 0)
        p.direction = -1
    elseif love.keyboard.isDown('right') and px < 200 then
        p.collider:applyForce(5000, 0)
        p.direction = 1
    else 
         p.collider:setLinearVelocity(px * 0.8, py)
    end

    if love.keyboard.isDown("up") and py > -200 and p.canJump then
        p.collider:applyLinearImpulse(0, -1000)
        p.canJump = false
    end
end

function Player:update(dt, world)
    movePlayer(self, "left", "right", "up", "down")
    if self.collider:enter("Ground") then
        self.canJump = true
    end

    if self.punchCooldown > 0 then
        self.punchCooldown = self.punchCooldown - dt
    end


    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Player:draw()
    
    local imgW = self.image:getWidth()
    local imgH = self.image:getHeight()

    love.graphics.draw(self.image, self.x, self.y, 0, 5, 5,  imgW / 2,
        imgH / 2)
end

return Player