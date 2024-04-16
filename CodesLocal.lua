local RepStorage = game:GetService("ReplicatedStorage")

local Remotes = RepStorage:WaitForChild("Remotes")
local Codes = RepStorage:WaitForChild("Codes")
local Sounds = script:WaitForChild("Sounds")

local codesRemote = Remotes:WaitForChild("UseCode")

local plr = game.Players.LocalPlayer
local plrCodes = plr:WaitForChild("Codes")

local ui = script.Parent
local codeInput = ui:WaitForChild("CodeInput")
local submit = ui:WaitForChild("TextButton")

local Messages = {
	"Code Not Found!",
	"Code No Longer Valid!",
	"Code Already Used!",
	"Success!"
}

local function sendCode(code)
	
	local message = Messages[4]
	
	if Codes:FindFirstChild(code) then
		
		if Codes:FindFirstChild(code).Value == true then
			
			if not plrCodes:FindFirstChild(code) then
				
				codesRemote:FireServer(code)

			else
				
				message = Messages[3]
				
			end
			
		else
			
			message = Messages[2]
			
		end
		
	else
		
		message = Messages[1]
		
	end
	
	if message == Messages[4] then Sounds["CodeValid"]:Play() else Sounds["CodeInvalid"]:Play() end
	
	codeInput.Text = message
	
	task.wait(1)
	
	codeInput.Text = ""
	
end

submit.MouseButton1Click:Connect(function() sendCode(codeInput.Text) end)