local RepStorage = game:GetService("ReplicatedStorage")
local Items = RepStorage:WaitForChild("Items")
local Remotes = RepStorage:WaitForChild("Remotes")

local PlaceRemote = Remotes:WaitForChild("PlaceObject")

local function placeObject(plr, selectedItem, placedObjects, ghostTweenGoal)
	
	local newItem = selectedItem:Clone()
	newItem.Parent = placedObjects
	newItem:FindFirstChild("Base").Transparency = 1
	newItem:FindFirstChild("Base").CanTouch = true
	newItem:SetPrimaryPartCFrame(ghostTweenGoal.CFrame)
	
	
end

game.Players.PlayerAdded:Connect(function(plr)
	
	if not plr:FindFirstChild("Inventory") then
		
		local newInv = Instance.new("Folder")
		newInv.Name = "Inventory"
		
		newInv.Parent = plr
		
		for _, folder in Items:GetChildren() do
			
			local fClone = folder:Clone()
			fClone.Parent = newInv
			
			for _, item in fClone:GetChildren() do
				
				local itemName = item.Name
				
				item:Destroy()
				
				local newNumber = Instance.new("IntValue")
				newNumber.Parent = fClone
				newNumber.Name = itemName
				newNumber.Value = 1 -- saving / loading will go here
				
			end
			
		end
		
	end
	
end)

PlaceRemote.OnServerEvent:Connect(placeObject)
