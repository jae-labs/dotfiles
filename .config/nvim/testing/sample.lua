-- Sample Lua file with various issues for testing

-- Variables with potential issues
local name = "World"
local count = 5
local unused_var = "This variable is not used"
local another_unused = 42

-- Global variable (should be local)
global_var = "This should be local"

-- Function with potential issues
local function greet(name)
    print("Hello, " .. name .. "!")
    print("Count is: " .. count)

    -- Use of undeclared variable
    print(undeclared_var)

    -- Missing local keyword
    message = "This should be local"

    -- Unused parameter
    local function with_unused_param(param1, param2, param3)
        return param1
    end

    return message
end

-- Table with potential issues
local config = {
    apiUrl = "https://api.example.com",
    timeout = 5000,
    retries = 3,
    -- Trailing comma
}

-- Table with duplicate keys
local bad_config = {
    url = "https://example.com",
    timeout = 3000,
    url = "https://backup.com", -- Duplicate key
}

-- Array with potential issues
local items = {1, 2, 3, 4, 5}
local mixedArray = {"string", 42, true, nil, {key = "value"}}
local empty_table = {}

-- Conditional with potential issues
if #items > 3 then
    print("Array has more than 3 items")
elseif #items == 3 then
    print("Array has exactly 3 items")
else
    print("Array has fewer than 3 items")
end

-- Loop with potential issues
for i = 1, #items do
    print("Item " .. i .. ": " .. items[i])
end

-- Pairs loop with potential issues
for key, value in pairs(config) do
    print("Config " .. key .. ": " .. tostring(value))
end

-- Class-like structure with potential issues
local Person = {}
Person.__index = Person

function Person.new(name, age)
    local self = setmetatable({}, Person)
    self.name = name
    self.age = age
    return self
end

function Person:greet(greeting)
    greeting = greeting or "Hello"
    return greeting .. ", " .. self.name .. "!"
end

function Person:to_dict()
    return {
        name = self.name,
        age = self.age,
        greeting = self:greet()
    }
end

-- Module pattern with potential issues
local Utils = {}

function Utils.split(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)

    for match in string.gmatch(str, pattern) do
        table.insert(result, match)
    end

    return result
end

function Utils.join(tbl, delimiter)
    local result = ""
    for i, item in ipairs(tbl) do
        if i > 1 then
            result = result .. delimiter
        end
        result = result .. tostring(item)
    end
    return result
end

-- Error handling with potential issues
local function safe_divide(a, b)
    if b == 0 then
        error("Division by zero!")
    end
    return a / b
end

-- File operations with potential issues
local function write_sample_file()
    local file = io.open("sample.txt", "w")
    if not file then
        print("Failed to open file for writing")
        return
    end

    file:write("Sample Lua output\n")
    file:write("Generated at: " .. os.date() .. "\n")

    -- Missing file close
    -- file:close()
end

-- Function that's never called
local never_called = function()
    print("This function is never called")
end

-- Global function pollution
function pollute_global_scope()
    return "This pollutes global scope"
end

-- String manipulation with potential issues
local function process_text(text)
    -- Multiple string operations
    local upper = string.upper(text)
    local lower = string.lower(text)
    local reversed = string.reverse(text)

    return {
        original = text,
        upper = upper,
        lower = lower,
        reversed = reversed,
        length = string.len(text)
    }
end

-- Main execution with potential issues
local function main()
    -- Create person
    local person = Person.new("Alice", 25)
    print(person:greet("Hi there"))

    -- Process text
    local text = "Hello, World!"
    local processed = process_text(text)

    for key, value in pairs(processed) do
        print(key .. ": " .. tostring(value))
    end

    -- Test utils
    local parts = Utils.split("a,b,c,d", ",")
    local joined = Utils.join(parts, "-")
    print("Split and joined: " .. joined)

    -- Safe division
    local success, result = pcall(safe_divide, 10, 2)
    if success then
        print("Division result: " .. result)
    else
        print("Division error: " .. result)
    end

    -- Write file
    write_sample_file()

    -- Use of global variable
    global_var = "This should be local"
    print(global_var)

    -- Unused variable in main
    local main_unused = "This is not used"

    -- Missing return statement
end

-- Call main function
main()

-- Export for module usage
return {
    Person = Person,
    Utils = Utils,
    greet = greet,
    process_text = process_text
}
