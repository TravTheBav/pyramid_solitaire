--[[
    Functions for handling arrays in Lua
]]

-- returns true if the item is in the array, otherwise false
function itemInArray(arr, item)
    for idx, ele in ipairs(arr) do
        if ele == item then return true end
    end

    return false
end