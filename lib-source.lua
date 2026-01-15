local Library = {}
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local NotificationSystem = {}

NotificationSystem.ActiveNotifications = {}

function NotificationSystem:Send(title, description, duration)
    duration = duration or 5

    local notiGui = Instance.new('ScreenGui', game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'))

    notiGui.Name = 'Notification'
    notiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notiGui.ResetOnSpawn = false

    local holder = Instance.new('Frame', notiGui)

    holder.BorderSizePixel = 0
    holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    holder.Size = UDim2.new(0, 220, 0, 120)
    holder.Position = UDim2.new(1, 10, 1, -130)
    holder.Name = 'Holder'
    holder.BackgroundTransparency = 0.4
    Instance.new('UICorner', holder).CornerRadius = UDim.new(0, 10)
    Instance.new('UIStroke', holder).Color = Color3.fromRGB(97, 37, 151)

    local contents = Instance.new('Frame', holder)

    contents.BorderSizePixel = 0
    contents.BackgroundTransparency = 1
    contents.Size = UDim2.new(1, 0, 1, 0)
    contents.Position = UDim2.new(0, 0, 0, 0)

    local titleLabel = Instance.new('TextLabel', contents)

    titleLabel.BorderSizePixel = 0
    titleLabel.TextSize = 14
    titleLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 220, 0, 25)
    titleLabel.Text = title or 'Notification'
    titleLabel.Position = UDim2.new(0, 0, 0, 5)

    local descLabel = Instance.new('TextLabel', contents)

    descLabel.TextWrapped = true
    descLabel.BorderSizePixel = 0
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    descLabel.TextColor3 = Color3.fromRGB(203, 203, 203)
    descLabel.BackgroundTransparency = 1
    descLabel.Size = UDim2.new(0, 200, 0, 60)
    descLabel.Text = description or ''
    descLabel.Position = UDim2.new(0, 10, 0, 35)

    local timerLabel = Instance.new('TextLabel', contents)

    timerLabel.BorderSizePixel = 0
    timerLabel.TextSize = 12
    timerLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Size = UDim2.new(0, 30, 0, 20)
    timerLabel.Text = duration .. 's'
    timerLabel.Position = UDim2.new(1, -35, 1, -25)
    timerLabel.TextXAlignment = Enum.TextXAlignment.Right

    local hoverImage = Instance.new('ImageLabel', holder)

    hoverImage.BackgroundTransparency = 1
    hoverImage.ImageColor3 = Color3.fromRGB(97, 37, 151)
    hoverImage.Image = 'rbxassetid://10747384394'
    hoverImage.Size = UDim2.new(0, 100, 0, 100)
    hoverImage.Position = UDim2.new(0.5, -50, 0.5, -50)
    hoverImage.ImageTransparency = 1
    hoverImage.ZIndex = 10

    local blurOverlay = Instance.new('Frame', holder)

    blurOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurOverlay.BackgroundTransparency = 1
    blurOverlay.Size = UDim2.new(1, 0, 1, 0)
    blurOverlay.BorderSizePixel = 0
    blurOverlay.ZIndex = 5
    Instance.new('UICorner', blurOverlay).CornerRadius = UDim.new(0, 10)

    local clickDetector = Instance.new('TextButton', holder)

    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ''
    clickDetector.ZIndex = 20

    local offset = 0

    for _, noti in pairs(NotificationSystem.ActiveNotifications)do
        offset = offset + 130
    end

    table.insert(NotificationSystem.ActiveNotifications, {
        Gui = notiGui,
        Offset = offset,
    })
    TweenService:Create(holder, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -230, 1, -130 - offset),
    }):Play()
    clickDetector.MouseEnter:Connect(function()
        hoverImage.ImageTransparency = 0

        TweenService:Create(hoverImage, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
        TweenService:Create(blurOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(holder, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    clickDetector.MouseLeave:Connect(function()
        TweenService:Create(hoverImage, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
        TweenService:Create(blurOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(holder, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
    end)
    clickDetector.MouseButton1Click:Connect(function()
        TweenService:Create(holder, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 1, -130 - offset),
        }):Play()
        task.wait(0.3)
        notiGui:Destroy()

        for i, noti in pairs(NotificationSystem.ActiveNotifications)do
            if noti.Gui == notiGui then
                table.remove(NotificationSystem.ActiveNotifications, i)

                break
            end
        end
    end)
    task.spawn(function()
        for i = duration, 1, -1 do
            if not timerLabel or not timerLabel.Parent then
                break
            end

            timerLabel.Text = i .. 's'

            task.wait(1)
        end

        if notiGui and notiGui.Parent then
            TweenService:Create(holder, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 10, 1, -130 - offset),
            }):Play()
            task.wait(0.3)
            notiGui:Destroy()

            for i, noti in pairs(NotificationSystem.ActiveNotifications)do
                if noti.Gui == notiGui then
                    table.remove(NotificationSystem.ActiveNotifications, i)

                    break
                end
            end
        end
    end)
end

local function createUI()
    local by_blankfelony = {}

    by_blankfelony['1'] = Instance.new('ScreenGui', game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'))
    by_blankfelony['1'].Name = 'Library'
    by_blankfelony['1'].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    by_blankfelony['1'].ResetOnSpawn = false
    by_blankfelony['2'] = Instance.new('Frame', by_blankfelony['1'])
    by_blankfelony['2'].BorderSizePixel = 0
    by_blankfelony['2'].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    by_blankfelony['2'].Size = UDim2.new(0, 500, 0, 300)
    by_blankfelony['2'].Position = UDim2.new(0.5, -250, 0.5, -150)
    by_blankfelony['2'].Name = 'Holder'
    Instance.new('UIStroke', by_blankfelony['2']).Color = Color3.fromRGB(97, 37, 151)

    Instance.new('UICorner', by_blankfelony['2'])

    by_blankfelony['5'] = Instance.new('TextLabel', by_blankfelony['2'])
    by_blankfelony['5'].TextSize = 14
    by_blankfelony['5'].TextXAlignment = Enum.TextXAlignment.Left
    by_blankfelony['5'].FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    by_blankfelony['5'].TextColor3 = Color3.fromRGB(201, 121, 255)
    by_blankfelony['5'].BackgroundTransparency = 1
    by_blankfelony['5'].Size = UDim2.new(0, 225, 0, 32)
    by_blankfelony['5'].Text = 'proxy.win'
    by_blankfelony['5'].Name = 'Title'
    by_blankfelony['5'].Position = UDim2.new(0.02022, 0, 0, 0)
    by_blankfelony['6'] = Instance.new('Frame', by_blankfelony['2'])
    by_blankfelony['6'].BackgroundColor3 = Color3.fromRGB(16, 17, 21)
    by_blankfelony['6'].Size = UDim2.new(0, 98, 0, 252)
    by_blankfelony['6'].Position = UDim2.new(0.02222, 0, 0.10667, 0)
    by_blankfelony['6'].Name = 'Sidebar'
    by_blankfelony['6'].BorderSizePixel = 0

    Instance.new('UICorner', by_blankfelony['6'])

    Instance.new('UIStroke', by_blankfelony['6']).Color = Color3.fromRGB(25, 25, 34)

    local sidebarLayout = Instance.new('UIListLayout', by_blankfelony['6'])

    sidebarLayout.Padding = UDim.new(0.03, 0)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local sidebarPadding = Instance.new('UIPadding', by_blankfelony['6'])

    sidebarPadding.PaddingTop = UDim.new(0, 5)
    sidebarPadding.PaddingLeft = UDim.new(0, 4)
    by_blankfelony['10'] = Instance.new('Frame', by_blankfelony['2'])
    by_blankfelony['10'].BackgroundColor3 = Color3.fromRGB(16, 17, 21)
    by_blankfelony['10'].Size = UDim2.new(0, 374, 0, 252)
    by_blankfelony['10'].Position = UDim2.new(0.23022, 0, 0.10667, 0)
    by_blankfelony['10'].Name = 'MainContainer'
    by_blankfelony['10'].BorderSizePixel = 0

    Instance.new('UICorner', by_blankfelony['10'])

    Instance.new('UIStroke', by_blankfelony['10']).Color = Color3.fromRGB(25, 25, 34)
    by_blankfelony.CloseBtn = Instance.new('ImageButton', by_blankfelony['2'])
    by_blankfelony.CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    by_blankfelony.CloseBtn.Position = UDim2.new(0, 470, 0, 6)
    by_blankfelony.CloseBtn.Image = 'rbxassetid://10747384217'
    by_blankfelony.CloseBtn.ImageColor3 = Color3.fromRGB(200, 120, 255)
    by_blankfelony.CloseBtn.BackgroundTransparency = 1

    return by_blankfelony
end

function Library:CreateWindow(title)
    local by_blankfelony = createUI()
    local window = {
        Tabs = {},
        CurrentTab = nil,
    }

    by_blankfelony['5'].Text = title or 'proxy.win'

    local dragging, dragInput, dragStart, startPos
    local dragZone = Instance.new('Frame', by_blankfelony['2'])

    dragZone.BackgroundTransparency = 1
    dragZone.Size = UDim2.new(1, 0, 0, 32)
    dragZone.Position = UDim2.new(0, 0, 0, 0)

    dragZone.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = by_blankfelony['2'].Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService('RunService').RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart

            by_blankfelony['2'].Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local visible = true
    local originalTransparencies = {}

    local function saveTransparencies()
        for _, child in pairs(by_blankfelony['2']:GetDescendants())do
            if child:IsA('TextLabel') or child:IsA('TextButton') then
                originalTransparencies[child] = {
                    BackgroundTransparency = child.BackgroundTransparency,
                    TextTransparency = child.TextTransparency,
                }
            elseif child:IsA('ImageButton') or child:IsA('ImageLabel') then
                originalTransparencies[child] = {
                    ImageTransparency = child.ImageTransparency,
                }
            elseif child:IsA('ScrollingFrame') then
                originalTransparencies[child] = {
                    BackgroundTransparency = child.BackgroundTransparency,
                    ScrollBarImageTransparency = child.ScrollBarImageTransparency,
                }
            elseif child:IsA('Frame') then
                originalTransparencies[child] = {
                    BackgroundTransparency = child.BackgroundTransparency,
                }
            elseif child:IsA('UIStroke') then
                originalTransparencies[child] = {
                    Transparency = child.Transparency,
                }
            end
        end
    end

    task.delay(0.5, saveTransparencies)
    by_blankfelony.CloseBtn.MouseButton1Click:Connect(function()
        visible = false

        for _, child in pairs(by_blankfelony['2']:GetDescendants())do
            if child:IsA('TextLabel') or child:IsA('TextButton') then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                }):Play()
            elseif child:IsA('ImageButton') or child:IsA('ImageLabel') then
                TweenService:Create(child, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            elseif child:IsA('ScrollingFrame') then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    ScrollBarImageTransparency = 1,
                }):Play()
            elseif child:IsA('Frame') then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            elseif child:IsA('UIStroke') then
                TweenService:Create(child, TweenInfo.new(0.2), {Transparency = 1}):Play()
            end
        end

        TweenService:Create(by_blankfelony['2'], TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        task.wait(0.2)

        by_blankfelony['2'].Visible = false

        NotificationSystem:Send('UI Hidden', 'Press LeftControl to show the UI again', 3)
    end)

    window.ToggleKey = Enum.KeyCode.LeftControl

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == window.ToggleKey and not gameProcessed then
            visible = not visible

            if visible then
                by_blankfelony['2'].Visible = true

                TweenService:Create(by_blankfelony['2'], TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
                task.wait(0.05)

                for child, transparencies in pairs(originalTransparencies)do
                    if child:IsA('TextLabel') or child:IsA('TextButton') then
                        TweenService:Create(child, TweenInfo.new(0.25), {
                            TextTransparency = transparencies.TextTransparency,
                            BackgroundTransparency = transparencies.BackgroundTransparency,
                        }):Play()
                    elseif child:IsA('ImageButton') or child:IsA('ImageLabel') then
                        TweenService:Create(child, TweenInfo.new(0.25), {
                            ImageTransparency = transparencies.ImageTransparency,
                        }):Play()
                    elseif child:IsA('ScrollingFrame') then
                        TweenService:Create(child, TweenInfo.new(0.25), {
                            BackgroundTransparency = transparencies.BackgroundTransparency,
                            ScrollBarImageTransparency = transparencies.ScrollBarImageTransparency,
                        }):Play()
                    elseif child:IsA('Frame') then
                        TweenService:Create(child, TweenInfo.new(0.25), {
                            BackgroundTransparency = transparencies.BackgroundTransparency,
                        }):Play()
                    elseif child:IsA('UIStroke') then
                        TweenService:Create(child, TweenInfo.new(0.25), {
                            Transparency = transparencies.Transparency,
                        }):Play()
                    end
                end
            else
                for _, child in pairs(by_blankfelony['2']:GetDescendants())do
                    if child:IsA('TextLabel') or child:IsA('TextButton') then
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            BackgroundTransparency = 1,
                            TextTransparency = 1,
                        }):Play()
                    elseif child:IsA('ImageButton') then
                        TweenService:Create(child, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                    elseif child:IsA('ScrollingFrame') then
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            BackgroundTransparency = 1,
                            ScrollBarImageTransparency = 1,
                        }):Play()
                    elseif child:IsA('Frame') then
                        TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    elseif child:IsA('UIStroke') then
                        TweenService:Create(child, TweenInfo.new(0.2), {Transparency = 1}):Play()
                    end
                end

                TweenService:Create(by_blankfelony['2'], TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                task.wait(0.2)

                by_blankfelony['2'].Visible = false
            end
        end
    end)

    function window:CreateTab(name)
        local tab = {}
        local tabButton = Instance.new('TextButton', by_blankfelony['6'])

        tabButton.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
        tabButton.Size = UDim2.new(0, 90, 0, 30)
        tabButton.Text = ''
        tabButton.BorderSizePixel = 0

        local stroke = Instance.new('UIStroke', tabButton)

        stroke.Color = Color3.fromRGB(30, 30, 37)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Instance.new('UICorner', tabButton).CornerRadius = UDim.new(0, 5)

        local title = Instance.new('TextLabel', tabButton)

        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(0, 62, 0, 30)
        title.Text = name
        title.Position = UDim2.new(0.24444, 0, 0, 0)
        title.BorderSizePixel = 0

        local decoration = Instance.new('Frame', tabButton)

        decoration.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
        decoration.Size = UDim2.new(0, 3, 0, 15)
        decoration.Position = UDim2.new(0.08889, 0, 0.23333, 0)
        decoration.BorderSizePixel = 0

        tabButton.MouseEnter:Connect(function()
            if window.CurrentTab ~= tab then
                TweenService:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(20, 21, 26),
                }):Play()
            end
        end)
        tabButton.MouseLeave:Connect(function()
            if window.CurrentTab ~= tab then
                TweenService:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(16, 17, 21),
                }):Play()
            end
        end)

        local container = Instance.new('ScrollingFrame', by_blankfelony['10'])

        container.Active = true
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(0, 361, 0, 241)
        container.ScrollBarImageColor3 = Color3.fromRGB(25, 25, 34)
        container.Position = UDim2.new(0.01872, 0, 0.01984, 0)
        container.ScrollBarThickness = 5
        container.Visible = false
        container.BorderSizePixel = 0
        container.ClipsDescendants = true

        local layout = Instance.new('UIListLayout', container)

        layout.Padding = UDim.new(0, 8)

        local padding = Instance.new('UIPadding', container)

        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingLeft = UDim.new(0, 5)

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs)do
                t.Container.Visible = false

                TweenService:Create(t.Decoration, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 37),
                }):Play()
            end

            container.Visible = true

            TweenService:Create(decoration, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(200, 120, 255),
            }):Play()

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
            local btn = Instance.new('TextButton', container)

            btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            btn.Size = UDim2.new(0, 340, 0, 55)
            btn.Text = ''
            btn.BorderSizePixel = 0

            local btnStroke = Instance.new('UIStroke', btn)

            btnStroke.Color = Color3.fromRGB(30, 30, 37)
            btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new('UICorner', btn)

            local icon = Instance.new('ImageLabel', btn)

            icon.BackgroundTransparency = 1
            icon.ImageColor3 = Color3.fromRGB(30, 30, 37)
            icon.Image = 'rbxassetid://10723375250'
            icon.Size = UDim2.new(0, 25, 0, 25)
            icon.Position = UDim2.new(0.897, 0, 0.273, 0)

            local lbl = Instance.new('TextLabel', btn)

            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(0, 84, 0, 50)
            lbl.Text = opts.Name or 'Button'
            lbl.Position = UDim2.new(0.047, 0, 0, 0)
            lbl.BorderSizePixel = 0

            local desc = Instance.new('TextLabel', btn)

            desc.TextWrapped = true
            desc.TextSize = 12
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            desc.TextColor3 = Color3.fromRGB(126, 126, 126)
            desc.BackgroundTransparency = 1
            desc.Size = UDim2.new(0, 205, 0, 50)
            desc.Text = opts.Description or ''
            desc.Position = UDim2.new(0.294, 0, 0.036, 0)
            desc.BorderSizePixel = 0

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(20, 21, 26),
                }):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(16, 17, 21),
                }):Play()

                if opts.Callback then
                    opts.Callback()
                end
            end)
            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)
        end
        function tab:AddToggle(opts)
            local toggled = opts.Default or false
            local toggleObj = {Value = toggled}
            local btn = Instance.new('TextButton', container)

            btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            btn.Size = UDim2.new(0, 340, 0, 55)
            btn.Text = ''
            btn.BorderSizePixel = 0

            local toggleStroke = Instance.new('UIStroke', btn)

            toggleStroke.Color = Color3.fromRGB(30, 30, 37)
            toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new('UICorner', btn)

            local lbl = Instance.new('TextLabel', btn)

            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(0, 84, 0, 50)
            lbl.Text = opts.Name or 'Toggle'
            lbl.Position = UDim2.new(0.047, 0, 0, 0)
            lbl.BorderSizePixel = 0

            local desc = Instance.new('TextLabel', btn)

            desc.TextWrapped = true
            desc.TextSize = 12
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            desc.TextColor3 = Color3.fromRGB(126, 126, 126)
            desc.BackgroundTransparency = 1
            desc.Size = UDim2.new(0, 205, 0, 50)
            desc.Text = opts.Description or ''
            desc.Position = UDim2.new(0.294, 0, 0.036, 0)
            desc.BorderSizePixel = 0

            local tFrame = Instance.new('Frame', btn)

            tFrame.BackgroundColor3 = toggled and Color3.fromRGB(200, 120, 255) or Color3.fromRGB(30, 30, 37)
            tFrame.Size = UDim2.new(0, 40, 0, 20)
            tFrame.Position = UDim2.new(0.85, 0, 0.32, 0)
            tFrame.BorderSizePixel = 0
            Instance.new('UICorner', tFrame).CornerRadius = UDim.new(1, 0)

            local tBtn = Instance.new('Frame', tFrame)

            tBtn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            tBtn.Size = UDim2.new(0, 16, 0, 16)
            tBtn.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            tBtn.BorderSizePixel = 0
            Instance.new('UICorner', tBtn).CornerRadius = UDim.new(1, 0)

            function toggleObj:Set(value)
                toggled = value
                self.Value = value

                TweenService:Create(tFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Color3.fromRGB(200, 120, 255) or Color3.fromRGB(30, 30, 37),
                }):Play()
                TweenService:Create(tBtn, TweenInfo.new(0.2), {
                    Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                }):Play()

                if opts.Callback then
                    opts.Callback(value)
                end
            end

            btn.MouseButton1Click:Connect(function()
                toggleObj:Set(not toggled)
            end)
            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            return toggleObj
        end
        function tab:AddTextBox(opts)
            local frame = Instance.new('Frame', container)

            frame.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            frame.Size = UDim2.new(0, 340, 0, 55)
            frame.BorderSizePixel = 0

            local textboxStroke = Instance.new('UIStroke', frame)

            textboxStroke.Color = Color3.fromRGB(30, 30, 37)
            textboxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new('UICorner', frame)

            local lbl = Instance.new('TextLabel', frame)

            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(0, 84, 0, 50)
            lbl.Text = opts.Name or 'Info'
            lbl.Position = UDim2.new(0.047, 0, 0, 0)
            lbl.BorderSizePixel = 0

            local textBox = Instance.new('TextLabel', frame)

            textBox.TextWrapped = true
            textBox.TextSize = 12
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            textBox.TextColor3 = Color3.fromRGB(200, 120, 255)
            textBox.BackgroundTransparency = 1
            textBox.Size = UDim2.new(0, 205, 0, 50)
            textBox.Text = opts.Text or ''
            textBox.Position = UDim2.new(0.294, 0, 0.036, 0)
            textBox.BorderSizePixel = 0

            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            local textBoxObj = {}

            function textBoxObj:SetText(newText)
                textBox.Text = newText or ''
            end

            return textBoxObj
        end
        function tab:AddSeparator(opts)
            local frame = Instance.new('Frame', container)

            frame.BackgroundTransparency = 1
            frame.Size = UDim2.new(0, 340, 0, 20)
            frame.BorderSizePixel = 0

            local line = Instance.new('Frame', frame)

            line.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
            line.Size = UDim2.new(1, -20, 0, 2)
            line.Position = UDim2.new(0, 10, 0.5, -1)
            line.BorderSizePixel = 0
            Instance.new('UICorner', line).CornerRadius = UDim.new(1, 0)

            if opts and opts.Text then
                local lbl = Instance.new('TextLabel', frame)

                lbl.TextSize = 12
                lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
                lbl.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
                lbl.Size = UDim2.new(0, 0, 0, 14)
                lbl.Text = ' ' .. opts.Text .. ' '
                lbl.Position = UDim2.new(0.5, 0, 0.5, -7)
                lbl.BorderSizePixel = 0
                lbl.AutomaticSize = Enum.AutomaticSize.X
                lbl.AnchorPoint = Vector2.new(0.5, 0)
            end

            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)
        end
        function tab:AddSlider(opts)
            local min, max = opts.Min or 0, opts.Max or 100
            local val = opts.Default or min
            local frame = Instance.new('Frame', container)

            frame.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            frame.Size = UDim2.new(0, 340, 0, 65)
            frame.BorderSizePixel = 0

            local sliderStroke = Instance.new('UIStroke', frame)

            sliderStroke.Color = Color3.fromRGB(30, 30, 37)
            sliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new('UICorner', frame)

            local lbl = Instance.new('TextLabel', frame)

            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(0, 250, 0, 25)
            lbl.Text = opts.Name or 'Slider'
            lbl.Position = UDim2.new(0.047, 0, 0.05, 0)
            lbl.BorderSizePixel = 0

            local valLbl = Instance.new('TextLabel', frame)

            valLbl.TextSize = 14
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            valLbl.TextColor3 = Color3.fromRGB(200, 120, 255)
            valLbl.BackgroundTransparency = 1
            valLbl.Size = UDim2.new(0, 60, 0, 25)
            valLbl.Text = tostring(val)
            valLbl.Position = UDim2.new(0, 264, 0, 3)
            valLbl.BorderSizePixel = 0

            local sBack = Instance.new('Frame', frame)

            sBack.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
            sBack.Size = UDim2.new(0, 310, 0, 6)
            sBack.Position = UDim2.new(0.047, 0, 0.65, 0)
            sBack.BorderSizePixel = 0
            Instance.new('UICorner', sBack).CornerRadius = UDim.new(1, 0)

            local sFill = Instance.new('Frame', sBack)

            sFill.BackgroundColor3 = Color3.fromRGB(200, 120, 255)
            sFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            sFill.BorderSizePixel = 0
            Instance.new('UICorner', sFill).CornerRadius = UDim.new(1, 0)

            local dragging = false

            sBack.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true

                    local pos = math.clamp((i.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)

                    val = math.floor(min + (max - min) * pos)
                    valLbl.Text = tostring(val)
                    sFill.Size = UDim2.new(pos, 0, 1, 0)

                    if opts.Callback then
                        opts.Callback(val)
                    end
                end
            end)
            sBack.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((i.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)

                    val = math.floor(min + (max - min) * pos)
                    valLbl.Text = tostring(val)
                    sFill.Size = UDim2.new(pos, 0, 1, 0)

                    if opts.Callback then
                        opts.Callback(val)
                    end
                end
            end)
            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            local sliderObj = {Value = val}

            function sliderObj:SetValue(newVal)
                val = math.clamp(newVal, min, max)
                self.Value = val
                valLbl.Text = tostring(val)

                local pos = (val - min) / (max - min)

                sFill.Size = UDim2.new(pos, 0, 1, 0)

                if opts.Callback then
                    opts.Callback(val)
                end
            end

            return sliderObj
        end
        function tab:AddDropdown(opts)
            local selected = opts.Default or opts.Options[1]
            local open = false
            local btn = Instance.new('TextButton', container)

            btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            btn.Size = UDim2.new(0, 340, 0, 55)
            btn.Text = ''
            btn.BorderSizePixel = 0
            btn.ClipsDescendants = true

            local dropStroke = Instance.new('UIStroke', btn)

            dropStroke.Color = Color3.fromRGB(30, 30, 37)
            dropStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new('UICorner', btn)

            local header = Instance.new('Frame', btn)

            header.BackgroundTransparency = 1
            header.Size = UDim2.new(1, 0, 0, 55)
            header.Position = UDim2.new(0, 0, 0, 0)
            header.BorderSizePixel = 0
            header.ZIndex = 2

            local lbl = Instance.new('TextLabel', header)

            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(0, 150, 0, 55)
            lbl.Text = opts.Name or 'Dropdown'
            lbl.Position = UDim2.new(0.047, 0, 0, 0)
            lbl.BorderSizePixel = 0

            local selBg = Instance.new('Frame', header)

            selBg.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            selBg.Size = UDim2.new(0, 120, 0, 30)
            selBg.Position = UDim2.new(0, 175, 0.227, 0)
            selBg.BorderSizePixel = 0
            Instance.new('UICorner', selBg).CornerRadius = UDim.new(0, 6)

            local selLbl = Instance.new('TextLabel', selBg)

            selLbl.TextSize = 12
            selLbl.TextXAlignment = Enum.TextXAlignment.Center
            selLbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            selLbl.TextColor3 = Color3.fromRGB(200, 120, 255)
            selLbl.BackgroundTransparency = 1
            selLbl.Size = UDim2.new(1, 0, 1, 0)
            selLbl.Text = selected
            selLbl.Position = UDim2.new(0, 0, 0, 0)
            selLbl.BorderSizePixel = 0

            local arrow = Instance.new('ImageLabel', header)

            arrow.BackgroundTransparency = 1
            arrow.ImageColor3 = Color3.fromRGB(30, 30, 37)
            arrow.Image = 'rbxassetid://10709767827'
            arrow.Size = UDim2.new(0, 25, 0, 25)
            arrow.Position = UDim2.new(0.897, 0, 0.273, 0)
            arrow.BorderSizePixel = 0

            local dList = Instance.new('Frame', btn)

            dList.BackgroundTransparency = 1
            dList.Size = UDim2.new(1, 0, 0, 0)
            dList.Position = UDim2.new(0, 0, 0, 60)
            dList.BorderSizePixel = 0
            dList.ClipsDescendants = false

            local descHeight = 0

            if opts.Description and opts.Description ~= '' then
                local descFrame = Instance.new('Frame', dList)

                descFrame.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
                descFrame.Size = UDim2.new(0.95, 0, 0, 40)
                descFrame.Position = UDim2.new(0.025, 0, 0, 5)
                descFrame.BorderSizePixel = 0
                descFrame.LayoutOrder = -1
                Instance.new('UICorner', descFrame).CornerRadius = UDim.new(0, 6)

                local descStroke = Instance.new('UIStroke', descFrame)

                descStroke.Color = Color3.fromRGB(30, 30, 37)
                descStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                local descLabel = Instance.new('TextLabel', descFrame)

                descLabel.TextWrapped = true
                descLabel.TextSize = 12
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextYAlignment = Enum.TextYAlignment.Top
                descLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                descLabel.BackgroundTransparency = 1
                descLabel.Size = UDim2.new(1, -20, 1, -10)
                descLabel.Text = opts.Description
                descLabel.Position = UDim2.new(0, 10, 0, 5)
                descLabel.BorderSizePixel = 0
                descHeight = 50
            end

            local listLayout = Instance.new('UIListLayout', dList)

            listLayout.Padding = UDim.new(0, 5)
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local listPadding = Instance.new('UIPadding', dList)

            listPadding.PaddingTop = UDim.new(0, 5)
            listPadding.PaddingBottom = UDim.new(0, 5)

            for _, option in ipairs(opts.Options)do
                local oBtn = Instance.new('TextButton', dList)

                oBtn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
                oBtn.Size = UDim2.new(0.95, 0, 0, 35)
                oBtn.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                oBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                oBtn.TextXAlignment = Enum.TextXAlignment.Left
                oBtn.Text = option
                oBtn.TextSize = 13
                oBtn.ZIndex = 11
                oBtn.BorderSizePixel = 0

                local oBtnPadding = Instance.new('UIPadding', oBtn)

                oBtnPadding.PaddingLeft = UDim.new(0, 12)
                oBtnPadding.PaddingRight = UDim.new(0, 12)

                local oBtnStroke = Instance.new('UIStroke', oBtn)

                oBtnStroke.Color = Color3.fromRGB(30, 30, 37)
                oBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                Instance.new('UICorner', oBtn)
                oBtn.MouseEnter:Connect(function()
                    TweenService:Create(oBtn, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(20, 21, 26),
                    }):Play()
                end)
                oBtn.MouseLeave:Connect(function()
                    TweenService:Create(oBtn, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(16, 17, 21),
                    }):Play()
                end)
                oBtn.MouseButton1Click:Connect(function()
                    selected = option
                    selLbl.Text = selected
                    open = false
                    arrow.Image = 'rbxassetid://10709767827'

                    local tween1 = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 340, 0, 55),
                    })
                    local tween2 = TweenService:Create(dList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0),
                    })

                    tween1:Play()
                    tween2:Play()

                    if opts.Callback then
                        opts.Callback(selected)
                    end
                end)
            end

            btn.MouseButton1Click:Connect(function()
                open = not open

                if open then
                    arrow.Image = 'rbxassetid://10709768939'

                    local h = (#opts.Options * 40) + 10 + descHeight
                    local tween1 = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 340, 0, 55 + h),
                    })
                    local tween2 = TweenService:Create(dList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, h),
                    })

                    tween1:Play()
                    tween2:Play()
                else
                    arrow.Image = 'rbxassetid://10709767827'

                    local tween1 = TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 340, 0, 55),
                    })
                    local tween2 = TweenService:Create(dList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0),
                    })

                    tween1:Play()
                    tween2:Play()
                end
            end)
            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            local dropdownObj = {Value = selected}

            function dropdownObj:SetValue(newValue)
                if table.find(opts.Options, newValue) then
                    selected = newValue
                    self.Value = selected
                    selLbl.Text = selected

                    if opts.Callback then
                        opts.Callback(selected)
                    end
                end
            end

            return dropdownObj
        end
        function tab:AddKeybind(opts)
            local currentKey = opts.Default
            local listening = false
            local btn = Instance.new('TextButton', container)

            btn.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
            btn.Size = UDim2.new(0, 340, 0, 55)
            btn.Text = ''
            btn.BorderSizePixel = 0

            local keybindStroke = Instance.new('UIStroke', btn)

            keybindStroke.Color = Color3.fromRGB(30, 30, 37)
            keybindStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            Instance.new('UICorner', btn)

            local lbl = Instance.new('TextLabel', btn)

            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(0, 84, 0, 50)
            lbl.Text = opts.Name or 'Keybind'
            lbl.Position = UDim2.new(0.047, 0, 0, 0)
            lbl.BorderSizePixel = 0

            local desc = Instance.new('TextLabel', btn)

            desc.TextWrapped = true
            desc.TextSize = 12
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            desc.TextColor3 = Color3.fromRGB(126, 126, 126)
            desc.BackgroundTransparency = 1
            desc.Size = UDim2.new(0, 205, 0, 50)
            desc.Text = opts.Description or ''
            desc.Position = UDim2.new(0.294, 0, 0.036, 0)
            desc.BorderSizePixel = 0

            local keyBg = Instance.new('Frame', btn)

            keyBg.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            keyBg.Size = UDim2.new(0, 80, 0, 30)
            keyBg.Position = UDim2.new(0, 245, 0.227, 0)
            keyBg.BorderSizePixel = 0
            Instance.new('UICorner', keyBg).CornerRadius = UDim.new(0, 6)

            local keyLbl = Instance.new('TextLabel', keyBg)

            keyLbl.TextSize = 12
            keyLbl.TextXAlignment = Enum.TextXAlignment.Center
            keyLbl.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            keyLbl.TextColor3 = Color3.fromRGB(200, 120, 255)
            keyLbl.BackgroundTransparency = 1
            keyLbl.Size = UDim2.new(1, 0, 1, 0)
            keyLbl.Text = currentKey and currentKey.Name or 'None'
            keyLbl.BorderSizePixel = 0

            local function updateKey(key)
                currentKey = key
                keyLbl.Text = key.Name
                listening = false

                TweenService:Create(keyBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(25, 25, 34),
                }):Play()

                if opts.Callback then
                    opts.Callback(key)
                end
            end

            btn.MouseButton1Click:Connect(function()
                listening = true
                keyLbl.Text = '...'

                TweenService:Create(keyBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 44),
                }):Play()
            end)
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    updateKey(input.KeyCode)
                end
            end)
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and not listening and currentKey and input.KeyCode == currentKey then
                    if opts.OnPress then
                        opts.OnPress()
                    end
                end
            end)
            layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)
        end

        return tab
    end
    function window:Destroy()
        by_blankfelony['1']:Destroy()
    end

    return window
end

Library.NotificationSystem = NotificationSystem

return Library
