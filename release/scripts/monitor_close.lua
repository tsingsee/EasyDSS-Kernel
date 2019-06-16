local http = require "resty.http"
local cjson = require "cjson.safe"
local util = require "easydarwin.util"
local redis = require "easydarwin.redis_pool"

local _M = {}
_M._VERSION = '1.0'

local mt = { __index = _M }

function _M.on_stop_push_stream(args)
    local name = args.name

    local tb = util.split(name, "-")
    local device_name = tb[1]
    local device_channel = tb[2] or "1"
    if not device_name then
        return
    end

    ngx.log(ngx.INFO, "on monitor stop push stream: " .. device_name)

    local r, red = redis:get_connect()
    if not r then
        return
    end

    local res, err = red:exists("Device:" .. device_name)
    if not res then
        ngx.log(ngx.ERR, "exists device error")
        return
    elseif res == 0 then
        ngx.log(ngx.ERR, "device not exists")
        return
    end

    res, err = red:hmget("Device:" .. device_name, "EasyCMS")
    if not res then
        ngx.log(ngx.ERR, "hmget device error")
        return
    end

    local cms = res[1]
    res, err = red:hmget("EasyCMS:" .. cms, "IP", "Port")
    if not res then
        ngx.log(ngx.ERR, "hmget EasyCMS error")
        return
    end

    local ip = res[1]
    local port = res[2]
    if not ip or not port then
        ngx.log(ngx.ERR, "ip/port empty")
        return
    end

    local req_body = cjson.encode({
        EasyDarwin = {
            Header = {
                Version = "1.0",
                AppType = "EasyDarwin",
                TerminalType = "Linux",
                CSeq = "1",
                MessageType = "MSG_CS_FREE_STREAM_REQ"
            },
            Body = {
                Serial = device_name,
                Channel = device_channel,
                Protocol = "RTMP",
                Reserve = ""
            }
        }
    })

    local req_url = "http://" .. ip .. ":" .. port .. "/"
    local httpc = http.new()
    local res, err = httpc:request_uri(req_url, {
        method = "POST",
        body = req_body,
        headers = {
            ["Content-Length"] = #req_body
        }
    })

    if not res then
        ngx.say("failed to request: ", err)
        return
    end
end

return _M