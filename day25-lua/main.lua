local function transform(num, loops)
    local val = 1
    for _ = 1, loops do val = (val * num) % 20201227 end
    return val
end

local function bruteForce(pk)
    local count = 0
    local val = 1
    while val ~= pk do
        count = count + 1
        val = (val * 7) % 20201227
    end
    return count
end

local p1 = 1965712
local p2 = 19072108

local pc1 = bruteForce(p1)
local pc2 = bruteForce(p2)
print(pc1, pc2)

local ek = transform(p1, pc2)
assert(ek == transform(p2, pc1))
print(ek)
