local redis = require "easydarwin.redis_pool"

local _M = {}
_M._VERSION = '1.0'

local mt = { __index = _M }

function _M.on_easydarwin_ttl(args)
    local load = args.load or 0

    ngx.log(ngx.INFO, "on heartbead load: " .. load)

    local server = ngx.shared.server;
    local id = server:get("SERVER_ID")

    if not id then
        ngx.log(ngx.ERR, "id empty!")
        return
    end

    local r, red = redis:get_connect()
    if not r then
        ngx.log(ngx.ERR, "redis connect error!")
        return
    end

    local timeout = 20
    local res, err = red:expire("EasyDarwin:" .. id, timeout)
    if res == 1 then
        res, err = red:hset("EasyDarwin:" .. id, "Load", load)
        if not res then
            ngx.log(ngx.ERR, "hset easydarwin load error")
            return
        end
    elseif res == 0 then
        local ip = server:get("EASYDARWIN_HOST") or "127.0.0.1"
        local http = server:get("HTTP_PORT") or 80
        local rtmp = server:get("RTMP_PORT") or 6379
        res, err = red:hmset("EasyDarwin:" .. id, "IP", ip, "HTTP", http, "RTMP", rtmp, "Load", load)
        if not res then
            ngx.log(ngx.ERR, "hmset easydarwin error")
            return
        end

        res, err = red:expire("EasyDarwin:" .. id, timeout)
        if not res then
            ngx.log(ngx.ERR, "expire easydarwin error")
            return
        end
    else
        ngx.log(ngx.ERR, "expire easydarwin error")
    end
end

return _M