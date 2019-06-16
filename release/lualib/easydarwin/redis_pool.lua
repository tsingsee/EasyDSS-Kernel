local redis = require("resty.redis")

local redis_pool = {}

function redis_pool:get_connect()
    if ngx.ctx[redis_pool] then
        return true, ngx.ctx[redis_pool]
    end

    local client, err = redis:new()
    if not client then
        return false, "failed to connect redis"
    end

    client:set_timeout(2000)

    local redis_host = ngx.shared.server:get("REDIS_HOST") or "127.0.0.1"
    local redis_port = ngx.shared.server:get("REDIS_PORT") or 6379
    local ok, err = client:connect(redis_host, redis_port)
    if not ok then
        return false, err
    end

    local count, err = client:get_reused_times()
    local redis_pass = ngx.shared.server:get("REDIS_PASS")
    if (0 == count) and redis_pass then
        ok, err = client:auth(redis_pass)
        if not ok then
            return false, "redis failed to auth"
        end
    elseif err then
        return false, "redis failed to get reused times"
    end

    ngx.ctx[redis_pool] = client
    return true, ngx.ctx[redis_pool]
end

function redis_pool:close()
    if ngx.ctx[redis_pool] then
        ngx.ctx[redis_pool]:set_keepalive(60000, 100)
        ngx.ctx[redis_pool] = nil
    end
end

return redis_pool