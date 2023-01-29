hookfunction(game.Players.LocalPlayer.IsInGroup, function() return true end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nosssa/NossLock/main/AntiAimViewer"))()
local lib = loadstring(game:HttpGet("https://pastebin.com/raw/3A9wdSkL"))()

lib.TeamCheck(false)



local Workspace = game:GetService("Workspace")

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")



local LocalPlayer = Players.LocalPlayer

local Mouse = LocalPlayer:GetMouse()

local CurrentCamera = Workspace.CurrentCamera


---------------------------------------------------------------
local aimsets = {
    
    sa = true,

    al = false,

    pre = 0.1,

    akb = Enum.KeyCode.E,

    Resolver = true,
    
}
--------------------------------------------------
getgenv().aimsets = aimsets        
getgenv().lib.radius = 7                         
--------------------------------------------------- -radius 5.5-6.6 is legit

function lib.Check()

    if not (lib.Enabled == true and lib.Selected ~= LocalPlayer and lib.SelectedPart ~= nil) then

        return false

    end

    local Character = lib.Character(lib.Selected)

    local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value

    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil

    if (KOd or Grabbed) then

        return false

    end

    return true

end



task.spawn(function()

    while task.wait() do

        if aimsets.Resolver and lib.Selected ~= nil and (lib.Selected.Character)  then

            local oldVel = game.Players[lib.Selected.Name].Character.HumanoidRootPart.Velocity

            game.Players[lib.Selected.Name].Character.HumanoidRootPart.Velocity = Vector3.new(oldVel.X, -0, oldVel.Z)

        end 

    end

end)



local Script = {Functions = {}}



Script.Functions.getToolName = function(name)

    local split = string.split(string.split(name, "[")[2], "]")[1]

    return split

end



Script.Functions.getEquippedWeaponName = function(player)

   if (player.Character) and player.Character:FindFirstChildWhichIsA("Tool") then

      local Tool =  player.Character:FindFirstChildWhichIsA("Tool")

      if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and not string.find(Tool.Name, "Phone") then 

         return Script.Functions.getToolName(Tool.Name)

      end

   end

   return nil

end



game:GetService("RunService").RenderStepped:Connect(function()

    if Script.Functions.getEquippedWeaponName(game.Players.LocalPlayer) ~= nil then

        local WeaponSettings = GunSettings[Script.Functions.getEquippedWeaponName(game.Players.LocalPlayer)]

        if WeaponSettings ~= nil then

            lib.radius = WeaponSettings.radius

        else

            lib.radius = 5

        end

    end    

end)

local __index

__index = hookmetamethod(game, "__index", function(t, k)

    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and lib.Check()) then

        local SelectedPart = lib.SelectedPart

        if (aimsets.sa and (k == "Hit" or k == "Target")) then

            local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * aimsets.pre)

            return (k == "Hit" and Hit or SelectedPart)

        end

    end



    return __index(t, k)

end)



RunService:BindToRenderStep("al", 0, function()

    if (aimsets.al and lib.Check() and UserInputService:IsKeyDown(aimsets.akb)) then

        local SelectedPart = lib.SelectedPart

        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * aimsets.pre)

        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)

    end
end)