local component = {}

-- From TJDevries
-- https://github.com/tjdevries/lazy-require.nvim
local function lazy_require(require_path)
    return setmetatable({}, {
        __index = function(_, key)
            return require(require_path)[key]
        end,

        __newindex = function(_, key, value)
            require(require_path)[key] = value
        end,
    })
end

local c = lazy_require("copilot.client")
local a = lazy_require("copilot.api")

---Check if copilot is enabled
---@return boolean
component.is_enabled = function()
    if c.is_disabled() then
        return false
    end

    return true
end

---Check if copilot is online
---@return boolean
component.is_error = function()
    if c.is_disabled() then
        return false
    end

    local data = a.status.data.status
    if data == 'Warning' then
        return true
    end

    return false
end

---Show copilot running status
---@return boolean
component.is_loading = function()
    if c.is_disabled() then
        return false
    end

    local data = a.status.data.status
    if data == 'InProgress' then
        return true
    end

    return false
end

---Check auto trigger suggestions
---@return boolean
component.is_sleep = function()
    if c.is_disabled() then
        return false
    end

    return vim.b.copilot_suggestion_auto_trigger
end

return component
