--// Hypershot Enemy ESP + Hitbox (Executor Version)
--// Tested logic: Solara / executor environment

getgenv().Settings = {
    HitboxEnabled = true,
    ESPEnabled = true,
    HitboxSize = 10
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--================ TEAM CHECK =================--
local function isEnemy(player)
    if player == LocalPlayer then return false end

    -- FFA
    if LocalPlayer.Team == nil or player.Team == nil then
        return true
    end

    return player.Team ~= LocalPlayer.Team
end

--================ HITBOX =================--
local function applyHitbox(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.Size = Vector3.new(
        Settings.HitboxSize,
        Settings.HitboxSize,
        Settings.HitboxSize
    )

    hrp.Transparency = 0.7
    hrp.Material = Enum.Material.Neon
    hrp.Color = Color3.fromRGB(255,0,0)
    hrp.CanCollide = false
end

--================ ESP =================--
local function applyESP(char)
    local esp = char:FindFirstChild("EnemyESP")
    if not esp then
        esp = Instance.new("Highlight")
        esp.Name = "EnemyESP"
        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        esp.FillTransparency = 0.3
        esp.OutlineTransparency = 0
        esp.OutlineColor = Color3.new(0,0,0)
        esp.Parent = char
    end

    esp.FillColor = Color3.fromRGB(255,0,0)
    esp.Adornee = char
end

--================ MAIN LOOP =================--
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character then
            if Settings.HitboxEnabled then
                applyHitbox(player.Character)
            end

            if Settings.ESPEnabled then
                applyESP(player.Character)
            end
        end
    end
end)
