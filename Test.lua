_G.HeadSize = 10
_G.Disabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local PLAYER_COLOR = Color3.fromRGB(0,170,255)
local MOB_COLOR = Color3.fromRGB(255,0,0)

local function applyPropertiesToPart(part)
    if not part then return end
    if part.Size.X == _G.HeadSize then return end -- prevent spam reset

    part.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
    part.Transparency = 0.7
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Really blue")
    part.CanCollide = false
end

local function applyHighlight(model, color)
    local h = model:FindFirstChild("HighlightESP")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "HighlightESP"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.OutlineColor = Color3.new(0,0,0)
        h.OutlineTransparency = 0
        h.FillTransparency = 0.3
        h.Parent = model
    end

    -- FORCE color every frame (biar gak ngasal)
    h.FillColor = color
    h.Adornee = model
end

RunService.RenderStepped:Connect(function()
    if not _G.Disabled then return end

    -- PLAYERS
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    applyPropertiesToPart(hrp)
                    applyHighlight(char, PLAYER_COLOR)
                end
            end
        end
    end

    -- MOBS (optional, aman kalau folder ada)
    local mobs = workspace:FindFirstChild("Mobs")
    if mobs then
        for _, mob in ipairs(mobs:GetChildren()) do
            if mob:IsA("Model") then
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hrp then
                    applyPropertiesToPart(hrp)
                    applyHighlight(mob, MOB_COLOR)
                end
            end
        end
    end
end)
