ngx.req.read_body()
local args = ngx.req.get_post_args()
local call = args.call

if not call then
    ngx.log(ngx.ERR, "notify empty call")
    ngx.exit(ngx.HTTP_OK)
end

if call == "monitor_publish" then
    local on = require "scripts.monitor_publish"
    on.on_publish(args)
elseif call == "monitor_publish_done" then
    local on = require "scripts.monitor_publish"
    on.on_publish_done(args)
elseif call == "monitor_update_publish" then
    local on = require "scripts.monitor_publish"
    on.on_publish(args)
elseif call == "monitor_close" then
    local on = require "scripts.monitor_close"
    on.on_stop_push_stream(args)
elseif call == "heartbeat" then
    local on = require "scripts.on_heartbeat"
    on.on_easydarwin_ttl(args)
else
    ngx.log(ngx.ERR, "notify bad call: " .. call)
    ngx.exit(ngx.HTTP_OK)
end

ngx.exit(ngx.HTTP_OK)