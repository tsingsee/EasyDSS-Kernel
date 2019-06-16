local cjson = require "cjson.safe"
local util = require "easydarwin.util"

local bad_args = cjson.encode({
    code = 401,
    msg = "bad args"
})

local response = cjson.encode({
    code = 0,
    msg = "success",
})

local server = ngx.shared.server;
local path = server:get("RECORD_PATH")

local args = ngx.req.get_uri_args()
local id = args.id
local type = args.type or "record"
ngx.log(ngx.ERR, "delete file id : ", id)
if not id then
    ngx.say(bad_args)
    return
end

if type == "record" then
    path = server:get("RECORD_PATH")
elseif type == "snap" then
    path = server:get("SNAP_PATH")
end

if not path then
    ngx.say(cjson.encode({
        code = 401,
        msg = "no path"
    }))
    return
end

if not util.is_folder_exist(path, id) then
    ngx.say(response)
    return
end

path = path .. "/" .. id
util.rmdir(path)

ngx.say(response)