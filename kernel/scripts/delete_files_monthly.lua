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
local period = args.period
local type = args.type or "record"
ngx.log(ngx.ERR, "delete file id : ", id , " , period : " , period)
if not id or not period then
    ngx.say(bad_args)
    return
end

if not util.is_right_date(period) then
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
local files = util.get_folders(path)
if not files then
    ngx.say(response)
    return
end
ngx.log(ngx.ERR, "record path by id : ", path)
local left = tonumber(period .. "01")
local right = tonumber(period .. "31")
for i = left, right do
    local day = tostring(i)
    if files[day] then
        ngx.log(ngx.ERR, "record path by day : ", path .. "/" .. day)
        util.rmdir(path .. "/" .. day)
    end
end

ngx.say(response)