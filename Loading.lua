--Variables

local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local LoadingScreen
local TweenService = game:GetService("TweenService")
local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
local AbleToLeave = false
local UIS = game:GetService("UserInputService")
local FinalText = [[Loading please wait
Starting: Attempting to run Load.cpp
Login Process Initiated.

Scanning 5 areas for memory corruption
Result: 1 found
Redundant Data at 0x7f5a1ea14260

clang++ file/RobotDesign/Load.cpp
./a.out

#include <iostream>
#include <RobotDesign>
#include <vector>

int main() {
    //Used to initiate Loading for Robot Design
    std::cout << "Hello World!";
    bool Result;
    int LoginResult = AskForRobotLogin();
    Result = (LoginResult==0)?true:false;
    if (!!Result){
        LoadRoboteer();
        std::cout << "Here we go!"
    }
    return 0;
}]]


-- Main Function
function InitiateLoading(UI)
	UI.Enabled = true
	local StartTime = time()
	local Code = UI.Code
	local ConcurrentString = ''
	Code.KeyboardClicking:Play()
	for i = 1, string.len(FinalText)-137 do
		ConcurrentString = ConcurrentString .. string.sub(FinalText,i,i) .. "|"
		Code.Text = ConcurrentString
		task.wait()
		ConcurrentString = string.gsub(ConcurrentString, "|", "")
	end
	Code.KeyboardClicking:Pause()
	print(time()-StartTime)
	Login(UI)
	wait(0.35)
	DeloadLogin(UI)
	Code.KeyboardClicking:Play()
	for j = string.len(FinalText)-137, string.len(FinalText) do
		ConcurrentString = ConcurrentString .. string.sub(FinalText,j,j) .. "|"
		Code.Text = ConcurrentString
		task.wait()
		ConcurrentString = string.gsub(ConcurrentString, "|", "")
	end
	Code.KeyboardClicking:Pause()
	TweenService:Create(Code, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	wait(0.5)
	Load(UI)
	
end

-- Accessory Functions
function Login(UI)
	TweenService:Create(UI.NameBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
	TweenService:Create(UI.Login, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
	TweenService:Create(UI.NameBar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Transparency = 0}):Play()
	TweenService:Create(UI.Pass, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
	TweenService:Create(UI.PassBar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Transparency = 0}):Play()
	TweenService:Create(UI.Emblem, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {ImageTransparency = 0}):Play()
	local NameBar = UI.NameBar
	local PassBar = UI.PassBar
	local LoginText = ''
	local PassText = ''
	wait(0.5)
	for i = 1, string.len(player.Name) do
		LoginText = LoginText .. string.sub(player.Name,i,i)
		NameBar.Text = LoginText
		task.wait(math.random(10,15)/150)
	end
	wait(0.2)
	for i = 1, string.len(player.Name) do
		PassText = PassText ..  "*"
		PassBar.Text = PassText
		task.wait(math.random(10,15)/150)
	end
	wait(0.15)
	TweenService:Create(UI.Authenticated, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
end

function DeloadLogin(UI)
	TweenService:Create(UI.NameBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.Login, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.NameBar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Transparency = 1}):Play()
	TweenService:Create(UI.Pass, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.PassBar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Transparency = 1}):Play()
	TweenService:Create(UI.Authenticated, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.NameBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.PassBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.Emblem, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {ImageTransparency = 1}):Play()
end

function Load(UI)
	TweenService:Create(UI.Loading.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Transparency = 0}):Play()
	TweenService:Create(UI.Reason, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
	for i = 1,33 do
		TweenService:Create(UI.Loading:FindFirstChild(tostring(i)), TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {BackgroundTransparency = 0.7}):Play()
		wait(math.random(10,15)/75)
	end
	UI.Reason.Text = 'Finished'
	TweenService:Create(UI.Loading.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Transparency = 1}):Play()
	TweenService:Create(UI.Reason, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	for i = 1,33 do
		TweenService:Create(UI.Loading:FindFirstChild(tostring(i)), TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {BackgroundTransparency = 1}):Play()
	end
	wait(1)
	TweenService:Create(UI.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
	TweenService:Create(UI.Emblem1, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {ImageTransparency = 0}):Play()
	wait(0.1)
	task.delay(0.1, function()
		TweenService:Create(UI.Warping, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
		TweenService:Create(UI.Emblem1, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {Rotation = 360}):Play()
		for i=0,10 do
			if i%2 == 0 then
				TweenService:Create(UI.Emblem1, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {ImageTransparency = 0}):Play()
			else
				TweenService:Create(UI.Emblem1, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {ImageTransparency = 1}):Play()
			end
			wait(0.07)
		end
	end)
	local StringToUse = "ROBOT DESIGN"
	local ReplacedString = ''
	for i = 1, string.len(StringToUse) do
		ReplacedString = ''
		for j = 1, i+1 do
			ReplacedString = ReplacedString .. string.sub(StringToUse, j,j)
		end
		for k = 1, string.len(StringToUse)-i do
			ReplacedString = ReplacedString .. 'X'
		end
		UI.Title.Text = ReplacedString
		wait(0.1)
	end
	for i = 0, 10 do
		UI.Title.Text = shufflestr(StringToUse)
		wait(0.05)
	end
	UI.Title.Text = StringToUse
	wait(0.75)
	TweenService:Create(UI["Press X"], TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 0}):Play()
	AbleToLeave = true
end

function shufflestr(str)
	local list = string.split(str, "")
	local returned = {}
	for i = 1, #list do
		local val = list[math.random(1,#list)]
		table.insert(returned, val)
		table.remove(list, table.find(list, val))
	end
	local strin = ''
	for j = 1, #returned do
		strin = strin .. returned[j]
	end
	return strin
end

function Exit(UI)
	TweenService:Create(UI.Emblem1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {ImageTransparency = 1}):Play()
	TweenService:Create(UI.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.Warping, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI["Press X"], TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {TextTransparency = 1}):Play()
	TweenService:Create(UI.Black, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0,false,0), {BackgroundTransparency = 1}):Play()
end



-- Trigger
PlayerGui.ChildAdded:Connect(function(child)
	if child.Name == "Loading Screen" then
		LoadingScreen = child
		local ConfirmExit
		local ExitConn = UIS.InputBegan:Connect(function(input, gp)
			print(input.KeyCode)
			if input.KeyCode == Enum.KeyCode.X and not gp and AbleToLeave then
				Exit(LoadingScreen)
				ConfirmExit = true
			end
		end)
		InitiateLoading(LoadingScreen)
	end
end)