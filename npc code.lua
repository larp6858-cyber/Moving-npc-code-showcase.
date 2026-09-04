local pathfindingservice = game:GetService("PathfindingService")
local path = pathfindingservice:CreatePath({
	
	AgentCanClimb = true,
	AgentCanJump = true,
	WaypointSpacing = 3
	
})

local humanoid = script.Parent:FindFirstChild("Humanoid")
local HRP = script.Parent.HumanoidRootPart

local run = game:GetService("RunService")

local function closestTarget()
	local activate_distance = 100
	local target = nil

	for i, v in pairs(game.Workspace:GetChildren()) do
		local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")	
		if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v ~= script.Parent then
			
			if (HRP.Position - HumanoidRootPart.Position).Magnitude < activate_distance then
				activate_distance = (HRP.Position - HumanoidRootPart.Position).Magnitude
				target = HumanoidRootPart
			end
		end
	end
	return target
end

local currentWaypoints = {}
local nextWaypointIndex = 2

task.spawn(function()
	while true do	
		local Target = closestTarget()
		
		if Target then

		local success, errorMessage = pcall(function()
			path:ComputeAsync(HRP.Position, Target.Position)
		end)

		if success and path.Status == Enum.PathStatus.Success then
			 currentWaypoints = path:GetWaypoints()
			 nextWaypointIndex = 2
			
			else currentWaypoints = {}
			
			end
		end
		
		task.wait(0.1)
		
			end
		end)

while true do
	local Target = closestTarget()

	if Target then
		
		if #currentWaypoints > 0 and nextWaypointIndex <= #currentWaypoints then
			local waypoint = currentWaypoints[nextWaypointIndex]

			humanoid:MoveTo(waypoint.Position)

			if waypoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end

			local distance = (HRP.Position - waypoint.Position).Magnitude
			if distance <= 4 then
				nextWaypointIndex = nextWaypointIndex + 1
			end

		else
			humanoid:MoveTo(Target.Position)
		end
		
	else
		humanoid:MoveTo(HRP.Position)
	end

	task.wait(0.03)
end
