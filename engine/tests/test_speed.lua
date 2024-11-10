local startTime = os.clock()

local sum = 0
for i = 1, 100000000 do
    sum = sum + i
end

local endTime = os.clock()
print("Lua: " .. (endTime - startTime) .. " seconds")
print("Sum =", sum)