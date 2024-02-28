local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local isLockOn = false
local targetPlayer = nil
local box = nil

local function createBox(player)
    local torso = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if torso then
        local boxSize = Vector3.new(4, 8, 2) -- Change the size as needed
        box = Instance.new("BoxHandleAdornment")
        box.Size = boxSize
        box.Adornee = torso
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Color3 = Color3.new(0, 1, 0) -- Change the color as needed
        box.Transparency = 0.5 -- Change transparency as needed
        box.Parent = torso
    end
end

local function updateBoxPosition(player)
    local torso = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if torso and box then
        local boxPosition = torso.Position
        boxPosition = camera:WorldToViewportPoint(boxPosition)
        box.Position = Vector2.new(boxPosition.X, boxPosition.Y)
    end
end

local function removeBox()
    if box then
        box:Destroy()
        box = nil
    end
end

local function lockOntoPlayer(player)
    targetPlayer = player
    isLockOn = true
    createBox(player)
end

local function unlockPlayer()
    targetPlayer = nil
    isLockOn = false
    removeBox()
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        local mouseTarget = UserInputService.MouseTarget
        local player = game.Players:GetPlayerFromCharacter(mouseTarget.Parent)
        if player and player ~= localPlayer then
            lockOntoPlayer(player)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        unlockPlayer()
    end
end)

RunService.RenderStepped:Connect(function()
    if isLockOn and targetPlayer and targetPlayer.Character then
        updateBoxPosition(targetPlayer)
    else
        unlockPlayer()
    end
end)
