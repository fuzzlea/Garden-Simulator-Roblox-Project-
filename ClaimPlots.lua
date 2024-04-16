local char = script.Parent
local plr = game.Players:GetPlayerFromCharacter(char)

local invUi = plr["PlayerGui"]["Inventory"]
invUi.Enabled = false

local preset_name = "Plot: " .. tostring(plr.UserId)

local Plots = workspace:WaitForChild("Map"):WaitForChild("Plots")

local function claimPlot(newPlot)
	
	if newPlot:GetAttribute("Plot") ~= "" then return end
	
	for _, plot in Plots:GetChildren() do if plot:GetAttribute("Plot") == preset_name then return end end
	
	newPlot.Name = preset_name
	newPlot:SetAttribute("Plot", preset_name)
	newPlot:FindFirstChild("BillboardGui").Enabled = false
	newPlot.CanCollide = false
	newPlot:FindFirstChild("Sign")["Who"]["SurfaceGui"]["TextLabel"].Text = plr.Name .. "'s Plot"
	
	plr:FindFirstChild("Plot").Value = newPlot
	plr["PlayerGui"]["Inventory"].Enabled = true
	
	-- ui
	
	invUi.Enabled = true
	
	print(newPlot)
	
end

char.PrimaryPart.Touched:Connect(function(hit)
	
	if hit:IsA("BasePart") and hit:GetAttribute("Plot") then
		
		claimPlot(hit)
		
	end
	
end)