local _M = {}
_M._VERSION = '1.0'

local mt = { __index = _M }

function _M.parse_m3u8_total_duration(file)
    local total_duration = 0.00
    local file = io.open(file)
    for line in file:lines() do
        local total = line:match("#EXT_X_TOTAL_DURATION:\\s*(%d+[\\.]?%d*)")
        if total then
            total_duration = tonumber(total)
            break
        end
        local duration = line:match("#EXTINF:(%d+[\\.]?%d*)")
        if duration then
            total_duration = total_duration + tonumber(duration)
        end
    end

    io.close(file)

    return total_duration
end

return _M