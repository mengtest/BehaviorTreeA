--==============================--
    --@file: BaseBehavior.lua
    --@desc: 
    --@time: 2019-6-25 19:31:58
    --@autor: baimingjiang
    --@return 
--==============================--

local BaseBehavior = class('BaseBehavior')

function BaseBehavior:ctor(conf)

    self._id = conf.id

    self._conf      = conf

    self._params    = conf.params or {}
    self._weight    = self._params.weight or 10

    self._type      = nil

    self._state = bt.NONE

    self._tick = 0

    self._isRunning = false
end

function BaseBehavior:exec(ctx)
    self._tick = self._tick + 1

    if not self._isRunning then
        self:__enter(ctx)
    end

    self:__run(ctx)

    if self._state == bt.SUCCESS or self._state == bt.FAILURE then
        self:__exit(ctx)
    end

    return self._state
end

function BaseBehavior:isRunning()
    return self._isRunning
end

--- private method ---
function BaseBehavior:__run(ctx)
    self._state = bt.RUNNING
    self:onProcess(ctx)
end

function BaseBehavior:__enter(ctx)
    self._tick = 0
    self._isRunning = true

    bt.log(string.format( "node: %s, id:%s, entering", self._conf.name, self._id))

    ctx:pushBehavior(self)
    self:onEnter(ctx)
end

function BaseBehavior:__exit(ctx)
    self._isRunning = false
    
    self:onExit(ctx)
    ctx:popBehavior(self)

    bt.log(string.format( "node: %s, id:%s, tick:%d, exit", self._conf.name, self._id, self._tick))
end

--
-- public and override

function BaseBehavior:onEnter(ctx)
    
end

function BaseBehavior:onExit(ctx)
    
end

function BaseBehavior:onProcess(ctx)
    self._state = bt.SUCCESS
end

return BaseBehavior