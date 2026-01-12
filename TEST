_G.HeadSize = 10
_G.Disabled = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function applyPropertiesToPart(part)
    if not part then return end
    part.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
    part.Transparency = 0.7
    part.BrickColor = BrickColor.new("Really blue")
    part.Material = Enum.Material.Neon
    part.CanCollide = false
end

local function applyHighlight(model, color)
    local highlight = model:FindFirstChild("HighlightESP")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "HighlightESP"
        highlight.OutlineColor = Color3.new(0,0,0)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model
    end
    highlight.FillColor = color
    highlight.Adornee = model
end

local function setupCharacter(character, color)
    if not _G.Disabled then return end

    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        applyPropertiesToPart(hrp)
        applyHighlight(character, color)
    end
end

-- Existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            task.spawn(setupCharacter, player.Character, Color3.fromRGB(0,170,255))
        end
        player.CharacterAdded:Connect(function(char)
            setupCharacter(char, Color3.fromRGB(0,170,255))
        end)
    end
end

-- New players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            setupCharacter(char, Color3.fromRGB(0,170,255))
        end)
    end
end)
