-- loadstring(game:HttpGet("https://raw.githubusercontent.com/script-netizen/goon/refs/heads/main/encounters.lua"))()
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("DrRay", "Default")
local tab = window:newTab("Player", "ImageIdHere") -- Replace "ImageIdHere" if needed

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local RunService = game:GetService("RunService")

-- Connections
local energyConnection
local chargeConnection
local overhealConnection

-- Helper function to stop a connection
local function stopConnection(connection)
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Full Energy Toggle
tab.newToggle("FEnergy", "Full Energy!", false, function(state)
    if state then
        if not energyConnection then
            energyConnection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Energy") then
                    character.Energy.Value = 101
                end
            end)
        end
    else
        stopConnection(energyConnection)
    end
end)

-- Full Charge Toggle
tab.newToggle("Full Charge", "Full Charge!", false, function(state)
    if state then
        if not chargeConnection then
            chargeConnection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Charge") then
                    character.Charge.Value = 100
                end
            end)
        end
    else
        stopConnection(chargeConnection)
    end
end)

-- Overheal Toggle
tab.newToggle("Overheal", "Overheal!", false, function(state)
    if state then
        if not overhealConnection then
            local originalDamage = nil
            overhealConnection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("DamageTracker") then
                    local damageTracker = character.DamageTracker
                    if originalDamage == nil then
                        originalDamage = damageTracker.Value
                    end
                    damageTracker.Value = math.max(0, originalDamage - 2)
                end
            end)
        end
    else
        stopConnection(overhealConnection)
    end
end)


-- Example of setting theme (optional):
local mainColor = Color3.fromRGB(50, 75, 100) -- Example RGB values
local secondColor = Color3.fromRGB(75, 100, 125) -- Example RGB values
window:SetTheme(mainColor, secondColor)
