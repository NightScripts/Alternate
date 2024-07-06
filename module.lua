local pnis = game:GetService("Players")
local alt = {}

local function FID(p, n, c)
    local o = p:FindFirstChild(n)
    if o and o:IsA(c) then
        return o
    end
end

local function GETCHR(e)
    return e and e.Character
end

local function GETHUM(e)
    local chr = GETCHR(e)
    return chr and FID(workspace.Alive, e.Name, "Model") and FID(chr, "Humanoid", "Humanoid")
end

function alt.isA(e)
    local hum = GETHUM(e)
    return hum and hum.Health > 0
end

function alt.gB()
    local bls = workspace:WaitForChild("Balls"):GetChildren()
    for i = 1, #bls do
        local b = bls[i]
        if b:IsA("BasePart") and b:GetAttribute("realBall") then
            return b
        end
    end
end

return alt
