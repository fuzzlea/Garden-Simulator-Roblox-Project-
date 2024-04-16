local MPS = game:GetService("MarketplaceService")

local GP = {
	
	NoCollisions = 779699437
	
}

game.Players.PlayerAdded:Connect(function(plr)
	
	local gamepassesFolder = plr:WaitForChild("Gamepasses")
	
	for ind, gp in GP do
		
		if MPS:UserOwnsGamePassAsync(plr.UserId, gp) then
			
			if gamepassesFolder:FindFirstChild(tostring(ind)) then
				
				gamepassesFolder:FindFirstChild(tostring(ind)).Value = true
				
			end
			
		end		
		
	end
	
end)