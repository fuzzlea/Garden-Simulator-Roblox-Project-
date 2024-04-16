local char = script.Parent
local plr = game.Players:GetPlayerFromCharacter(char)
local plrInventory = plr:WaitForChild("Inventory")

local map = workspace:WaitForChild("Map")
local discoverables = map:WaitForChild("Discoverable")

local forageRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ForageItem")

local function discoverNew(item)
	
	item.Value = 1
	print(item.Name .. " Found!")
	forageRemote:FireClient(plr, item.Name)
	
end

local function addDetectable(obj)
	
	print(obj.Name)
	
end

char.PrimaryPart.Touched:Connect(function(hit)
	
	if hit.Parent:IsA("Model") and hit.Parent.PrimaryPart and hit.Parent.PrimaryPart.Name == "Base" then
		
		local obj = hit.Parent
		
		if obj.Parent.Parent.Name ~= "Discoverable" then return end
		
		local objCategory = plrInventory:FindFirstChild(obj.Parent.Name)
		local objInInventory = objCategory:FindFirstChild(obj.Name)
		
		if objInInventory.Value == 0 then discoverNew(objInInventory) end
		
	end
	
end)