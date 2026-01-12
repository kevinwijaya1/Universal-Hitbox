--// Hypershot Enemy Hitbox + Aim Assist + Menu
--// Client-side helper (ESP & hitbox only)

--================ CONFIG =================--
_G.Settings = {
    HitboxEnabled = true,
    AimAssist = false,
    AimPart = "Head", -- "Head" / "HumanoidRootPart"
    HitboxSize = 10,
    MenuKey = Enum.KeyCode.RightShift
}

--================ SERVICES =================--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--================ UTILS =================--
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
    local part = char:FindFirstChild("HumanoidRootPart")
    if not part then return end

    part.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
    part.Transparency = 0.7
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(255, 0, 0)
    part.CanCollide = false
end

--================ ESP =================--
local function applyESP(char)
    local h = char:FindFirstChild("EnemyESP")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "EnemyESP"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillTransparency = 0.3
        h.OutlineTransparency = 0
        h.OutlineColor = Color3.new(0,0,0)
        h.Parent = char
    end
    h.FillColor = Color3.fromRGB(255,0,0)
    h.Adornee = char
end

--================ AIM ASSIST =================--
local function getClosestEnemy()
    local closest, dist = nil, math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if isEnemy(p) and p.Character then
            local part = p.Character:FindFirstChild(_G.Settings.AimPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(screenPos.X, screenPos.Y)
                        - UserInputService:GetMouseLocation()).Magnitude
                    if d < dist then
                        dist = d
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if isEnemy(p) and p.Character then
            if _G.Settings.HitboxEnabled then
                applyHitbox(p.Character)
                applyESP(p.Character)
            end
        end
    end

    -- Aim Assist (manual helper)
    if _G.Settings.AimAssist then
        local target = getClosestEnemy()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Position),
                0.15
            )
        end
    end
end)

--================ MENU UI =================--
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "HypershotMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25, 0.35)
frame.Position = UDim2.fromScale(0.37, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Visible = false

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,8)

local function makeToggle(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

makeToggle("Toggle Hitbox", function()
    _G.Settings.HitboxEnabled = not _G.Settings.HitboxEnabled
end)

makeToggle("Toggle Aim Assist", function()
    _G.Settings.AimAssist = not _G.Settings.AimAssist
end)

makeToggle("Aim Head / Body", function()
    _G.Settings.AimPart =
        _G.Settings.AimPart == "Head" and "HumanoidRootPart" or "Head"
end)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == _G.Settings.MenuKey then
        frame.Visible = not frame.Visible
    end
end)
