local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function createUI()
	local G2L = {}
	G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
	G2L["1"]["Name"] = "Library"
	G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
	G2L["1"]["ResetOnSpawn"] = false
	
	G2L["2"] = Instance.new("Frame", G2L["1"])
	G2L["2"]["BorderSizePixel"] = 0
	G2L["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
	G2L["2"]["Size"] = UDim2.new(0, 500, 0, 300)
	G2L["2"]["Position"] = UDim2.new(0.5, -250, 0.5, -150)
	G2L["2"]["Name"] = "Holder"
	
	Instance.new("UIStroke", G2L["2"]).Color = Color3.fromRGB(97, 37, 151)
	Instance.new("UICorner", G2L["2"])
	
	G2L["5"] = Instance.new("TextLabel", G2L["2"])
	G2L["5"]["TextSize"] = 14
	G2L["5"]["TextXAlignment"] = Enum.TextXAlignment.Left
	G2L["5"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	G2L["5"]["TextColor3"] = Color3.fromRGB(201, 121, 255)
	G2L["5"]["BackgroundTransparency"] = 1
	G2L["5"]["Size"] = UDim2.new(0, 225, 0, 32)
	G2L["5"]["Text"] = "proxy.win"
	G2L["5"]["Name"] = "Title"
	G2L["5"]["Position"] = UDim2.new(0.02022, 0, 0, 0)
	
	G2L["6"] = Instance.new("Frame", G2L["2"])
	G2L["6"]["BackgroundColor3"] = Color3.fromRGB(16, 17, 21)
	G2L["6"]["Size"] = UDim2.new(0, 98, 0, 252)
	G2L["6"]["Position"] = UDim2.new(0.02222, 0, 0.10667, 0)
	G2L["6"]["Name"] = "Sidebar"
	G2L["6"]["BorderSizePixel"] = 0
	
	Instance.new("UICorner", G2L["6"])
	Instance.new("UIStroke", G2L["6"]).Color = Color3.fromRGB(25, 25, 34)
	
	local sidebarLayout = Instance.new("UIListLayout", G2L["6"])
	sidebarLayout["Padding"] = UDim.new(0.03, 0)
	sidebarLayout["SortOrder"] = Enum.SortOrder.LayoutOrder
	
	local sidebarPadding = Instance.new("UIPadding", G2L["6"])
	sidebarPadding["PaddingTop"] = UDim.new(0, 5)
	sidebarPadding["PaddingLeft"] = UDim.new(0, 4)
	
	G2L["10"] = Instance.new("Frame", G2L["2"])
	G2L["10"]["BackgroundColor3"] = Color3.fromRGB(16, 17, 21)
	G2L["10"]["Size"] = UDim2.new(0, 374, 0, 252)
	G2L["10"]["Position"] = UDim2.new(0.23022, 0, 0.10667, 0)
	G2L["10"]["Name"] = "MainContainer"
	G2L["10"]["BorderSizePixel"] = 0
	
	Instance.new("UICorner", G2L["10"])
	Instance.new("UIStroke", G2L["10"]).Color = Color3.fromRGB(25, 25, 34)
	
	G2L["1b"] = Instance.new("TextButton", G2L["2"])
	G2L["1b"]["BackgroundColor3"] = Color3.fromRGB(25, 25, 34)
	G2L["1b"]["Size"] = UDim2.new(0, 200, 0, 5)
	G2L["1b"]["Position"] = UDim2.new(0.40378, 0, 0.04333, 0)
	G2L["1b"]["Text"] = ""
	G2L["1b"]["BorderSizePixel"] = 0
	Instance.new("UICorner", G2L["1b"])
	
	return G2L
end

function Library:CreateWindow(title)
	local G2L = createUI()
	local window = {Tabs = {}, CurrentTab = nil}
	
	G2L["5"]["Text"] = title or "proxy.win"
	
	local dragging, dragInput, dragStart, startPos
	local dragZone = Instance.new("Frame", G2L["2"])
	dragZone.BackgroundTransparency = 1
	dragZone.Size = UDim2.new(1, 0, 0, 32)
	dragZone.Position = UDim2.new(0, 0, 0, 0)
	
	dragZone.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = G2L["2"].Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	
	game:GetService("RunService").RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			G2L["2"].Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	local minimized = false
	G2L["1b"].MouseButton1Click:Connect(function()
		minimized = not minimized
		TweenService:Create(G2L["2"], TweenInfo.new(0.3), {Size = minimized and UDim2.new(0, 500, 0, 32) or UDim2.new(0, 500, 0, 300)}):Play()
	end)
	
	function window:CreateTab(name)
		local tab = {}
		local tabButton = Instance.new("TextButton", G2L["6"])
		tabButton["BackgroundColor3"] = Color3.fromRGB(16, 17, 21)
		tabButton["Size"] = UDim2.new(0, 90, 0, 30)
		tabButton["Text"] = ""
		tabButton["BorderSizePixel"] = 0
		
		local stroke = Instance.new("UIStroke", tabButton)
		stroke.Color = Color3.fromRGB(30, 30, 37)
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		
		Instance.new("UICorner", tabButton)["CornerRadius"] = UDim.new(0, 5)
		
		local title = Instance.new("TextLabel", tabButton)
		title["TextSize"] = 14
		title["TextXAlignment"] = Enum.TextXAlignment.Left
		title["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		title["TextColor3"] = Color3.fromRGB(255, 255, 255)
		title["BackgroundTransparency"] = 1
		title["Size"] = UDim2.new(0, 62, 0, 30)
		title["Text"] = name
		title["Position"] = UDim2.new(0.24444, 0, 0, 0)
		title["BorderSizePixel"] = 0
		
		local decoration = Instance.new("Frame", tabButton)
		decoration["BackgroundColor3"] = Color3.fromRGB(30, 30, 37)
		decoration["Size"] = UDim2.new(0, 3, 0, 15)
		decoration["Position"] = UDim2.new(0.08889, 0, 0.23333, 0)
		decoration["BorderSizePixel"] = 0
		
		tabButton.MouseEnter:Connect(function()
			if window.CurrentTab ~= tab then
				TweenService:Create(tabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 21, 26)}):Play()
			end
		end)
		
		tabButton.MouseLeave:Connect(function()
			if window.CurrentTab ~= tab then
				TweenService:Create(tabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 17, 21)}):Play()
			end
		end)
		
		local container = Instance.new("ScrollingFrame", G2L["10"])
		container["Active"] = true
		container["BackgroundTransparency"] = 1
		container["Size"] = UDim2.new(0, 361, 0, 241)
		container["ScrollBarImageColor3"] = Color3.fromRGB(25, 25, 34)
		container["Position"] = UDim2.new(0.01872, 0, 0.01984, 0)
		container["ScrollBarThickness"] = 5
		container["Visible"] = false
		container["BorderSizePixel"] = 0
        container["ClipsDescendants"] = true
		
		local layout = Instance.new("UIListLayout", container)
		layout["Padding"] = UDim.new(0, 8)
		
		local padding = Instance.new("UIPadding", container)
		padding["PaddingTop"] = UDim.new(0, 5)
		padding["PaddingLeft"] = UDim.new(0, 5)
		
		tabButton.MouseButton1Click:Connect(function()
			for _, t in pairs(window.Tabs) do
				t.Container.Visible = false
				TweenService:Create(t.Decoration, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 37)}):Play()
			end
			container.Visible = true
			TweenService:Create(decoration, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 120, 255)}):Play()
			window.CurrentTab = tab
		end)
		
		if not window.CurrentTab then
			container.Visible = true
			decoration.BackgroundColor3 = Color3.fromRGB(200, 120, 255)
			window.CurrentTab = tab
		end
		
		tab.Container = container
		tab.Decoration = decoration
		table.insert(window.Tabs, tab)
		
		function tab:AddButton(opts)
			local btn = Instance.new("TextButton", container)
			btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
			btn.Size = UDim2.new(0, 340, 0, 55)
			btn.Text = ""
			btn.BorderSizePixel = 0
			
			local btnStroke = Instance.new("UIStroke", btn)
			btnStroke.Color = Color3.fromRGB(30, 30, 37)
			btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			
			Instance.new("UICorner", btn)
			
			local icon = Instance.new("ImageLabel", btn)
			icon.BackgroundTransparency = 1
			icon.ImageColor3 = Color3.fromRGB(30, 30, 37)
			icon.Image = "rbxassetid://10723375250"
			icon.Size = UDim2.new(0, 25, 0, 25)
			icon.Position = UDim2.new(0.897, 0, 0.273, 0)
			
			local lbl = Instance.new("TextLabel", btn)
			lbl.TextSize = 14
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0, 84, 0, 50)
			lbl.Text = opts.Name or "Button"
			lbl.Position = UDim2.new(0.047, 0, 0, 0)
			lbl.BorderSizePixel = 0
			
			local desc = Instance.new("TextLabel", btn)
			desc.TextWrapped = true
			desc.TextSize = 12
			desc.TextXAlignment = Enum.TextXAlignment.Left
			desc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			desc.TextColor3 = Color3.fromRGB(126, 126, 126)
			desc.BackgroundTransparency = 1
			desc.Size = UDim2.new(0, 205, 0, 50)
			desc.Text = opts.Description or ""
			desc.Position = UDim2.new(0.294, 0, 0.036, 0)
			desc.BorderSizePixel = 0
			
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20, 21, 26)}):Play()
				task.wait(0.1)
				TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(16, 17, 21)}):Play()
				if opts.Callback then opts.Callback() end
			end)
			
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
			end)
		end
		
		function tab:AddToggle(opts)
			local toggled = opts.Default or false
			local btn = Instance.new("TextButton", container)
			btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
			btn.Size = UDim2.new(0, 340, 0, 55)
			btn.Text = ""
			btn.BorderSizePixel = 0
			
			local toggleStroke = Instance.new("UIStroke", btn)
			toggleStroke.Color = Color3.fromRGB(30, 30, 37)
			toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			
			Instance.new("UICorner", btn)
			
			local lbl = Instance.new("TextLabel", btn)
			lbl.TextSize = 14
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0, 84, 0, 50)
			lbl.Text = opts.Name or "Toggle"
			lbl.Position = UDim2.new(0.047, 0, 0, 0)
			lbl.BorderSizePixel = 0
			
			local desc = Instance.new("TextLabel", btn)
			desc.TextWrapped = true
			desc.TextSize = 12
			desc.TextXAlignment = Enum.TextXAlignment.Left
			desc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			desc.TextColor3 = Color3.fromRGB(126, 126, 126)
			desc.BackgroundTransparency = 1
			desc.Size = UDim2.new(0, 205, 0, 50)
			desc.Text = opts.Description or ""
			desc.Position = UDim2.new(0.294, 0, 0.036, 0)
			desc.BorderSizePixel = 0
			
			local tFrame = Instance.new("Frame", btn)
			tFrame.BackgroundColor3 = toggled and Color3.fromRGB(200, 120, 255) or Color3.fromRGB(30, 30, 37)
			tFrame.Size = UDim2.new(0, 40, 0, 20)
			tFrame.Position = UDim2.new(0.85, 0, 0.32, 0)
			tFrame.BorderSizePixel = 0
			Instance.new("UICorner", tFrame).CornerRadius = UDim.new(1, 0)
			
			local tBtn = Instance.new("Frame", tFrame)
			tBtn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
			tBtn.Size = UDim2.new(0, 16, 0, 16)
			tBtn.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			tBtn.BorderSizePixel = 0
			Instance.new("UICorner", tBtn).CornerRadius = UDim.new(1, 0)
			
			btn.MouseButton1Click:Connect(function()
				toggled = not toggled
				TweenService:Create(tFrame, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(200, 120, 255) or Color3.fromRGB(30, 30, 37)}):Play()
				TweenService:Create(tBtn, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
				if opts.Callback then opts.Callback(toggled) end
			end)
			
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
			end)
		end
		
		function tab:AddSlider(opts)
			local min, max = opts.Min or 0, opts.Max or 100
			local val = opts.Default or min
			
			local frame = Instance.new("Frame", container)
			frame.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
			frame.Size = UDim2.new(0, 340, 0, 65)
			frame.BorderSizePixel = 0
			
			local sliderStroke = Instance.new("UIStroke", frame)
			sliderStroke.Color = Color3.fromRGB(30, 30, 37)
			sliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			
			Instance.new("UICorner", frame)
			
			local lbl = Instance.new("TextLabel", frame)
			lbl.TextSize = 14
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(0, 250, 0, 25)
			lbl.Text = opts.Name or "Slider"
			lbl.Position = UDim2.new(0.047, 0, 0.05, 0)
			lbl.BorderSizePixel = 0
			
			local valLbl = Instance.new("TextLabel", frame)
			valLbl.TextSize = 14
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			valLbl.TextColor3 = Color3.fromRGB(200, 120, 255)
			valLbl.BackgroundTransparency = 1
			valLbl.Size = UDim2.new(0, 60, 0, 25)
			valLbl.Text = tostring(val)
			valLbl.Position = UDim2.new(0, 264, 0, 3)
			valLbl.BorderSizePixel = 0
			
			local sBack = Instance.new("Frame", frame)
			sBack.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
			sBack.Size = UDim2.new(0, 310, 0, 6)
			sBack.Position = UDim2.new(0.047, 0, 0.65, 0)
			sBack.BorderSizePixel = 0
			Instance.new("UICorner", sBack).CornerRadius = UDim.new(1, 0)
			
			local sFill = Instance.new("Frame", sBack)
			sFill.BackgroundColor3 = Color3.fromRGB(200, 120, 255)
			sFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
			sFill.BorderSizePixel = 0
			Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)
			
			local dragging = false
			sBack.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					local pos = math.clamp((i.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
					val = math.floor(min + (max - min) * pos)
					valLbl.Text = tostring(val)
					sFill.Size = UDim2.new(pos, 0, 1, 0)
					if opts.Callback then opts.Callback(val) end
				end
			end)
			sBack.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			
			UserInputService.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((i.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
					val = math.floor(min + (max - min) * pos)
					valLbl.Text = tostring(val)
					sFill.Size = UDim2.new(pos, 0, 1, 0)
					if opts.Callback then opts.Callback(val) end
				end
			end)
			
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
			end)
		end
    
       function tab:AddDropdown(opts)
	local selected = opts.Default or opts.Options[1]
	local open = false
	
	local btn = Instance.new("TextButton", container)
	btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
	btn.Size = UDim2.new(0, 340, 0, 55)
	btn.Text = ""
	btn.BorderSizePixel = 0
	btn.ClipsDescendants = true
	
	local dropStroke = Instance.new("UIStroke", btn)
	dropStroke.Color = Color3.fromRGB(30, 30, 37)
	dropStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
	Instance.new("UICorner", btn)
	
	local lbl = Instance.new("TextLabel", btn)
	lbl.TextSize = 14
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(0, 150, 0, 55)
	lbl.Text = opts.Name or "Dropdown"
	lbl.Position = UDim2.new(0.047, 0, 0, 0)
	lbl.BorderSizePixel = 0
	
	local selLbl = Instance.new("TextLabel", btn)
	selLbl.TextSize = 12
	selLbl.TextXAlignment = Enum.TextXAlignment.Right
	selLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	selLbl.TextColor3 = Color3.fromRGB(200, 120, 255)
	selLbl.BackgroundTransparency = 1
	selLbl.Size = UDim2.new(0, 110, 0, 55)
	selLbl.Text = selected
	selLbl.Position = UDim2.new(0, 180, 0, 0)
	selLbl.BorderSizePixel = 0
	
	local arrow = Instance.new("ImageLabel", btn)
	arrow.BackgroundTransparency = 1
	arrow.ImageColor3 = Color3.fromRGB(30, 30, 37)
	arrow.Image = "rbxassetid://10709767827"
	arrow.Size = UDim2.new(0, 25, 0, 25)
	arrow.Position = UDim2.new(0.897, 0, 0.273, 0)
	arrow.BorderSizePixel = 0
	
	local dList = Instance.new("Frame", btn)
	dList.BackgroundTransparency = 1
	dList.Size = UDim2.new(1, 0, 0, 0)
	dList.Position = UDim2.new(0, 0, 0, 60)
	dList.BorderSizePixel = 0
	dList.ClipsDescendants = false
	
	local listLayout = Instance.new("UIListLayout", dList)
	listLayout.Padding = UDim.new(0, 5)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local listPadding = Instance.new("UIPadding", dList)
	listPadding.PaddingTop = UDim.new(0, 5)
	listPadding.PaddingBottom = UDim.new(0, 5)
	
	for _, option in ipairs(opts.Options) do
		local oBtn = Instance.new("TextButton", dList)
		oBtn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
		oBtn.Size = UDim2.new(0.95, 0, 0, 35)
		oBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		oBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		oBtn.TextXAlignment = Enum.TextXAlignment.Center
		oBtn.Text = option
		oBtn.TextSize = 13
		oBtn.ZIndex = 11
		oBtn.BorderSizePixel = 0
		
		local oBtnStroke = Instance.new("UIStroke", oBtn)
		oBtnStroke.Color = Color3.fromRGB(30, 30, 37)
		oBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		
		Instance.new("UICorner", oBtn)
		
		oBtn.MouseEnter:Connect(function()
			TweenService:Create(oBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 21, 26)}):Play()
		end)
		
		oBtn.MouseLeave:Connect(function()
			TweenService:Create(oBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 17, 21)}):Play()
		end)
		
		oBtn.MouseButton1Click:Connect(function()
			selected = option
			selLbl.Text = selected
			open = false
			arrow.Image = "rbxassetid://10709767827"

			local tween1 = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 55)})
			local tween2 = TweenService:Create(dList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
			tween1:Play()
			tween2:Play()
			
			if opts.Callback then opts.Callback(selected) end
		end)
	end
	
	btn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			arrow.Image = "rbxassetid://10709768939"
			local h = (#opts.Options * 40) + 10

			local tween1 = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 55 + h)})
			local tween2 = TweenService:Create(dList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, h)})
			tween1:Play()
			tween2:Play()
		else
			arrow.Image = "rbxassetid://10709767827"
			
			local tween1 = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 55)})
			local tween2 = TweenService:Create(dList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
			tween1:Play()
			tween2:Play()
		end
	end)
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)
end
		return tab
	end
	
	return window
end

return Library