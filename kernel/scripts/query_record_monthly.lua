local cjson = require "cjson.safe"
local util = require "easydarwin.util"

local bad_args = cjson.encode({
    code = 401,
    msg = "bad args"
})

local empty_list = cjson.encode({
    code = 0,
    msg = "success",
    data = {
        flags = "0000000000000000000000000000000"
    }
})

local server = ngx.shared.server;
local path = server:get("RECORD_PATH")
if not path then
    ngx.say(cjson.encode({
        code = 401,
        msg = "no record"
    }))
    return
end

local args = ngx.req.get_uri_args()
local id = args.id
local period = args.period

if not id or not period then
    ngx.say(bad_args)
    return
end

if not util.is_right_date(period) then
    ngx.say(bad_args)
    return
end

if not util.is_folder_exist(path, id) then
    ngx.say(empty_list)
    return
end

path = path .. "/" .. id
local files = util.get_folders(path)
if not files then
    ngx.say(empty_list)
    return
end

local flags = false
local left = tonumber(period .. "01")
local right = tonumber(period .. "31")
local flags = ""
for i = left, right do
    local day = tostring(i)
    if files[day] then
        flags = flags .. "1"
    else
        flags = flags .. "0"
    end
end

local response = cjson.encode({
    code = 0,
    msg = "success",
    data = {
        flags = flags
    }
})

ngx.say(response)