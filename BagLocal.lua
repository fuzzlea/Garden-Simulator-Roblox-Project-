local RepStorage = game:GetService("ReplicatedStorage")

local Bag = RepStorage:WaitForChild("Items"):WaitForChild("Bag")

local plr = game.Players.LocalPlayer
local plrInventory = plr:WaitForChild("Inventory")
local plrBag = plrInventory:WaitForChild("Bag")

local itemTemplate = script:WaitForChild("ItemTemplate")

local ui = script.Parent
local margin = ui:WaitForChild("Margin")

local function updateMargin()
	
	for _, thing in margin:GetChildren() do
		
		if not thing:IsA("UIGridLayout") then thing:Destroy() end
		
	end
	
	for _, item in plrBag:GetChildren() do

		if item.Value > 0 then

			local newTemplate = itemTemplate:Clone()
			newTemplate.Parent = margin
			newTemplate.Name = item.Name

			newTemplate:FindFirstChild("ItemImage").Image = Bag:FindFirstChild(item.Name):FindFirstChild("Image").Texture
			newTemplate:FindFirstChild("ItemAmount").Text = tostring(item.Value)

		end

	end
	
end

updateMargin()

for _, value in plrBag:GetChildren() do
	
	value:GetPropertyChangedSignal("Value"):Connect(updateMargin)
	
end
