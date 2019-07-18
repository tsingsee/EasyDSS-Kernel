local redis = require "easydarwin.redis_pool"

local _M = {}
_M._VERSION = '1.0'

local mt = { __index = _M }

function _M.on_publish(args)
    local app = args.app
    local name = args.name
    local call = args.call
    local id = ngx.shared.server:get("SERVER_ID")
    local live = app .. "/" .. name

    ngx.log(ngx.INFO, "on monitor " .. call .. ": " .. live)

    local r, red = redis:get_connect()
    if not r or not id then
        return
    end

    local timeout = 60

    local res, err = red:expire("Live:" .. live, timeout)
    if res == 0 then
        res, err = red:hmset("Live:" .. live, "EasyDarwin", id)
        if not res then
            ngx.log(ngx.ERR, "hmset live error")
            return
        end

        res, err = red:expire("Live:" .. live, timeout)
        if not res then
            ngx.log(ngx.ERR, "expire live error")
            return
        end
    elseif res ~= 1 then
        ngx.log(ngx.ERR, "expire live error")
        return
    end

    return
end

function _M.on_publish_done(args)
    local app = args.app
    local name = args.name
    local live_name = app .. "/" .. name

    ngx.log(ngx.INFO, "on monitor publish done: " .. live_name)

    local r, red = redis:get_connect()
    if not r then
        return
    end

    local res, err = red:del("Live:" .. live_name)
    if not res then
        ngx.log(ngx.ERR, "delete live error")
        return
    end
end

return _M