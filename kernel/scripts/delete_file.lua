local cjson = require "cjson.safe"
local util = require "easydarwin.util"

local bad_args = cjson.encode({
    code = 401,
    msg = "bad args"
})

cjson.encode_empty_table_as_object(false)
local response = cjson.encode({
    code = 0,
    msg = "success",
})

local server = ngx.shared.server;
local path = server:get("RECORD_PATH")

local args = ngx.req.get_uri_args()
local id = args.id
local period = args.period
local filename = args.filename
local type = args.type or "record"
ngx.log(ngx.ERR, "filename = ", filename)
if not id or not period or not filename then
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

path = path .. "/" .. id
if not util.is_folder_exist(path, period) then
    ngx.say(response)
    return
end

path = path .. "/" .. period
if not util.is_folder_exist(path, filename) then
    ngx.say(response)
    return
end
path = path .. "/" .. filename

local mode,err = lfs.attributes(path, "mode") 
if mode == "directory" then
    util.rmdir(path)
elseif mode == "file" then
    os.remove(path)
end

ngx.say(response)