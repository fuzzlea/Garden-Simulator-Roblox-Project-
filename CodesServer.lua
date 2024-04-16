local RepStorage = game:GetService("ReplicatedStorage")

local Modules = RepStorage:WaitForChild("Modules")
local Items = RepStorage:WaitForChild("Items")
local Remotes = RepStorage:WaitForChild("Remotes")
local Codes = RepStorage:WaitForChild("Codes")

local UseCodeRemote = Remotes:WaitForChild("UseCode")
local NewItemRemote = Remotes:WaitForChild("ForageItem")

local function useCode(plr, code)
	
	local playerCodes = plr:WaitForChild("Codes")
	local onFileCode
	
	if Codes:FindFirstChild(code) then onFileCode = Codes:FindFirstChild(code) else return end
	
	if onFileCode and onFileCode.Value == true then
		
		if onFileCode.Value == false then return end
		
		if playerCodes:FindFirstChild(code) then return end
		
		local codeRewards = onFileCode["Rewards"]
		
		local cantDoTwice = Instance.new("StringValue", playerCodes)
		cantDoTwice.Name = code
		
		for x, category in codeRewards:GetChildren() do
			
			if plr:FindFirstChild(category.Name) then
				
				local plrCat = plr:FindFirstChild(category.Name)
				
				for y, reward in category:GetChildren() do
					
					if plrCat:FindFirstChild(reward.Name, true) then
						
						local plrReward = plrCat:FindFirstChild(reward.Name, true)
						
						plrReward.Value += reward.Value
						
						if category.Name == "Inventory" then
							
							NewItemRemote:FireClient(plr, plrReward.Name)
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

UseCodeRemote.OnServerEvent:Connect(useCode)