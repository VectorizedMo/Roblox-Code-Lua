local HoneyBadger = {"Honey Badger"}
local player = game.Players.LocalPlayer
local VM_Honey = game.ReplicatedStorage.ViewModels.v_honey
local PlayerGUI = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Hotbar = PlayerGUI:WaitForChild("HotBar")
local HotBarFrames = {Hotbar.Frame.Frame1, Hotbar.Frame.Frame2, Hotbar.Frame.Frame3, Hotbar.Frame.Frame4, Hotbar.Frame.Frame5}
local heldown = false
local binded
local AimCF = CFrame.new()
local shooting = false
local recoil  = CFrame.new()
local recoilx = 0
local recoily = 0.03
local camera = workspace.CurrentCamera
local recoilAmount = 0.001
local maxRecoil = 10
local recoilSpeed = 5
local cooldownTime = 0.1 
local recoilUpAmount = 0.001
local recoilbackamount = 0.09
local shots = 0
local cameraup = 0
local cameraside = 0
local Camupcount = 0
local CanShoot = true
local springmodule = require(game.ReplicatedStorage.SpringModule)
local RecoilSpring = springmodule.new(Vector3.new())
RecoilSpring.Speed = 25
RecoilSpring.Damper = 1
local OOC = 2
local REC = 1
local RECOILDAMPNER = 0.5
local RECOILS = {
	{2,4},
	{16,22},
	{12,18},
	{10,16}
}
local RECOILSY = {
	{-6,6},
	{6,8},
	{8,10},
	{5,7},
}
local RECOILS1 = {
	{-1,1},
	{-2,2},
	{-3,3},
	{-5,-5}
}
local RESETRECOIL = .075
local Recoilreset = Vector3.new(2,0,10)
local KICK
local OldCFrame
local recoilback = CFrame.new()
local num = 0
local Recoil
local goback
local recoilcount = Vector3.new()
local lastshottime
local SEMIROF = 1
local RecoilSpringV
local TweenService = game:GetService('TweenService')
local RecoilSpringV2
local TweenFrame
local debounce = false
local measureresetback = false
local recoilreset3 = Vector3.new()
local GunSpring = springmodule.new(Vector3.new())
GunSpring.Speed = 25
GunSpring.Damper = .4
local MouseSpring = springmodule.new(Vector3.new())
MouseSpring.Speed = 15
MouseSpring.Damper = .75
local val = true
local unbind = false
local damagevent = game.ReplicatedStorage.DamageEvent
local swayspring = springmodule.new(Vector3.new())
swayspring.Speed = 20
swayspring.Damper = .1
local flashconn
local shootconn
local aimconn1
local aimconn2
local binded = false
local KickSpring = springmodule.new(Vector3.new())
KickSpring.Speed = 20
KickSpring.Damper = .75
local CD = 60/800
local Hitmarker = PlayerGUI:WaitForChild("Hitmarker")
local Hit = false
local scoping = false
local sprinting = false
local playerchar = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(char)
	PlayerGUI = player:WaitForChild("PlayerGui")
	Hitmarker = PlayerGUI:WaitForChild("Hitmarker")
end)
local Smoke = VM_Honey["Right Arm"]["Honey Badger"].Main.Smoke
local initialSmokeSize = 1
local initialSmokeRate = 30
local ConnMapping = {aimconn1, aimconn2,flashconn, shootconn}

UIS.InputBegan:Connect(function(input,gp)
	if input.KeyCode == Enum.KeyCode.LeftShift and not gp then
		sprinting = true
	end
end)
UIS.InputEnded:Connect(function(input,gp)
	if input.KeyCode == Enum.KeyCode.LeftShift and not gp then
		sprinting = false
	end
end)

local function applyrecoil(shots,StartShoot)
	if shots < #RECOILS then
		shots += 1
	end
	Recoil = Recoilreset
	if time() - StartShoot > OOC then
		Recoil += Vector3.new(math.sin((2*(time()-StartShoot)))*5*0,math.sin(5*(time()-StartShoot))*5, 0)
	elseif time() - StartShoot > REC then
		Recoil += Vector3.new(0, math.sin(5*(time()-StartShoot))*1.5,0)
	end

	local x = math.random(RECOILS[shots][1]*10/10, RECOILS[shots][2]*10/10)
	local y = math.random(RECOILS1[shots][1]*10/10, RECOILS1[shots][2]*10/10)
	local z = 0
	if num <= 2 then
		goback = true
		Recoil += Vector3.new(7,2,1)
	else
		goback = false
		Recoil += Vector3.new(x,y,z)
	end
	--Recoil += Vector3.new(math.random(14,20),math.random(4,6),math.random(0.8,1.2))
	GunSpring.Velocity += Vector3.new(math.random(20,30)/100, Recoil.Y/25,0)
	RecoilSpring.Velocity += Recoil
	--recoil = CFrame.new(recoilAmount, recoilUpAmount, recoilbackamount)
	KickSpring.Velocity += Vector3.new(0,0,5)
	--wait(0.0375)
	recoil = CFrame.new()
	if num >= 13 then
		Smoke.Enabled = true
	end
	num += 1
	return Recoil
end


local function shoot()
	--Smoke.Size = NumberSequence.new(initialSmokeSize+0.025)
	--Smoke.Rate = NumberSequence.new(initialSmokeRate+1)
	--initialSmokeRate += 1
	--initialSmokeSize += 0.025
	game.SoundService.KrissSound:Play()
	task.delay(0.025, function()
		--game.SoundService.ShellCasing:Play()
	end)	
	local starttime = time()
	local bullet = Instance.new("Part")
	--bullet.Parent = workspace
	bullet.Material = Enum.Material.Neon
	bullet.BrickColor = BrickColor.new("Red flip/flop")
	bullet.Size = Vector3.new(0.25,0.25,2)
	bullet.CastShadow = false
	bullet.Position = VM_Honey["Right Arm"]["Honey Badger"].Main.Position + VM_Honey["Right Arm"]["Honey Badger"].Main.CFrame.UpVector
	local cameraX,cameraY,cameraZ = camera.CFrame:ToOrientation()
	if cameraX < 0 then
		cameraX = -cameraX
	end
	--bullet.Orientation = Vector3.new(-math.deg(cameraX),VM_Honey["Right Arm"]["Honey Badger"].Main.Orientation.Y,VM_Honey["Right Arm"]["Honey Badger"].Main.Orientation)
	--bullet:ApplyImpulse(Vector3.new(camera.CFrame.LookVector.Unit.X*75, camera.CFrame.LookVector.Unit.Y*100, camera.CFrame.LookVector.Unit.Z*75))
	bullet.Anchored = false
	bullet.Touched:Connect(function(hit)
		if hit.Parent ~= VM_Honey["Right Arm"]["Honey Badger"] and hit.Parent ~= VM_Honey and hit.Parent ~= playerchar then
			--print(hit.Parent)
			--bullet:Destroy()
		end
	end)

	local ray = Ray.new(bullet.Position, camera.CFrame.LookVector*1500)
	local rayPart = Instance.new("Part")
	rayPart.Name = player.Name
	rayPart.Transparency = 1
	rayPart.Material = Enum.Material.Neon
	rayPart.BrickColor = BrickColor.new("Lime green")
	rayPart.Size = Vector3.new(0.1, 0.1, ray.Direction.Magnitude)
	rayPart.CFrame = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction) * CFrame.new(0, 0, -rayPart.Size.Z/2)
	rayPart.Anchored = true
	rayPart.CanCollide = false
	rayPart.Parent = workspace
	rayPart.CastShadow = false
	task.delay(0.05,function()
		rayPart:Destroy()
	end)
	local raycastparams = RaycastParams.new()
	raycastparams.FilterDescendantsInstances = {rayPart}
	raycastparams.FilterType = Enum.RaycastFilterType.Blacklist
	local hit = workspace:Raycast(ray.Origin, ray.Direction,raycastparams)
	if hit then
		if hit.Instance.Name == "Head" then
			damagevent:FireServer(hit.Instance,55)
		else
			damagevent:FireServer(hit.Instance,33)
		end
		if hit.Instance.Parent:FindFirstChild("Humanoid") then
			if hit.Instance.Name == "Head" then
				for i,v in pairs(Hitmarker:GetChildren()) do
					v.BackgroundColor3 = Color3.new(150/255)
					v.BorderSizePixel = 0
				end
			else
				for i,v in pairs(Hitmarker:GetChildren()) do
					v.BackgroundColor3 = Color3.new(0.75,0.75,0.75)
					v.BorderColor3 = Color3.new(27/255,42/255,53/255)
					v.BorderSizePixel = 0
				end
			end
			for i,v in pairs(Hitmarker:GetChildren()) do
				TweenService:Create(v, TweenInfo.new(0.15,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0),  {BackgroundTransparency = 0}):Play()
			end
			task.delay(0.2,function()
				if not shooting then
					for i,v in pairs(Hitmarker:GetChildren()) do
						TweenService:Create(v, TweenInfo.new(0.15,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0),  {BackgroundTransparency = 1}):Play()
					end
				end
			end)
		end
	end
end

local function GetBobbing(starttime, strengthx, strengthy)
	local BobbleX = math.cos(starttime*10) * strengthx
	local BobbleY = math.sin(starttime*10) * strengthy
	return CFrame.new(BobbleX, BobbleY, 0)
end

UIS.InputBegan:Connect(function(input,gp)
	if input.KeyCode == Enum.KeyCode.LeftShift and not gp then
		workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(0), math.rad(0),math.rad(45))
		sprinting = true
	end
end)
UIS.InputEnded:Connect(function(input,gp)
	if input.KeyCode == Enum.KeyCode.LeftShift and not gp then
		sprinting = false
	end
end)

local function showHoney()
	local StartTime = time()
	local MouseDelta = UIS:GetMouseDelta()	
	MouseSpring.Velocity += Vector3.new(MouseDelta.X/200, MouseDelta.Y/100)
	local Bobble = CFrame.new()
	if playerchar:WaitForChild("Humanoid").MoveDirection.Magnitude > 0 then
		if not scoping then
			if sprinting then
				Bobble = GetBobbing(StartTime, 0.05,0.05)
			else
				Bobble = GetBobbing(StartTime,0.025,0.025)
			end
		else
			if sprinting then
				Bobble = GetBobbing(StartTime, 0.01,0.01)
			else
				Bobble = GetBobbing(StartTime, 0.005, 0.005)
			end
		end
	end
	VM_Honey:SetPrimaryPartCFrame(camera.CFrame * AimCF * recoil * recoilback * CFrame.Angles(GunSpring.Position.X, GunSpring.Position.Y,0) * CFrame.Angles(0,-MouseSpring.Position.X, MouseSpring.Position.Y) * CFrame.new(KickSpring.Position))
	if scoping == true then
		local offset = VM_Honey["Right Arm"]["Honey Badger"].AimPart.CFrame:ToObjectSpace(VM_Honey.PrimaryPart.CFrame)
		AimCF = AimCF:Lerp(offset,0.3)
	else
		local offset = CFrame.new()
		AimCF = AimCF:Lerp(offset,0.3)
	end
	if shooting == true then
		--local offset1 = (camera.CFrame * CFrame.Angles(math.rad(RecoilSpring.Position.X), math.rad(RecoilSpring.Position.Y), math.rad(RecoilSpring.Position.Z)))
		--camera.CFrame = camera.CFrame:Lerp(offset1,0.01)
		--camera.CFrame = camera.CFrame:Lerp((camera.CFrame * CFrame.Angles(math.rad(RecoilSpring.Position.X), math.rad(RecoilSpring.Position.Y), math.rad(RecoilSpring.Position.Z))),0.2)
		--camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(RecoilSpring.Position.X), math.rad(RecoilSpring.Position.Y), math.rad(RecoilSpring.Position.Z))
		--print(RecoilSpring.Position.X, RecoilSpring.Position.Y, RecoilSpring.Position.Z, "shooting")
	else
		--print(RecoilSpring.Position.X, RecoilSpring.Position.Y, RecoilSpring.Position.Z, "stop")
	end
	if measureresetback then
		local scaledPos = RecoilSpring.Position * 1000000000000
		recoilreset3 += Vector3.new(scaledPos.X, scaledPos.Y, scaledPos.Z)
	end
	camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(RecoilSpring.Position.X), math.rad(RecoilSpring.Position.Y), math.rad(RecoilSpring.Position.Z))
	--camera.CFrame = camera.CFrame:Lerp((camera.CFrame * CFrame.Angles(math.rad(RecoilSpring.Position.X), math.rad(RecoilSpring.Position.Y), math.rad(RecoilSpring.Position.Z))),0.2)
end



local function findselected()
	for i = 1,5  do
		if HotBarFrames[i].Equipped.Value == true then
			return i
		end
	end
end


function HoneyBadger.showViewModel(selectedframe)
	if binded then
		RunService:UnbindFromRenderStep("ModelHoney")
	end
	for i = 1, #ConnMapping do
		ConnMapping[i]:Disconnect()
	end
	if selectedframe.Item.Value == "Honey Badger" and selectedframe.Equipped.Value then
		VM_Honey.Parent = workspace
		RunService:BindToRenderStep("ModelHoney", Enum.RenderPriority.Camera.Value, showHoney)
		binded = true
		game.ReplicatedStorage.HoneyBadgerEquipped.Value = true
		aimconn1 = UIS.InputBegan:Connect(function(input,gp)
			if input.UserInputType == Enum.UserInputType.MouseButton2 and not gp then
				if findselected() ~= nil then
					if HotBarFrames[findselected()].Item.Value == "Honey Badger" and scoping == false then
						scoping = true
						TweenService:Create(camera, TweenInfo.new(0.3,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 49}):Play()
					end
				end
			end
		end)
		aimconn2 = UIS.InputEnded:Connect(function(input,gp)
			if input.UserInputType == Enum.UserInputType.MouseButton2 and not gp then
				if findselected() ~= nil then
					if HotBarFrames[findselected()].Item.Value == "Honey Badger" and scoping then
						TweenService:Create(camera, TweenInfo.new(0.3,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 70}):Play()
						scoping = false
					end
				end
			end
		end)
		shootconn = UIS.InputBegan:Connect(function(input,gp)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not gp then
				if findselected() ~= nil then
					if HotBarFrames[findselected()].Item.Value == "Honey Badger" then
						measureresetback = true
						if debounce then return end
						debounce = true
						local diffx,diffy,diffz = camera.CFrame:ToOrientation()
						local initialVelocity = RecoilSpring.Velocity
						RecoilSpringV = Vector3.new(math.deg(RecoilSpring.Velocity.X),math.deg(RecoilSpring.Velocity.Y), math.deg(RecoilSpring.Velocity.Z))
						OldCFrame = camera.CFrame
						local a,b,c = OldCFrame:ToOrientation()
						shooting = true
						local StartShoot = time()
						repeat 
							shoot()
							recoilcount += applyrecoil(shots, StartShoot)
							--print('shot')
							wait(CD)
						until shooting == false or num >= 30
						task.delay(0.001, function()
							debounce = false
						end)
						task.delay(RESETRECOIL,function()
							local CurrentFrameX,CurrentFrameY,CurrentFrameZ = camera.CFrame:ToOrientation()
							--print(math.deg(CurrentFrameX-a))
							local startTime = tick()
							local duration = 0.25
							measureresetback = false
							recoilreset3 /= 1000000000000
							--print(recoilreset3.X)
							while (tick() - startTime) < duration do
								if shooting then
									break
								end
								local t = (tick() - startTime) / duration
								local x,y,z = camera.CFrame:ToOrientation()
								local differencex = CurrentFrameX - math.rad(recoilreset3.X) - x 
								TweenFrame = camera.CFrame * CFrame.Angles(differencex,CurrentFrameY- math.rad(recoilreset3.Y) - y,0)
								--camera.CFrame = camera.CFrame:Lerp(TweenFrame, t)
								wait()
							end
							recoilreset3 = Vector3.new()
						end)
						task.delay(RESETRECOIL,function()
							--RecoilSpring.Velocity -= recoilcount
							--recoilcount = Vector3.new()
						end)
					end
				end
			end
			if input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.Tab then
				shooting = false
			end
		end)
		UIS.InputEnded:Connect(function(input,gp)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not gp then
				if findselected() ~= nil then
					if HotBarFrames[findselected()].Item.Value == "Honey Badger" then
						lastshottime = tick()
						shooting = false
						CanShoot = false
						shots = 0
						num = 0
						task.delay(0.2,function()
							if not shooting then
								for i,v in pairs(Hitmarker:GetChildren()) do
									TweenService:Create(v, TweenInfo.new(0.15,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0),  {BackgroundTransparency = 1}):Play()
								end
							end
						end)
						task.delay(0.1, function()
							if shooting ~= true then
								Smoke.Enabled = false
							end
						end)
					end
				end
			end
		end)
		flashconn = UIS.InputBegan:Connect(function(input,gp)
			if input.KeyCode == Enum.KeyCode.F and not gp then
				VM_Honey["Right Arm"]["Honey Badger"].Main.SpotLight.Enabled = not VM_Honey["Right Arm"]["Honey Badger"].Main.SpotLight.Enabled
			end
		end)
		ConnMapping = {aimconn1,aimconn2,flashconn,shootconn}
	else
		if game.ReplicatedStorage.HoneyBadgerEquipped.Value == true or game.ReplicatedStorage.HoneyBadgerEquipped.Scoping.Value == true then
			VM_Honey.Parent = game.ReplicatedStorage
			camera.FieldOfView = 70
		end
		game.ReplicatedStorage.HoneyBadgerEquipped.Scoping.Value = false
		game.ReplicatedStorage.HoneyBadgerEquipped.Value = false
		VM_Honey["Right Arm"]["Honey Badger"].Main.SpotLight.Enabled = false
		RunService:UnbindFromRenderStep("ModelHoney")
		binded = false
		shooting = false
	end
	
end




function HoneyBadger.removeViewModel(mode)
	if mode == "Normal" then
		shooting = false
		scoping = false
		TweenService:Create(camera, TweenInfo.new(0.3,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 70}):Play()
		RunService:UnbindFromRenderStep("ModelHoney")
		VM_Honey.Parent = game.ReplicatedStorage
		VM_Honey["Right Arm"]["Honey Badger"].Main.SpotLight.Enabled = false
	else
		shooting = false
		scoping = false
		TweenService:Create(camera, TweenInfo.new(0.3,Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {FieldOfView = 70}):Play()
	end
end


return HoneyBadger
