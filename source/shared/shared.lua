formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 

function convertTimestamp(timeInString)
    if timeInString then
        local splitado = split(timeInString, ":")
        return (tonumber(splitado[2]*1000)+tonumber(splitado[1]*60000))
    end
    return 0
end

function convertTime(ms) 
    local min = math.floor ( ms/60000 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    if min < 10 then 
        min = "0"..min
    end 
    if sec < 10 then 
        sec = "0"..sec
    end 
    return min, sec 
end

function giveCounter(ms) 
    local year = math.floor ( (ms/31536000000)%12 ) 
    local month = math.floor ( (ms/2629800000)%12 )
    local day = math.floor ( (ms/86400000)%30 ) 
    local hour = math.floor ( (ms/3600000)%24 ) 
    local min = math.floor ( (ms/60000)%60 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    if tonumber(hour) < 10 then 
        hour = "0"..tonumber(hour)
    end 
    if min < 10 then 
        min = "0"..min
    end 
    if sec < 10 then 
        sec = "0"..sec
    end 
    hourSelected = ""
    if tonumber(year) > 0 then
        hourSelected = (year.."a "..month.."m "..day.."d "..hour.."h "..min.."m "..sec.."s")
    elseif tonumber(month) > 0 then
        hourSelected = (month.."m "..day.."d "..hour.."h "..min.."m "..sec.."s")
    elseif tonumber(day) > 0 then
        hourSelected = (day.."d "..hour.."h "..min.."m "..sec.."s")
    elseif tonumber(hour) > 0 then
        hourSelected = (hour.."h "..min.."m "..sec.."s")
    elseif tonumber(min) > 0 then
        hourSelected = (min.."m "..sec.."s")
    elseif tonumber(sec) > 0 then
        hourSelected = (sec.."s")
    end
    return hourSelected
end

function isoToTimestamp(isoDate)
    local year, month, day, hour, min, sec = isoDate:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+%.?%d*)")
    
    sec = sec:match("(%d+)") or sec

    local timeTable = {
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec),
    }

    return os.time(timeTable)
end

function timestampToIso(timestamp)
    local timeTable = os.date("!*t", timestamp)
    
    return string.format(
        "%04d-%02d-%02dT%02d:%02d:%02dZ",
        timeTable.year,
        timeTable.month,
        timeTable.day,
        timeTable.hour,
        timeTable.min,
        timeTable.sec
    )
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end
