-- Load external dependencies
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Constants
local ENERGY_MAX = 101
local CHARGE_MAX = 100
local DAMAGE_UPDATE_INTERVAL = 0.5

-- Initialize UI
local window = DrRayLibrary:Load("DrRay!", "Default")
local tab1 = DrRayLibrary.newTab("Tab 1", "ImageIdHere")

-- State management
local State = {
    player = Players.LocalPlayer,
    character = nil,
    connections = {
        energy = nil,
        charge = nil,
        overheal = nil,
        characterAdded = nil
    },
    originalDamage = nil,
    toggleStates = {
        energy = false,
        charge = false,
        overheal = false
    }
}

-- Helper functions
local function stopConnection(connectionName)
    if State.connections[connectionName] then
        State.connections[connectionName]:Disconnect()
        State.connections[connectionName] = nil
    end
end

local function stopAllConnections()
    for name, _ in pairs(State.connections) do
        stopConnection(name)
    end
end

local function setupCharacterConnections()
    if not State.character then return end
    
    -- Reconnect active toggles
    for toggle, isActive in pairs(State.toggleStates) do
        if isActive then
            if toggle == "energy" then
                State.connections.energy = RunService.Heartbeat:Connect(function()
                    if State.character:FindFirstChild("Energy") then
                        State.character.Energy.Value = ENERGY_MAX
                    end
                end)
            elseif toggle == "charge" then
                State.connections.charge = RunService.Heartbeat:Connect(function()
                    if State.character:FindFirstChild("Charge") then
                        State.character.Charge.Value = CHARGE_MAX
                    end
                end)
            elseif toggle == "overheal" then
                State.connections.overheal = RunService.Heartbeat:Connect(function()
                    if State.character:FindFirstChild("DamageTracker") then
                        local damageTracker = State.character.DamageTracker
                        if not State.originalDamage then
                            State.originalDamage = damageTracker.Value
                        end
                        damageTracker.Value = math.max(0, State.originalDamage - 2)
                        task.wait(DAMAGE_UPDATE_INTERVAL)
                    end
                end)
            end
        end
    end
end

local function handleCharacterAdded(char)
    State.character = char
    State.originalDamage = nil
    setupCharacterConnections()
end

-- Initialize character tracking
State.connections.characterAdded = State.player.CharacterAdded:Connect(handleCharacterAdded)
State.character = State.player.Character or State.player.CharacterAdded:Wait()

-- UI Elements
tab1.newButton("Update", "Reconnect player values", function()
    stopAllConnections()
    State.originalDamage = nil
    handleCharacterAdded(State.player.Character)
end)

tab1.newToggle("FEnergy", "Full Energy!", false, function(state)
    State.toggleStates.energy = state
    stopConnection("energy")
    
    if state then
        State.connections.energy = RunService.Heartbeat:Connect(function()
            if State.character and State.character:FindFirstChild("Energy") then
                State.character.Energy.Value = ENERGY_MAX
            end
        end)
    end
end)

tab1.newToggle("Full Charge", "Full Charge!", false, function(state)
    State.toggleStates.charge = state
    stopConnection("charge")
    
    if state then
        State.connections.charge = RunService.Heartbeat:Connect(function()
            if State.character and State.character:FindFirstChild("Charge") then
                State.character.Charge.Value = CHARGE_MAX
            end
        end)
    end
end)

tab1.newToggle("Overheal", "Overheal!", false, function(state)
    State.toggleStates.overheal = state
    stopConnection("overheal")
    
    if state then
        State.connections.overheal = RunService.Heartbeat:Connect(function()
            if State.character and State.character:FindFirstChild("DamageTracker") then
                local damageTracker = State.character.DamageTracker
                if not State.originalDamage then
                    State.originalDamage = damageTracker.Value
                end
                damageTracker.Value = math.max(0, State.originalDamage - 2)
                task.wait(DAMAGE_UPDATE_INTERVAL)
            end
        end)
    end
end)
