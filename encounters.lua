-- loadstring(game:HttpGet("https://raw.githubusercontent.com/script-netizen/goon/refs/heads/main/encounters.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ULTRA-Encounters", "Ocean")
local Tab1 = Window:NewTab("Player")
local Tab1Section = Tab1:NewSection("Values")

local player = game.Players.LocalPlayer  -- Get the LocalPlayer
local character = player.Character or player.CharacterAdded:Wait() -- Wait for the character to load

local RunService = game:GetService("RunService")

local heartbeatConnection -- Declare the connection variable outside the function

local Toggle = Tab1Section:NewToggle("FEnergy", "Full Energy!", function(state)
    if state then  -- Toggle is now ON
        if not heartbeatConnection then -- Check if a connection exists
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                character.Energy.Value = 101 -- Sets health to max
            end)
        end
    else  -- Toggle is now OFF
        if heartbeatConnection then -- Check if a connection exists
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil -- Important: Reset the variable
        end
    end
end)
