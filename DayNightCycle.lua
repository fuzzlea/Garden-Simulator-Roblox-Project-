-- created by: 'shadowcalen1' on the devforum, edited a wee bit by me

local mam --minutes after midnight
local timeShift = 0.25 --how many minutes you shift every "tick"
local waitTime = 1/30 --legnth of the tick
local pi = math.pi

while task.wait(waitTime) do
	--time changer
	mam = game.Lighting:GetMinutesAfterMidnight() + timeShift
	game.Lighting:SetMinutesAfterMidnight(mam)
	mam = mam/60

end