local cjson = require "cjson.safe"

local conf_file = io.open("./easydss.conf")
if not conf_file then
    return
end

local conf = cjson.decode(conf_file:read("*a"))
if not conf then
    io.close(conf_file)
    return
end
io.close(conf_file)

local template_file = io.open("./conf/template.conf")
if not template_file then
    return
end

local conf_string = template_file:read("*a")
if not conf_string then
    io.close(template_file)
    return
end
io.close(template_file)

for key, value in pairs(conf) do
    conf_string = string.gsub(conf_string, "$" .. key, value)
end

local easydss_file = io.open("./conf/easydss.conf", "w")
easydss_file:write(conf_string)
io.close(easydss_file)
