local cjson = require "cjson.safe"
local util = require "easydarwin.util"
local parser = require "easydarwin.m3u8_parser"

local bad_args = cjson.encode({
    code = 401,
    msg = "bad args"
})

cjson.encode_empty_table_as_object(false)
local empty_list = cjson.encode({
    code = 0,
    msg = "success",
    data = {
        list = {}
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

if not util.is_right_datetime(period) then
    ngx.say(bad_args)
    return
end

path = path .. "/" .. id
if not util.is_folder_exist(path, period) then
    ngx.say(empty_list)
    return
end

path = path .. "/" .. period
local files = util.get_folders(path)
if not files then
    ngx.say(empty_list)
    return
end

local list = {}
local record_m3u8 = id .. "_" .. "record.m3u8"
local snap_png = id .. "_" .. "snap.png"
for k, v in pairs(files) do
    local record_path = path .. "/" .. v
    local m3u8_path = record_path .. "/" .. record_m3u8
    if util.is_file_exist(record_path, record_m3u8) then
        local item = {}
        item["start_time"] = v
        item["duration"] = parser.parse_m3u8_total_duration(m3u8_path)
        item["hls"] = string.gsub(m3u8_path,"^www","")
        if util.is_file_exist(record_path, snap_png) then
            item["snap"] = string.gsub(record_path,"^www","") .. "/" .. snap_png
        else
            item["snap"] = ""
        end
        table.insert(list, item)
    end
end

local response = cjson.encode({
    code = 0,
    msg = "success",
    data = {
        list = list
    }
})

ngx.say(response)