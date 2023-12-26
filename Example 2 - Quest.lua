local player = game.Players.LocalPlayer
local GUI = player:WaitForChild("PlayerGui")
local QuestNotis = GUI:WaitForChild("QuestNotification")
local QuestEvent = game.ReplicatedStorage.QuestEvent
local QuestTemplate = game.ReplicatedStorage.QuestTemplate
local TweenService = game:GetService("TweenService")
local QuestGUI = GUI:WaitForChild("Operation Account")
local Selected = nil
local playing = false

local function getQuest()
	local Quests = {}
	for i,v in QuestGUI.Main.Operations:GetChildren() do
		if v:IsA("TextButton") then
			table.insert(Quests, v)
		end
	end
	return Quests
end

local function createbutton(Quest)
	local QuestButton = QuestTemplate:Clone()
	QuestButton.NameDisplay.Text = Quest[2]
	QuestButton.Zone.Text = Quest[3]
	QuestButton.Zone.TextColor3 = Quest[4]
	QuestButton.Name = Quest[1]
	QuestButton.Progress.Text = tostring(QuestButton.ProgressInt.Value) .. "/" .. tostring(Quest[5])
	QuestButton.OverallProg.Text = tostring(QuestButton.ProgressInt.Value) .. "/" .. tostring(Quest[13]) 
	QuestButton.Parent = QuestGUI.Main.Operations
	QuestButton.MouseEnter:Connect(function()
		QuestGUI["Additional Info"].QuestName.Text = Quest[2]
		QuestGUI["Additional Info"]["The info"].Info.Difficulty.Text = "DIFFICULTY: <font color=" .. Quest[12] .. ">" .. Quest[6] ..  "</font>"
		QuestGUI["Additional Info"]["The info"].Assigner.Text = Quest[7]
		QuestGUI["Additional Info"]["The info"].Assigner.TextColor3 = Quest[8]
		QuestGUI["Additional Info"]["The info"].Zone.Text = Quest[3]
		QuestGUI["Additional Info"]["The info"].Zone.TextColor3 = Quest[4]
		QuestGUI["Additional Info"]["The info"].Class.Text = Quest[9]
		QuestGUI["Additional Info"]["The info"].Class.TextColor3 = Quest[10]
		QuestGUI["Additional Info"]["The info"]["Description Text"].Text = Quest[11]
	end)
	QuestButton.MouseButton1Up:Connect(function()
		local Quests = getQuest()
		local selectednil = false
		TweenService:Create(QuestButton.Frame.Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {BackgroundColor3 = Color3.new(1,0/255,0/255)}):Play()
		TweenService:Create(QuestButton.SelectedText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TextTransparency = 0}):Play()
		for i,v in Quests do
			if v.Name ~= Quest[1] then
				TweenService:Create(v.Frame.Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
				TweenService:Create(v.SelectedText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TextTransparency = 1}):Play()
			elseif Selected == Quest[1] then
				TweenService:Create(v.Frame.Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
				TweenService:Create(v.SelectedText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {TextTransparency = 1}):Play()
				selectednil = true

			end
		end
		if selectednil then
			Selected = nil
		else
			Selected = Quest[1]
		end
	end)
	return QuestButton
end

function PlayAnim(Quest, Done)
	if playing == true then
		repeat
			task.wait()
		until playing == false
	end
	playing = true
	QuestNotis = GUI:WaitForChild("QuestNotification")
	if Done then
		QuestNotis.Maintext.Text = "OPERATION COMPLETE: " .. Quest[2]
		QuestNotis.Difficulty.Text = "COMPLETED"
	else
		QuestNotis.Maintext.Text = "OPERATION TAKEN: " .. Quest[2]
		QuestNotis.Difficulty.Text = "DIFFICULTY: <font color=" .. Quest[12] .. ">" .. Quest[6] ..  "</font>"
	end
	QuestNotis.Enabled = true
	local QuestLog = GUI:WaitForChild("Operation Account")
	TweenService:Create(QuestNotis.Difficulty, TweenInfo.new(0.75,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {TextTransparency = 0}):Play()
	TweenService:Create(QuestNotis.Maintext, TweenInfo.new(0.75,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {TextTransparency = 0}):Play()
	for i = 0, 15 do
		wait(0.01)
		TweenService:Create(QuestNotis.SCPLOGO, TweenInfo.new(0.01,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {ImageTransparency = 1}):Play()
		wait(0.01)
		TweenService:Create(QuestNotis.SCPLOGO, TweenInfo.new(0.01,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {ImageTransparency = 0.7}):Play()
	end
	TweenService:Create(QuestNotis.SCPLOGO, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut,0,false,0), {Rotation = 360}):Play()
	wait(4)
	TweenService:Create(QuestNotis.Difficulty, TweenInfo.new(0.75,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {TextTransparency = 1}):Play()
	TweenService:Create(QuestNotis.Maintext, TweenInfo.new(0.75,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {TextTransparency = 1}):Play()
	TweenService:Create(QuestNotis.SCPLOGO, TweenInfo.new(0.75,Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false,0), {ImageTransparency = 1}):Play()
	wait(1)
	QuestNotis.Enabled = false
	playing = false
end

QuestEvent.OnClientEvent:Connect(function(player, Quest, ChangeProg, progress, ChangeOverall, OverallProg, OverallProgVal, Destroy)
	GUI = player:WaitForChild("PlayerGui")
	if Destroy then
		QuestGUI.Main.Operations:FindFirstChild(Quest[1]):Destroy()
		PlayAnim(Quest, true)
	end
	if not ChangeProg then
		local Button = createbutton(Quest)
		print(Button.Parent)
		QuestEvent:FireServer(player, Quest)
		PlayAnim(Quest, false)
	end
	if ChangeProg and not Destroy then
		if QuestGUI.Main.Operations:FindFirstChild(Quest[1]) then
			QuestGUI.Main.Operations:FindFirstChild(Quest[1]).Progress.Text = tostring(progress) .. "/" .. tostring(Quest[5]) 
		end
		if ChangeOverall then
			QuestGUI.Main.Operations:FindFirstChild(Quest[1]).Progress.Text = tostring(progress) .. "/" .. tostring(OverallProg) 
			QuestGUI.Main.Operations:FindFirstChild(Quest[1]).OverallProg.Text = tostring(OverallProgVal) .. "/" .. tostring(Quest[13]) 
		end
	end
end)
