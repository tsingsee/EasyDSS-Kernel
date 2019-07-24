local redis = require "easydarwin.redis_pool"

local delay = 5
local handler
handler = function(premature)
    if not premature then
        init_redis()
    end
end

local ok, err = ngx.timer.at(delay, handler)
if not ok then
    ngx.log(ngx.ERR, "failed to create timer: ", err)
end

function init_redis()
    local server = ngx.shared.server;

    local id = server:get("SERVER_ID")
    local ip = server:get("EASYDARWIN_HOST") or "127.0.0.1"
    local http = server:get("HTTP_PORT") or 80
    local rtmp = server:get("RTMP_PORT") or 6379
    local load = 0

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

    local res, err = red:hmset("EasyDarwin:" .. id, "IP", ip, "HTTP", http, "RTMP", rtmp, "Load", load)
    if not res then
        ngx.log(ngx.ERR, "hmset easydarwin error")
        return
    end

    res, err = red:expire("EasyDarwin:" .. id, timeout)
    if not res then
        ngx.log(ngx.ERR, "expire easydarwin error")
        return
    end
end

