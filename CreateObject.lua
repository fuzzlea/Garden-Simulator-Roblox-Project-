-- this is just to save my time when creating an object

-- require(game.ReplicatedStorage.Modules.CreateObject).Create()

local module = {}

function module.Create(obj)
	
	local base = obj:FindFirstChild("Base")
	base.Anchored = true
	base.CanCollide = false
	
	obj.PrimaryPart = base
	
	for _, part in obj:GetChildren() do
		
		if not part:IsA("Model") then
			
			part.Anchored = false
			
			local newWeld = Instance.new("WeldConstraint", base)
			newWeld.Part0 = base
			newWeld.Part1 = part
			
		end
		
	end
	
end

return module