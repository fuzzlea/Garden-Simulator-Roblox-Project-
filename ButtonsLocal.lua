local buttons = script.Parent

local panel = buttons.Parent:WaitForChild("UIPanel")
local panel_close = panel:WaitForChild("CloseButton")

panel.Position = UDim2.new(0.5,0,1.5,0)

local Sounds = script:WaitForChild("Sounds")

local open = false
local currentMenu = "none"

local function windowPopup(op)
	
	if op then
		
		panel:TweenPosition(
			UDim2.new(0.5,0,0.5,0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Back,
			0.5,
			true,
			function()
				open = true
			end
		)
		
	else
		
		panel:TweenPosition(
			UDim2.new(0.5,0,1.5,0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Back,
			0.5,
			true,
			function()
				open = false
			end
		)
		
	end
	
end

local function clickButton(button)
	
	currentMenu = button
	
	for _, frame in panel:GetChildren() do
		
		if frame:IsA("Frame") then frame.Visible = false end
		
	end
	
	if button == nil then return end
	
	if not panel:FindFirstChild(button) then return end
	
	panel:FindFirstChild(button).Visible = true
	
end

for _, button in buttons:GetChildren() do
	
	if button:IsA("ImageButton") then
		
		button.MouseEnter:Connect(function()
			
			Sounds["Hover"]:Play()
			
			button:TweenSize(
				UDim2.new(0.101,0,1.344,0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Back,
				0.25,
				true
			)
			
		end)
		
		button.MouseLeave:Connect(function()

			button:TweenSize(
				UDim2.new(0.073,0,1,0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Back,
				0.25,
				true
			)

		end)
		
		button.MouseButton1Click:Connect(function()

			Sounds["Click"]:Play()
			
			if open and currentMenu == button.Name then windowPopup(false) end
			
			if open == false then windowPopup(true) end

			clickButton(button.Name)

		end)
		
	end
	
end

panel_close.MouseButton1Click:Connect(function() Sounds["Click"]:Play() windowPopup(false) end)
panel_close.MouseEnter:Connect(function() Sounds["Hover"]:Play() end)

clickButton(nil)