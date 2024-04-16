local folderToClone = script:WaitForChild("plr")

game.Players.PlayerAdded:Connect(function(plr)
	
	for _, content in folderToClone:GetChildren() do
		
		if plr:FindFirstChild(content.Name) then break end
		
		local clone = content:Clone()
		clone.Parent = plr
		
	end
	
end)