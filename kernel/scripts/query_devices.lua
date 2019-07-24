local cjson = require "cjson.safe"
local util = require "easydarwin.util"

local bad_args = cjson.encode({
    code = 400,
    msg = "bad args"
})

local empty_devices = cjson.encode({
    code = 0,
    msg = "success",
    data = {
        devices = {}
    }
})

local server = ngx.shared.server;
local path = server:get("RECORD_PATH")
if not path then
    ngx.say(cjson.encode({
        code = 500,
        msg = "no record path config"
    }))
    return
end

local args = ngx.req.get_uri_args()
local start = args.start
local limit = args.limit

local files = util.get_folders(path)
if not files then
    ngx.say(empty_devices)
    return
end

local devices = {}
for k,v in pairs(files) do
    table.insert(devices, v);
end
table.sort(devices)

local response = cjson.encode({
    code = 0,
    msg = "success",
    data = {
        devices = devices
    }
})

ngx.say(response)