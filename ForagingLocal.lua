local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Modules = RepStorage:WaitForChild("Modules")
local Items = RepStorage:WaitForChild("Items")
local Remotes = RepStorage:WaitForChild("Remotes")

local Mod3d = require(Modules:WaitForChild("Module3D"))

local ForageRemote = Remotes:WaitForChild("ForageItem")

local Sounds = script:WaitForChild("Sounds")

local forageUi = script:WaitForChild("Forage")
forageUi.Enabled = false

local plr = game.Players.LocalPlayer

ForageRemote.OnClientEvent:Connect(function(item)
	
	if plr.PlayerGui:FindFirstChild("Forage") then repeat task.wait() until not plr.PlayerGui:FindFirstChild("Forage") end
	
	local newForageUi = forageUi:Clone()
	newForageUi.Parent = plr.PlayerGui
	
	Sounds["Forage"]:Play()
	
	local itemPart = Items:FindFirstChild(item, true):Clone()
	itemPart:FindFirstChild("Base").Transparency = 1
	
	if itemPart then
		
		local model3d = Mod3d:Attach3D(newForageUi["ItemImage"], itemPart)
		model3d:SetDepthMultiplier(1.2)
		model3d.Camera.FieldOfView = 5
		model3d.Visible = true
		
		model3d.AdornFrame.Ambient = Color3.fromHex("#ffffff")
		model3d.AdornFrame.LightColor = Color3.fromHex("#ffffff")
		
		RunService.RenderStepped:Connect(function()
			model3d:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
		end)
		
	end
	
	newForageUi["ItemName"].Text = item
	newForageUi["BG"].Transparency = 1
	
	local bgTween1 = TweenService:Create(
		newForageUi["BG"],
		TweenInfo.new(0.75),
		{Transparency = 0.45}
	)

	bgTween1:Play()
	
	newForageUi["ItemImage"].Size = UDim2.new(0,0,0,0)
	
	newForageUi["ItemImage"]:TweenSize(
		UDim2.new(0, 570, 0, 570),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Back,
		0.75,
		true
	)
	
	newForageUi["ItemName"].Size = UDim2.new(0,0,0,0)

	newForageUi["ItemName"]:TweenSize(
		UDim2.new(0.442, 0, 0.168, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Back,
		0.75,
		true
	)
	
	newForageUi["YouFound"].Size = UDim2.new(0,0,0,0)

	newForageUi["YouFound"]:TweenSize(
		UDim2.new(1, 0, 0.076, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Back,
		0.75,
		true
	)
	
	newForageUi.Enabled = true
	
	task.wait(2)
	
	Sounds["Forage2"]:Play()
	
	newForageUi["ItemImage"]:TweenSize(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Back,
		1.3,
		true
	)
	
	newForageUi["ItemName"]:TweenSize(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Back,
		0.75,
		true
	)
	
	newForageUi["YouFound"]:TweenSize(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Back,
		0.75,
		true
	)
	
	local bgTween2 = TweenService:Create(
		newForageUi["BG"],
		TweenInfo.new(0.75),
		{Transparency = 1}
	)
	
	bgTween2:Play()
	
	task.wait(2)
	
	newForageUi:Destroy()
	
end)