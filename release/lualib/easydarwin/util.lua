local cjson = require "cjson.safe"
local lfs = require("lfs")

local _M = {}
_M._VERSION = '1.0'

local mt = { __index = _M }

function _M.is_path_exists(path)
    local mode, err = lfs.attributes(path, "mode")
    if err then
        return false
    else
        if mode == "directory" then
            return true
        else
            return false
        end
    end
end

function _M.guid()
    local seed = {
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8','9', 'a', 'b', 'c', 'd', 'e', 'f'
    }

    local tb = {}
    for i = 1, 32 do
        table.insert(tb, seed[math.random(1, 16)])
    end

    local sid = table.concat(tb)

    return string.format(
        '%s%s%s%s%s',
        string.sub(sid, 1, 8),
        string.sub(sid, 9, 12),
        string.sub(sid, 13, 16),
        string.sub(sid, 17, 20),
        string.sub(sid, 21, 32)
    )
end

function _M.split(str, src)
	local str_split_tab = {}
	while true do
		local idx = string.find(str, src, 1, true);
		if idx then
			local insert_str = '';
			if 1 == idx then
				insert_str = string.sub(str, 1, idx + #src - 1);
			else
				insert_str = string.sub(str, 1, idx - 1);
			end

			if (insert_str ~= src) and (insert_str or '' ~= insert_str) then
				table.insert(str_split_tab, insert_str);
			end
			str = string.sub(str,idx + #src, -1);
		else
			if str or '' ~= str then
				table.insert(str_split_tab, str);
			end
			break;
		end
	end
	return str_split_tab;
end

function _M.method_filter(method)
    local result = cjson.encode({
        code = "200",
        msg = "success!"
    })

    if method ~= "POST" then
        result = cjson.encode({
            code = "10001",
            msg = "wrong method!"
        })

        return false, result
    end

    return true, result
end

function _M.get_month_days(month)
    if month == 2 then
    end

    return 0
end

function _M.is_right_date(date)
    local month = ngx.re.match(date, "^[2]\\d{3}(0[1-9]|1[0-2])")
    if #date > 6 or not month then
        return false
    end
    return true
end

function _M.is_right_datetime(date)
    local month = ngx.re.match(date,
        "([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))")
    if #date > 8 or not month then
        return false
    end
    return true
end

function _M.is_folder_exist(path, folder)
    local ok = false
    if not _M.is_path_exists(path) then
        return ok
    end
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            if file == folder then
                ok = true
                break
            end
        end
    end
    return ok
end

function _M.rmdir(path)
    local file = lfs.dir(path)
    if(file ~= nil) then
        local function _rmdir(path)
            local iter, dir_obj = lfs.dir(path)
            while true do
                local dir = iter(dir_obj)
                if dir == nil then break end
                if dir ~= "." and dir ~= ".." then
                    local curDir = path.."/"..dir
                    local mode,err = lfs.attributes(curDir, "mode") 
                    if mode == "directory" then
                        _rmdir(curDir.."/")
                    elseif mode == "file" then
                        os.remove(curDir)
                    end
                end
            end
            
            local succ, des = lfs.rmdir(path)
            if des then print(des) end
            return succ
        end
        _rmdir(path)
    end
    return true
end
function _M.is_file_exist(path, name)
    local ok = false
    if not _M.is_path_exists(path) then
        return ok
    end
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            if file == name then
                local fileTemp = path .. "/" .. file
                local attr = lfs.attributes(fileTemp)
                if attr.mode == "file" then
                    ok = true
                    break
                end 
            end
        end
    end
    return ok
end

function _M.get_folders(path)
    local files = {}
    if not _M.is_path_exists(path) then
        return files
    end
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local fileTemp = path .. "/" .. file
            local attr = lfs.attributes(fileTemp)
            if attr.mode == "directory" then
                files[file] = file
            end
        end
    end
    return files
end

return _M