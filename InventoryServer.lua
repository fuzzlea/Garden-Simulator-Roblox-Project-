local RepStorage = game:GetService("ReplicatedStorage")
local Items = RepStorage:WaitForChild("Items")
local Remotes = RepStorage:WaitForChild("Remotes")

local PlaceRemote = Remotes:WaitForChild("PlaceObject")
local ClaimPlotRemote = Remotes:WaitForChild("ClaimPlot")
local DeleteRemote = Remotes:WaitForChild("DeleteObject")

local function deleteObject(plr, object)
	
	object:Destroy()
	
end

local function placeObject(plr, selectedItem, placedObjects, ghostTweenGoal)

	local newItem = selectedItem:Clone()
	newItem.Parent = placedObjects
	newItem:FindFirstChild("Base").Transparency = 1
	newItem:FindFirstChild("Base").CanTouch = true
	newItem:SetPrimaryPartCFrame(ghostTweenGoal.CFrame)


end

game.Players.PlayerAdded:Connect(function(plr)
	
	local inventory = plr:WaitForChild("Inventory")

	repeat task.wait() until inventory
	
	for _, folder in Items:GetChildren() do

		local fClone = folder:Clone()
		fClone.Parent = inventory

		for _, item in fClone:GetChildren() do

			local itemName = item.Name

			item:Destroy()

			local newNumber = Instance.new("IntValue")
			newNumber.Parent = fClone
			newNumber.Name = itemName
			newNumber.Value = 1 -- saving / loading will go here

		end

	end

end)

game.Players.PlayerRemoving:Connect(function(plr)

	local plrPlot

	if workspace:WaitForChild("Map"):WaitForChild("Plots"):FindFirstChild("Plot: " .. tostring(plr.UserId)) then plrPlot = workspace:WaitForChild("Map"):WaitForChild("Plots"):FindFirstChild("Plot: " .. tostring(plr.UserId)) else return end

	plrPlot:SetAttribute("Plot","")
	plrPlot:FindFirstChild("BillboardGui").Enabled = true
	plrPlot:FindFirstChild("Sign")["Who"]["SurfaceGui"]["TextLabel"].Text = "Unclaimed"

	for _, placedObject in plrPlot:FindFirstChild("PlacedObjects"):GetChildren() do

		placedObject:Destroy()

	end

	plrPlot.Name = "Plot _"


end)

PlaceRemote.OnServerEvent:Connect(placeObject)
DeleteRemote.OnServerEvent:Connect(deleteObject)