-- loadstring(game:HttpGet("https://raw.githubusercontent.com/script-netizen/goon/refs/heads/main/encounters.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ULTRA-Encounters", "Ocean")
local Tab1 = Window:NewTab("Player")
local Tab1Section = Tab1:NewSection("Values")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local RunService = game:GetService("RunService")

-- Connections
local energyConnection
local chargeConnection
local overhealConnection

-- Helper function to stop a connection (reduces code duplication)
local function stopConnection(connection)
    if connection then
        connection:Disconnect()
        connection = nil
    end
end


local Toggle = Tab1Section:NewToggle("FEnergy", "Full Energy!", function(state)
    if state then
        if not energyConnection then
            energyConnection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Energy") then -- Check again just in case
                    character.Energy.Value = 101
                end
            end)
        end
    else
        stopConnection(energyConnection)
    end
end)

local Toggle2 = Tab1Section:NewToggle("FCharge", "Full Charge!", function(state)
    if state then
        if not chargeConnection then
            chargeConnection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("Charge") then -- Check again just in case
                    character.Charge.Value = 100
                end
            end)
        end
    else
        stopConnection(chargeConnection)
    end
end)


local Toggle3 = Tab1Section:NewToggle("OVERheal", "Overheal!", function(state)
    if state then
        if not overhealConnection then
          local originalDamage = nil -- Store original damage value
            overhealConnection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("DamageTracker") then
                  local damageTracker = character.DamageTracker
                  if originalDamage == nil then -- Get it only once.
                    originalDamage = damageTracker.Value
                  end
                    DamageTracker.Value = math.max(0, originalDamage - 2) -- Subtract 2, but don't go below 0
                end
            end)
        end
    else
        stopConnection(overhealConnection)
    end
end)
