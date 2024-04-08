local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Modules = RepStorage:WaitForChild("Modules")
local Items = RepStorage:WaitForChild("Items")
local Remotes = RepStorage:WaitForChild("Remotes")

local Mod3d = require(Modules:WaitForChild("Module3D"))

local placementRemote = Remotes:WaitForChild("PlaceObject")

local invTemplate = script:WaitForChild("Template")
local typeTemplate = script:WaitForChild("TypeTemplate")
local billboardTemplate = script:WaitForChild("BillboardGui")
local sounds = script:WaitForChild("Sounds")

local gui = script.Parent
local invBase = gui:WaitForChild("Base")
local invTypes = gui:WaitForChild("Types")
local invIndex = gui:WaitForChild("Index")
local invMargin = invBase:WaitForChild("Margin")
local invKeybinds = gui:WaitForChild("BuildingKeybinds")
local invActions = gui:WaitForChild("Actions")
local openIndexButton = gui:WaitForChild("OpenIndex")
local gridButton = gui:WaitForChild("Grid")
local rotateButton = gui:WaitForChild("Rotate")

local indexMargin = invIndex:WaitForChild("Margin")
local indexFound = indexMargin:WaitForChild("Found")
local indexNotFound = indexMargin:WaitForChild("NotFound")

invIndex.Size = UDim2.new(0,0,0,0)
invIndex.Visible = false

local indexOpen = false
local selectedMenu

local plr = game.Players.LocalPlayer
local plrMouse = plr:GetMouse()
local plrInventory = plr:WaitForChild("Inventory")
local plrStates = plr:WaitForChild("States")
local plrBuilding = plrStates:WaitForChild("Building")

local prevItem

local gridSize = 1
local rotateAmount = 0
local rotateIncrement = 90

local buildingDebounce = false
local buildingPlacable = false

local BuildingConnections = {

	MouseMove = nil,
	ButtonUp = nil,
	Input = nil

}

local DeleteConnections = {

	MouseMove = nil,
	ButtonUp = nil

}

local GridSizes = {

	0.1,
	1,
	2,
	4,

}

local RotateSizes = {

	0.1,
	5,
	10,
	25,
	45,
	90,
	180

}
local Types = {

	"Decorations",
	"Trees",
	"Bushes / Rocks",
	"Paths",
	"Lights",
	"Testing"

}

local Keybinds = {

	Rotate = Enum.KeyCode.R,
	OppositeRotate = Enum.KeyCode.E,
	ResetRotation = Enum.KeyCode.T,
	Cancel = Enum.KeyCode.X,
	ChangeGridSize = Enum.KeyCode.G,
	ChangeRotateSize = Enum.KeyCode.V

}

local function changeGridSize()

	if gridSize == GridSizes[#GridSizes] then
		gridSize = GridSizes[1]
	else
		gridSize = GridSizes[table.find(GridSizes,gridSize) + 1]
	end

	gridButton.Text = GridSizes[table.find(GridSizes,gridSize)]

end

local function changeRotateSize()

	if rotateIncrement == RotateSizes[#RotateSizes] then
		rotateIncrement = RotateSizes[1]
	else
		rotateIncrement = RotateSizes[table.find(RotateSizes,rotateIncrement) + 1]
	end

	rotateButton.Text = RotateSizes[table.find(RotateSizes,rotateIncrement)]

end

local function deleteItem(cancel)

	local function deleteConnections()

		for _, connection in DeleteConnections do

			connection:Disconnect()

		end

	end

	if cancel then deleteConnections() return end

	if DeleteConnections.MouseMove ~= nil then deleteConnections() end

	plrMouse.TargetFilter = workspace:WaitForChild("Plots"):WaitForChild("Plot1"):WaitForChild("Sounds")
	
	local selectedPart

	DeleteConnections.MouseMove = plrMouse.Move:Connect(function()

		if plrMouse.Target == nil or plrMouse.Target.Name == "Baseplate" then return end
		
		if selectedPart and selectedPart:FindFirstChild("DeleteTag", true) then selectedPart:FindFirstChild("DeleteTag", true):Destroy() end

		if plrMouse.Target.Parent and plrMouse.Target.Parent:IsA("Model") and plrMouse.Target.Parent.PrimaryPart.Name == "Base" then

			selectedPart = plrMouse.Target.Parent

			local newDeleteTag = billboardTemplate:Clone()
			newDeleteTag.Name = "DeleteTag"
			newDeleteTag.Parent = selectedPart:FindFirstChild("Base")
			newDeleteTag.Enabled = true
			newDeleteTag["Label"].Text = "Delete " .. selectedPart.Name .. "?"
			newDeleteTag["Label"].Visible = true

		end

	end)
	
	DeleteConnections.ButtonUp = plrMouse.Button1Up:Connect(function()
		
		if selectedPart then
			
			selectedPart:Destroy()
			selectedPart = nil
			sounds["Delete"]:Play()
			
		end
		
	end)

end

local function clickItem(item, parent)

	for _, connection in BuildingConnections do

		connection:Disconnect()

	end

	for _, v in invMargin:GetChildren() do

		if v:IsA("ImageButton") then

			v.BackgroundColor3 = Color3.new(0,0,0)

		end

	end

	local function cancel()

		plrBuilding.Value = false

		if workspace:FindFirstChild(plr.UserId .. " Ghost", true) then workspace:FindFirstChild(plr.UserId .. " Ghost", true):Destroy() end

		for _, connection in BuildingConnections do

			connection:Disconnect()

		end

		for _, v in invMargin:GetChildren() do

			if v:IsA("ImageButton") then

				v.BackgroundColor3 = Color3.new(0,0,0)

			end

		end

	end

	if workspace:FindFirstChild(plr.UserId .. " Ghost", true) then workspace:FindFirstChild(plr.UserId .. " Ghost", true):Destroy() task.wait() end

	if item == "cancel_cancel" then cancel() return end

	if plrBuilding.Value == true and prevItem == item and BuildingConnections.MouseMove then cancel() return end

	plrBuilding.Value = true

	local plot = workspace:FindFirstChild("Plots"):FindFirstChild("Plot1")
	local placedObjects = plot:FindFirstChild("PlacedObjects")

	invMargin:FindFirstChild(item).BackgroundColor3 = Color3.new(0,255,0)

	local selectedItem = Items:FindFirstChild(parent):FindFirstChild(item)

	local ghostFolder = Instance.new("Folder", placedObjects)
	ghostFolder.Name = plr.UserId .. " Ghost"

	local ghostItem = selectedItem:Clone()
	ghostItem.Parent = ghostFolder

	billboardTemplate:Clone().Parent = ghostItem:FindFirstChild("Base")

	ghostItem:FindFirstChild("BillboardGui",true)["Label"].Text = selectedItem.Name
	ghostItem:FindFirstChild("BillboardGui",true).Enabled = true

	ghostItem.PrimaryPart.Transparency = 0.7

	local rotationAmount = 0

	for _, part in ghostItem:GetChildren() do

		if part:IsA("BasePart") and part.Name ~= "Base" and part.Name ~= "particles" then

			part.Transparency = 0.6
			part.CanCollide = false

		end

	end

	plrMouse.TargetFilter = placedObjects

	local ghostTweenGoal = {}

	local function position()

		if not ghostItem.PrimaryPart then return end

		if plrMouse.Target ~= plot then return end

		for _, part in workspace:GetPartsInPart(ghostItem.PrimaryPart) do

			if part.Name == "Base" then

				ghostItem.PrimaryPart.BrickColor = BrickColor.Red()

				buildingPlacable = false

				break

			end

			ghostItem.PrimaryPart.BrickColor = BrickColor.new(1020)

			buildingPlacable = true

		end

		ghostTweenGoal.CFrame = CFrame.new( math.floor(plrMouse.Hit.Position.X / gridSize + 0.5) * gridSize , plrMouse.Hit.Position.Y + ghostItem.PrimaryPart.Size.Y / 2 , math.floor(plrMouse.Hit.Position.Z / gridSize + 0.5) * gridSize ) * CFrame.Angles( 0 , math.rad(rotateAmount) , 0)

		local newTween = TweenService:Create(
			ghostItem.PrimaryPart,
			TweenInfo.new(0.13),
			ghostTweenGoal
		)

		newTween:Play()
		
	end

	BuildingConnections.MouseMove = plrMouse.Move:Connect(position)

	BuildingConnections.ButtonUp = plrMouse.Button1Up:Connect(function()

		if plrBuilding.Value == false then return end

		if buildingDebounce then return end

		if not buildingPlacable then return end

		buildingDebounce = true

		placementRemote:FireServer(selectedItem, placedObjects, ghostTweenGoal)
		sounds["Place"]:Play()

		task.wait(0.025)

		buildingDebounce = false

	end)

	BuildingConnections.Input = InputService.InputBegan:Connect(function(input, gpe)

		if gpe then return end

		if input.KeyCode == Keybinds["Rotate"] then

			rotateAmount += rotateIncrement

			position()

		end

		if input.KeyCode == Keybinds["OppositeRotate"] then

			rotateAmount -= rotateIncrement

			position()

		end

		if input.KeyCode == Keybinds["ResetRotation"] then

			rotateAmount = 0

			position()

		end

		if input.KeyCode == Keybinds["Cancel"] then cancel() end

		if input.KeyCode == Keybinds["ChangeGridSize"] then changeGridSize() end

		if input.KeyCode == Keybinds["ChangeRotateSize"] then changeRotateSize() end

	end)

	prevItem = item

end

local function updateIndex()
	
	local path = Items:FindFirstChild(selectedMenu)
	
	if not path then return end
	
	for _, currentItem in indexFound:GetChildren() do
		
		if currentItem:IsA("ImageButton") then
			
			currentItem:Destroy()
			
		end
		
	end
	
	for _, currentItem in indexNotFound:GetChildren() do

		if currentItem:IsA("ImageButton") then

			currentItem:Destroy()

		end

	end
	
	for _, item in path:GetChildren() do
		
		local itemInInv = plrInventory[selectedMenu][item.Name]
		
		local newIndexItem = invTemplate:Clone()
		newIndexItem.Name = item.Name
		
		local itemPart = path[item.Name]:Clone()
		
		local model3d = Mod3d:Attach3D(newIndexItem["Item"], itemPart)
		model3d.ZIndex = 5

		model3d:SetDepthMultiplier(1.6)
		model3d.Camera.FieldOfView = 75

		model3d.Visible = true
		
		if itemInInv.Value > 0 then

			newIndexItem.Parent = indexFound
			newIndexItem:FindFirstChild("Amount").Text = item.Name

		else

			newIndexItem.Parent = indexNotFound
			newIndexItem:FindFirstChild("Amount").Text = "???"

		end
		
	end

end

local function updateSelectedMenu(which)

	if not which then warn("no menu selected to update") return end

	selectedMenu = which
	updateIndex()

	for _, v in invTypes:GetChildren() do

		if v:IsA("TextButton") then v.TextColor3 = Color3.new(255,255,255) end

	end

	invTypes[selectedMenu].TextColor3 = Color3.new(0.054902, 0.717647, 1)

	for _, button in invMargin:GetChildren() do

		if button:IsA("ImageButton") then button:Destroy() end

	end

	for _, folder in plrInventory:GetChildren() do

		if folder.Name == selectedMenu then

			for _, item in folder:GetChildren() do

				if item.Value > 0 then

					local templateClone = invTemplate:Clone()
					templateClone.Parent = invMargin
					templateClone.Name = item.Name
					templateClone:FindFirstChild("Amount").Text = tostring(item.Name)

					templateClone.MouseEnter:Connect(function() sounds["Hover"]:Play() end)

					local itemPart = Items[folder.Name][item.Name]:Clone()

					local model3d = Mod3d:Attach3D(templateClone["Item"], itemPart)
					model3d.ZIndex = 5

					model3d:SetDepthMultiplier(1.6)
					model3d.Camera.FieldOfView = 5

					model3d.Visible = true

					RunService.RenderStepped:Connect(function()
						model3d:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-2),0,0))
					end)

					templateClone.MouseButton1Click:Connect(function() clickItem(itemPart.Name, selectedMenu) sounds["Click"]:Play() end)

				end

			end

		end

	end

end

local function changeMenu(menu)

	-- hide everything

	local function hideEverything()

		-- modes
		clickItem("cancel_cancel")
		deleteItem("cancel")

		-- build
		invBase.Visible = false
		invKeybinds.Visible = false
		invTypes.Visible = false
		gridButton.Visible = false
		openIndexButton.Visible = false
		rotateButton.Visible = false

	end

	hideEverything()

	if menu == "Build" then

		invBase.Visible = true
		invKeybinds.Visible = true
		invTypes.Visible = true
		gridButton.Visible = true
		openIndexButton.Visible = true
		rotateButton.Visible = true

	end

	if menu == "Delete" then

		hideEverything()

		deleteItem()

	end

	if menu == "None" then return end

end

local function openIndex()
	
	if indexOpen == false then
		
		indexOpen = true
		invIndex.Visible = true
		
		sounds["Bag Close"]:Play()
		
		invIndex:TweenSize(
			UDim2.new(0.571,0,0.63,0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Back,
			0.25,
			true
		)
		
	else
		
		invIndex:TweenSize(
			UDim2.new(0,0,0,0),
			Enum.EasingDirection.In,
			Enum.EasingStyle.Back,
			0.25,
			true,
			function()
				invIndex.Visible = false
			end
		)
		
		indexOpen = false
		
	end
	
end

for i, v in Types do

	local newType = typeTemplate:Clone()

	newType.Name = v
	newType.Text = v
	newType.Parent = invTypes

	newType.MouseButton1Click:Connect(function() updateSelectedMenu(v) sounds["Click"]:Play() end)
	newType.MouseEnter:Connect(function() sounds["Hover"]:Play() end)

end

for _, v in invActions:GetChildren() do

	if v:IsA("ImageButton") then

		v.MouseEnter:Connect(function()

			sounds["Hover"]:Play()

			v:TweenSize(
				UDim2.new(0.039, 0,1.19, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Back,
				0.25,
				true
			)

		end)

		v.MouseLeave:Connect(function()

			sounds["Hover"]:Play()

			v:TweenSize(
				UDim2.new(0.032, 0,1, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Back,
				0.25,
				true
			)

		end)

		v.MouseButton1Click:Connect(function()

			sounds["Click"]:Play()

			if v.Name == "Build" then changeMenu("Build") end

			if v.Name == "Delete" then changeMenu("Delete") end
			
			if v.Name == "Viewmode" then changeMenu("None") end

		end)

	end

end

gridButton.MouseButton1Click:Connect(changeGridSize)
rotateButton.MouseButton1Click:Connect(changeRotateSize)
openIndexButton.MouseButton1Click:Connect(openIndex)

gridButton.MouseEnter:Connect(function() sounds["Hover"]:Play() end)
rotateButton.MouseEnter:Connect(function() sounds["Hover"]:Play() end)
openIndexButton.MouseEnter:Connect(function() sounds["Hover"]:Play() end)

updateSelectedMenu("Testing")
changeMenu("None")
changeGridSize()
