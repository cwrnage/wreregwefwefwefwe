local Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/storage/main/Drawing.lua"))();

local Library = {};
do
	Library = {
		Open = true;
		Accent = Color3.fromRGB(255, 40, 40);
		Pages = {};
		Sections = {};
		Flags = {};
		UnNamedFlags = 0;
		ThemeObjects = {};
		Instances = {};
		Holder = nil;
		OldSize = nil;
		ScreenGUI = nil;
		DropdownOpen = false,
		OptionListOpen = false,
		Keys = {
			[Enum.KeyCode.Space] = "Space",
			[Enum.KeyCode.Return] = "Return",
			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",
			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",
			[Enum.KeyCode.CapsLock] = "CAPS",
			[Enum.KeyCode.One] = "1",
			[Enum.KeyCode.Two] = "2",
			[Enum.KeyCode.Three] = "3",
			[Enum.KeyCode.Four] = "4",
			[Enum.KeyCode.Five] = "5",
			[Enum.KeyCode.Six] = "6",
			[Enum.KeyCode.Seven] = "7",
			[Enum.KeyCode.Eight] = "8",
			[Enum.KeyCode.Nine] = "9",
			[Enum.KeyCode.Zero] = "0",
			[Enum.KeyCode.KeypadOne] = "Num1",
			[Enum.KeyCode.KeypadTwo] = "Num2",
			[Enum.KeyCode.KeypadThree] = "Num3",
			[Enum.KeyCode.KeypadFour] = "Num4",
			[Enum.KeyCode.KeypadFive] = "Num5",
			[Enum.KeyCode.KeypadSix] = "Num6",
			[Enum.KeyCode.KeypadSeven] = "Num7",
			[Enum.KeyCode.KeypadEight] = "Num8",
			[Enum.KeyCode.KeypadNine] = "Num9",
			[Enum.KeyCode.KeypadZero] = "Num0",
			[Enum.KeyCode.Minus] = "-",
			[Enum.KeyCode.Equals] = "=",
			[Enum.KeyCode.Tilde] = "~",
			[Enum.KeyCode.LeftBracket] = "[",
			[Enum.KeyCode.RightBracket] = "]",
			[Enum.KeyCode.RightParenthesis] = ")",
			[Enum.KeyCode.LeftParenthesis] = "(",
			[Enum.KeyCode.Semicolon] = ",",
			[Enum.KeyCode.Quote] = "'",
			[Enum.KeyCode.BackSlash] = "\\",
			[Enum.KeyCode.Comma] = ",",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Slash] = "/",
			[Enum.KeyCode.Asterisk] = "*",
			[Enum.KeyCode.Plus] = "+",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Backquote] = "`",
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3",
			-- Added Gamepad support
			[Enum.KeyCode.ButtonA] = "BtnA",
			[Enum.KeyCode.ButtonB] = "BtnB",
			[Enum.KeyCode.ButtonX] = "BtnX",
			[Enum.KeyCode.ButtonY] = "BtnY",
			[Enum.KeyCode.ButtonL1] = "L1",
			[Enum.KeyCode.ButtonR1] = "R1",
			[Enum.KeyCode.ButtonL2] = "L2",
			[Enum.KeyCode.ButtonR2] = "R2",
			[Enum.KeyCode.ButtonL3] = "L3",
			[Enum.KeyCode.ButtonR3] = "R3",
			[Enum.KeyCode.ButtonStart] = "Start",
			[Enum.KeyCode.ButtonSelect] = "Select",
			[Enum.KeyCode.DPadUp] = "D-Up",
			[Enum.KeyCode.DPadDown] = "D-Down",
			[Enum.KeyCode.DPadLeft] = "D-Left",
			[Enum.KeyCode.DPadRight] = "D-Right",
		};
		Connections = {};
		FontSize = 12;
		VisValues = {};
		UIKey = Enum.KeyCode.Insert;
		Notifs = {};
	}

	-- // Ignores
	local Flags = {}
	local ColorHolders = {}

	-- // Extension
	Library.__index = Library
	Library.Pages.__index = Library.Pages
	Library.Sections.__index = Library.Sections
	local LocalPlayer = game:GetService('Players').LocalPlayer;
	local Mouse = LocalPlayer:GetMouse();
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")

	-- // Misc Functions
	do
		function Library:Connection(signal, Callback)
			local Con = signal:Connect(Callback)
			return Con
		end
		function Library:Disconnect(Connection)
			Connection:Disconnect()
		end
		function Library:Round(Number, Float)
			return Float * math.floor(Number / Float)
		end
		function Library.NextFlag()
			Library.UnNamedFlags = Library.UnNamedFlags + 1
			return string.format("%.14g", Library.UnNamedFlags)
		end
		function Library:GetConfig()
			local Config = ""
			for Index, Value in pairs(self.Flags) do
				if
					Index ~= "ConfigConfig_List"
					and Index ~= "ConfigConfig_Load"
					and Index ~= "ConfigConfig_Save"
				then
					local Value2 = Value
					local Final = ""
					if typeof(Value2) == "Color3" then
						local hue, sat, val = Value2:ToHSV()
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
					elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
						local hue, sat, val = Value2.Color:ToHSV()
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
					elseif typeof(Value2) == "table" and Value.Mode then
						local Values = Value.current
						Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
					elseif Value2 ~= nil then
						if typeof(Value2) == "boolean" then
							Value2 = ("bool(%s)"):format(tostring(Value2))
						elseif typeof(Value2) == "table" then
							local New = "table("
							for Index2, Value3 in pairs(Value2) do
								New = New .. Value3 .. ","
							end
							if New:sub(#New) == "," then
								New = New:sub(0, #New - 1)
							end
							Value2 = New .. ")"
						elseif typeof(Value2) == "string" then
							Value2 = ("string(%s)"):format(Value2)
						elseif typeof(Value2) == "number" then
							Value2 = ("number(%s)"):format(Value2)
						end
						Final = Value2
					end
					Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
				end
			end
			return Config
		end
		function Library:LoadConfig(Config)
			local Table = string.split(Config, "\n")
			local Table2 = {}
			for Index, Value in pairs(Table) do
				local Table3 = string.split(Value, ":")
				if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
					local Value = Table3[2]:sub(2, #Table3[2])
					if Value:sub(1, 3) == "rgb" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						Value = Table4
					elseif Value:sub(1, 3) == "key" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						if Table4[1] == "nil" and Table4[2] == "nil" then
							Table4[1] = nil
							Table4[2] = nil
						end
						Value = Table4
					elseif Value:sub(1, 4) == "bool" then
						local Bool = Value:sub(6, #Value - 1)
						Value = Bool == "true"
					elseif Value:sub(1, 5) == "table" then
						local Table4 = string.split(Value:sub(7, #Value - 1), ",")
						Value = Table4
					elseif Value:sub(1, 6) == "string" then
						local String = Value:sub(8, #Value - 1)
						Value = String
					elseif Value:sub(1, 6) == "number" then
						local Number = tonumber(Value:sub(8, #Value - 1))
						Value = Number
					end
					Table2[Table3[1]] = Value
				end
			end
			for i, v in pairs(Table2) do
				if Flags[i] then
					if typeof(Flags[i]) == "table" then
						Flags[i]:Set(v)
					else
						Flags[i](v)
					end
				end
			end
		end
		function Library:SetOpen(bool)
			if typeof(bool) == 'boolean' then
				Library.Open = bool;
				if Library.Open then
					Library.Holder.Visible = true
					game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Library.OldSize.X.Offset,0,Library.OldSize.Y.Offset)}):Play()
				else
					game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0,0,20)}):Play()
					task.wait(0.25)
					Library.Holder.Visible = false
				end
			end
		end;
		function Library:ChangeAccent(Color)
			Library.Accent = Color
			for obj, theme in next, Library.ThemeObjects do
				if theme:IsA("Frame") or theme:IsA("TextButton") then
					theme.BackgroundColor3 = Color
				elseif theme:IsA("TextLabel") then
					theme.TextColor3 = Color
				elseif theme:IsA("ScrollingFrame") then
					theme.ScrollBarImageColor3 = Library.Accent
				end
			end
		end
		function Library:IsMouseOverFrame(Frame)
			local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
			if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
				and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
				return true;
			end;
			return false;
		end;

		function MakeDraggable(Instance)
			local Dragging
			local DragInput
			local StartPosition
			local StartMousePosition

			local function UpdateInput(input)
				local delta = input.Position - StartMousePosition
				Instance.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
			end

			Instance.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					StartMousePosition = input.Position
					StartPosition = Instance.Position
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end)
				end
			end)

			Instance.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					DragInput = input
				end
			end)

			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if Dragging and input == DragInput then
					UpdateInput(input)
				end
			end)
		end;

		-- // Detect executor name
		function Library:GetExecutor()
			if syn then return "Synapse X"
			elseif KRNL_LOADED then return "KRNL"
			elseif pebc_execute then return "Electron"
			elseif PROTOSMASHER_LOADED then return "ProtoSmasher"
			elseif getexecutorname then
				local s, r = pcall(getexecutorname)
				if s then return r end
			elseif identifyexecutor then
				local s, r = pcall(identifyexecutor)
				if s then return r end
			end
			return "Unknown"
		end
	end

	-- // Colorpicker Element
	do
		function Library:NewPicker(name, default, parent, count, flag, callback)
			local UIS = game:GetService("UserInputService")
			local TweenService = game:GetService("TweenService")
			local mouse_position = Vector2.new(0, 0)

			local function setMousePos(pos)
				if typeof(pos) == "Vector3" then
					mouse_position = Vector2.new(pos.X, pos.Y)
				elseif typeof(pos) == "Vector2" then
					mouse_position = pos
				end
			end

			UIS.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then
					setMousePos(input.Position)
				end
			end)

			UIS.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					setMousePos(input.Position)
				end
			end)

			local ColorpickerFrame = Instance.new("TextButton")
			ColorpickerFrame.BackgroundColor3 = default
			ColorpickerFrame.BorderSizePixel = 0
			if count == 1 then
				ColorpickerFrame.Position = UDim2.new(1, -(count * 20), 0.5, 0)
			else
				ColorpickerFrame.Position = UDim2.new(1, -(count * 20) - (count * 4), 0.5, 0)
			end
			ColorpickerFrame.Size = UDim2.new(0, 20, 0, 20)
			ColorpickerFrame.AnchorPoint = Vector2.new(0, 0.5)
			ColorpickerFrame.Text = ""
			ColorpickerFrame.AutoButtonColor = false
			ColorpickerFrame.Parent = parent
			Instance.new("UICorner", ColorpickerFrame).CornerRadius = UDim.new(0, 4)
			local Stroke = Instance.new("UIStroke", ColorpickerFrame)
			Stroke.Color = Color3.fromRGB(50, 50, 50)

			local Colorpicker = Instance.new("TextButton")
			Colorpicker.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			Colorpicker.BorderSizePixel = 0
			Colorpicker.Size = UDim2.new(0, 185, 0, 190)
			Colorpicker.Parent = Library.ScreenGUI
			Colorpicker.ZIndex = 100
			Colorpicker.Visible = false
			Colorpicker.Text = ""
			Colorpicker.AutoButtonColor = false
			Instance.new("UICorner", Colorpicker).CornerRadius = UDim.new(0, 8)
			local CpStroke = Instance.new("UIStroke", Colorpicker)
			CpStroke.Color = Color3.fromRGB(45, 45, 45)
			CpStroke.Thickness = 1

			local h, s, v = default:ToHSV()

			local ImageButton = Instance.new("ImageButton")
			ImageButton.Image = "rbxassetid://14684562507"
			ImageButton.Position = UDim2.new(0.056, 0, 0.026, 0)
			ImageButton.Size = UDim2.new(0, 160, 0, 154)
			ImageButton.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			ImageButton.AutoButtonColor = false
			ImageButton.Parent = Colorpicker
			Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(0, 4)

			local SVSlider = Instance.new("Frame")
			SVSlider.Size = UDim2.new(0, 8, 0, 8)
			SVSlider.BackgroundTransparency = 1
			SVSlider.Parent = ImageButton
			Instance.new("UICorner", SVSlider).CornerRadius = UDim.new(1, 0)
			local Stroke2 = Instance.new("UIStroke", SVSlider)
			Stroke2.Color = Color3.fromRGB(255, 255, 255)
			Stroke2.Thickness = 2

			local HueBar = Instance.new("ImageButton")
			HueBar.Image = "http://www.roblox.com/asset/?id=16789872274"
			HueBar.Position = UDim2.new(0.5, 0, 0, 165)
			HueBar.Size = UDim2.new(0, 160, 0, 10)
			HueBar.AnchorPoint = Vector2.new(0.5, 0)
			HueBar.BackgroundTransparency = 1
			HueBar.AutoButtonColor = false
			HueBar.Parent = Colorpicker
			Instance.new("UICorner", HueBar).CornerRadius = UDim.new(1, 0)

			local HueSlider = Instance.new("Frame")
			HueSlider.Size = UDim2.new(0, 14, 0, 14)
			HueSlider.AnchorPoint = Vector2.new(0, 0.5)
			HueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
			HueSlider.Parent = HueBar
			Instance.new("UICorner", HueSlider).CornerRadius = UDim.new(1, 0)
			local HueStroke = Instance.new("UIStroke", HueSlider)
			HueStroke.Color = Color3.fromRGB(40, 40, 40)

			local draggingSV = false
			local draggingHue = false

			local function update()
				local palPos = ImageButton.AbsolutePosition
				local huePos = HueBar.AbsolutePosition
				local palSize = ImageButton.AbsoluteSize
				local hueSize = HueBar.AbsoluteSize
				local relPal = mouse_position - palPos
				local relHue = mouse_position - huePos

				if draggingSV then
					s = math.clamp(1 - relPal.X / palSize.X, 0, 1)
					v = math.clamp(1 - relPal.Y / palSize.Y, 0, 1)
				end
				if draggingHue then
					h = math.clamp(relHue.X / hueSize.X, 0, 1)
				end

				local color = Color3.fromHSV(h, s, v)
				ImageButton.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				ColorpickerFrame.BackgroundColor3 = color
				SVSlider.Position = UDim2.new(1 - s, 0, 1 - v, 0)
				HueSlider.Position = UDim2.new(h, -6, 0.5, 0)

				if flag then
					Library.Flags[flag] = color
				end
				callback(color)
			end

			local function set(color)
				if typeof(color) == "table" then
					color = Color3.fromHSV(color[1], color[2], color[3])
				elseif typeof(color) == "string" then
					color = Color3.fromHex(color)
				end
				h, s, v = color:ToHSV()
				update()
			end

			Flags[flag] = set
			set(default)

			ImageButton.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					draggingSV = true
					setMousePos(i.Position)
					update()
				end
			end)
			ImageButton.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					draggingSV = false
				end
			end)
			HueBar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					draggingHue = true
					setMousePos(i.Position)
					update()
				end
			end)
			HueBar.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					draggingHue = false
				end
			end)

			Library:Connection(ColorpickerFrame.MouseButton1Click, function()
				Colorpicker.Visible = not Colorpicker.Visible
				Colorpicker.Position = UDim2.fromOffset(ColorpickerFrame.AbsolutePosition.X - 190, ColorpickerFrame.AbsolutePosition.Y)
			end)

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Colorpicker.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(Colorpicker) and not Library:IsMouseOverFrame(ColorpickerFrame) then
						Colorpicker.Visible = false
					end
				end
			end)

			return {Set = set}
		end
	end

	-- // Page Element
	function Library:Page(Properties)
		if not Properties then Properties = {} end
		local Page = {
			Name = Properties.Name or "Page",
			Icon = Properties.Icon or Properties.icon or nil,
			Window = self,
			Open = false,
			Sections = {},
			Elements = {},
		}

		local TabButton = Instance.new("TextButton", Page.Window.Elements.Tabs)
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 1
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 32)
		TabButton.ZIndex = 52
		TabButton.Text = ""
		TabButton.AutoButtonColor = false

		local ActiveFill = Instance.new("Frame", TabButton)
		ActiveFill.Size = UDim2.new(1, 0, 1, 0)
		ActiveFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ActiveFill.BackgroundTransparency = 1
		ActiveFill.BorderSizePixel = 0
		ActiveFill.ZIndex = 53
		Instance.new("UICorner", ActiveFill).CornerRadius = UDim.new(0, 6)

		local HoverFill = Instance.new("Frame", TabButton)
		HoverFill.Size = UDim2.new(1, 0, 1, 0)
		HoverFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		HoverFill.BackgroundTransparency = 1
		HoverFill.BorderSizePixel = 0
		HoverFill.ZIndex = 53
		Instance.new("UICorner", HoverFill).CornerRadius = UDim.new(0, 6)

		local AccentBar = Instance.new("Frame", TabButton)
		AccentBar.Position = UDim2.new(0, 0, 0.5, -8)
		AccentBar.Size = UDim2.new(0, 2, 0, 16)
		AccentBar.BackgroundColor3 = Library.Accent
		AccentBar.BackgroundTransparency = 1
		AccentBar.BorderSizePixel = 0
		AccentBar.ZIndex = 54
		table.insert(Library.ThemeObjects, AccentBar)

		local Icon = Instance.new("ImageLabel", TabButton)
		Icon.Position = UDim2.new(0, 10, 0.5, 0)
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.Size = UDim2.new(0, 16, 0, 16)
		Icon.BackgroundTransparency = 1
		Icon.Image = Page.Icon or "rbxassetid://6034509993"
		Icon.ImageColor3 = Color3.fromRGB(90, 90, 90)
		Icon.ZIndex = 54

		local Title = Instance.new("TextLabel", TabButton)
		Title.Position = UDim2.new(0, 34, 0, 0)
		Title.Size = UDim2.new(1, -34, 1, 0)
		Title.BackgroundTransparency = 1
		Title.Text = Page.Name
		Title.Font = Enum.Font.Gotham
		Title.TextSize = 12
		Title.TextColor3 = Color3.fromRGB(90, 90, 90)
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.ZIndex = 54

		Library:Connection(TabButton.MouseEnter, function()
			if not Page.Open then
				TweenService:Create(HoverFill, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
				TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
			end
		end)
		Library:Connection(TabButton.MouseLeave, function()
			TweenService:Create(HoverFill, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			if not Page.Open then
				TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(90, 90, 90)}):Play()
			end
		end)

		local NewPage = Instance.new("Frame", Page.Window.Elements.PageHolder)
		NewPage.Size = UDim2.new(1, 0, 1, 0)
		NewPage.BackgroundTransparency = 1
		NewPage.Visible = false
		NewPage.ZIndex = 53

		local Left = Instance.new("ScrollingFrame", NewPage)
		local Right = Instance.new("ScrollingFrame", NewPage)

		for _, column in ipairs({Left, Right}) do
			column.CanvasSize = UDim2.new(0, 0, 0, 0)
			column.ScrollBarImageTransparency = 1
			column.ScrollingDirection = Enum.ScrollingDirection.Y
			column.BackgroundTransparency = 1
			column.BorderSizePixel = 0
			column.ZIndex = 54
		end

		Left.Name = "Left"
		Left.Size = UDim2.new(0.5, -5, 1, 0)
		Left.Position = UDim2.new(0, 0, 0, 0)

		Right.Name = "Right"
		Right.Size = UDim2.new(0.5, -5, 1, 0)
		Right.Position = UDim2.new(0.5, 5, 0, 0)

		local function SetupColumn(column)
			local layout = Instance.new("UIListLayout", column)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 8)
			local function UpdateCanvas()
				column.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
			end
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
			UpdateCanvas()
		end

		SetupColumn(Left)
		SetupColumn(Right)

		function Page:Turn(state)
			Page.Open = state
			NewPage.Visible = state

			if state then
				TweenService:Create(ActiveFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.82}):Play()
				TweenService:Create(AccentBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230,230,230)}):Play()
				TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Library.Accent}):Play()
				HoverFill.BackgroundTransparency = 1
			else
				TweenService:Create(ActiveFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
				TweenService:Create(AccentBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
				TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(90,90,90)}):Play()
				TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(90,90,90)}):Play()
			end
		end

		Library:Connection(TabButton.MouseButton1Click, function()
			if not Page.Open then
				Page:Turn(true)
				for _, p in pairs(Page.Window.Pages) do
					if p ~= Page and p.Open then
						p:Turn(false)
					end
				end
			end
		end)

		Page.Elements = {
			Left = Left,
			Right = Right,
			TabButton = TabButton
		}

		if #Page.Window.Pages == 0 then
			Page:Turn(true)
		end

		Page.Window.Pages[#Page.Window.Pages + 1] = Page
		Page.Window:UpdateTabs()

		return setmetatable(Page, Library.Pages)
	end

	-- // Section with auto-sizing support
	function Pages:Section(Properties)
		Properties = Properties or {}

		local Section = {
			Name = Properties.Name or "Section",
			Page = self,
			Side = (Properties.Side or Properties.side or "left"):lower(),
			Size = Properties.Size or Properties.size or "auto",
			Icon = Properties.Icon or Properties.icon or nil,
			Badge = Properties.Badge or Properties.badge or nil,
			Color = Properties.Color or Properties.color or nil,
			Elements = {},
		}

		local isAuto = (Section.Size == "auto")

		local Parent =
			Section.Side == "left"
			and Section.Page.Elements.Left
			or Section.Page.Elements.Right

		local Frame = Instance.new("Frame", Parent)
		Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Frame.BorderSizePixel = 0
		Frame.LayoutOrder = #Section.Page.Sections + 1
		Frame.ZIndex = 55

		if isAuto then
			Frame.Size = UDim2.new(1, 0, 0, 0)
			Frame.AutomaticSize = Enum.AutomaticSize.Y
		else
			Frame.Size = UDim2.new(1, 0, 0, Section.Size)
			Frame.AutomaticSize = Enum.AutomaticSize.None
		end

		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
		local FrameStroke = Instance.new("UIStroke", Frame)
		FrameStroke.Color = Color3.fromRGB(30, 30, 30)
		FrameStroke.Thickness = 1

		local FrameGrad = Instance.new("UIGradient", Frame)
		FrameGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(13,13,13)),
		})
		FrameGrad.Rotation = 90

		local HeaderRow = Instance.new("Frame", Frame)
		HeaderRow.Name = "HeaderRow"
		HeaderRow.Position = UDim2.new(0, 0, 0, 0)
		HeaderRow.Size = UDim2.new(1, 0, 0, 28)
		HeaderRow.BackgroundTransparency = 1
		HeaderRow.BorderSizePixel = 0
		HeaderRow.ZIndex = 56

		local headerTextOffset = 10

		if Section.Icon then
			local SectionIcon = Instance.new("ImageLabel", HeaderRow)
			SectionIcon.Name = "SectionIcon"
			SectionIcon.Position = UDim2.new(0, 8, 0.5, 0)
			SectionIcon.AnchorPoint = Vector2.new(0, 0.5)
			SectionIcon.Size = UDim2.fromOffset(14, 14)
			SectionIcon.BackgroundTransparency = 1
			SectionIcon.Image = Section.Icon
			SectionIcon.ImageColor3 = Section.Color or Library.Accent
			SectionIcon.ZIndex = 57
			headerTextOffset = 26
			table.insert(Library.ThemeObjects, SectionIcon)
		end

		local HeaderTitle = Instance.new("TextLabel", HeaderRow)
		HeaderTitle.Position = UDim2.new(0, headerTextOffset, 0, 0)
		HeaderTitle.Size = UDim2.new(1, -(headerTextOffset + 10), 1, 0)
		HeaderTitle.BackgroundTransparency = 1
		HeaderTitle.Text = Section.Name
		HeaderTitle.Font = Enum.Font.GothamBold
		HeaderTitle.TextSize = 11
		HeaderTitle.TextColor3 = Section.Color or Color3.fromRGB(160, 160, 160)
		HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
		HeaderTitle.ZIndex = 57

		if Section.Badge then
			local BadgeFrame = Instance.new("Frame", HeaderRow)
			BadgeFrame.Name = "Badge"
			BadgeFrame.AnchorPoint = Vector2.new(1, 0.5)
			BadgeFrame.Position = UDim2.new(1, -8, 0.5, 0)
			BadgeFrame.Size = UDim2.fromOffset(0, 14)
			BadgeFrame.AutomaticSize = Enum.AutomaticSize.X
			BadgeFrame.BackgroundColor3 = Section.Color or Library.Accent
			BadgeFrame.BorderSizePixel = 0
			BadgeFrame.ZIndex = 57
			Instance.new("UICorner", BadgeFrame).CornerRadius = UDim.new(0, 3)
			local BP = Instance.new("UIPadding", BadgeFrame)
			BP.PaddingLeft = UDim.new(0, 4)
			BP.PaddingRight = UDim.new(0, 4)
			local BadgeText = Instance.new("TextLabel", BadgeFrame)
			BadgeText.Size = UDim2.new(0, 0, 1, 0)
			BadgeText.AutomaticSize = Enum.AutomaticSize.X
			BadgeText.BackgroundTransparency = 1
			BadgeText.Text = Section.Badge
			BadgeText.Font = Enum.Font.GothamBold
			BadgeText.TextSize = 9
			BadgeText.TextColor3 = Color3.fromRGB(255,255,255)
			BadgeText.ZIndex = 58
			table.insert(Library.ThemeObjects, BadgeFrame)
		end

		local Divider = Instance.new("Frame", Frame)
		Divider.Position = UDim2.new(0, 8, 0, 28)
		Divider.Size = UDim2.new(1, -16, 0, 1)
		Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Divider.BorderSizePixel = 0
		Divider.ZIndex = 56

		local Content = Instance.new("Frame", Frame)
		Content.Position = UDim2.new(0, 10, 0, 36)
		Content.BackgroundTransparency = 1
		Content.BorderSizePixel = 0
		Content.ZIndex = 56

		if isAuto then
			Content.Size = UDim2.new(1, -20, 0, 0)
			Content.AutomaticSize = Enum.AutomaticSize.Y
		else
			Content.Size = UDim2.new(1, -20, 1, -44)
			Content.AutomaticSize = Enum.AutomaticSize.None
		end

		local Layout = Instance.new("UIListLayout", Content)
		Layout.Padding = UDim.new(0, 8)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder

		local BottomPad = Instance.new("UIPadding", Content)
		BottomPad.PaddingBottom = UDim.new(0, 8)

		Section.Elements.SectionContent = Content
		Section.Page.Sections[#Section.Page.Sections + 1] = Section

		return setmetatable(Section, Library.Sections)
	end

	-- // Toggle
	function Sections:Toggle(Properties)
		if not Properties then Properties = {} end
		local Toggle = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
			Risk = Properties.Risk or false,
			Name = Properties.Name or "Toggle",
			State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or false),
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
			Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			Toggled = false,
		}

		local NewToggle = Instance.new('TextButton', Toggle.Section.Elements.SectionContent)
		local ToggleTitle = Instance.new('TextLabel', NewToggle)
		local ToggleFrame = Instance.new('Frame', NewToggle)
		Instance.new('UICorner', ToggleFrame).CornerRadius = UDim.new(1, 0)
		local ToggleAccent = Instance.new('Frame', ToggleFrame)
		Instance.new('UICorner', ToggleAccent).CornerRadius = UDim.new(1, 0)
		local Circle = Instance.new('Frame', ToggleFrame)
		Instance.new('UICorner', Circle).CornerRadius = UDim.new(1, 0)
		local CircleGlow = Instance.new("UIStroke", Circle)
		CircleGlow.Color = Color3.fromRGB(255,255,255)
		CircleGlow.Transparency = 0.7
		CircleGlow.Thickness = 1

		NewToggle.Name = "NewToggle"
		NewToggle.Size = UDim2.new(1,0,0,15)
		NewToggle.BackgroundTransparency = 1
		NewToggle.BorderSizePixel = 0
		NewToggle.Text = ""
		NewToggle.AutoButtonColor = false
		NewToggle.ZIndex = 53

		ToggleTitle.Size = UDim2.new(1,-50,0,18)
		ToggleTitle.BackgroundTransparency = 1
		ToggleTitle.BorderSizePixel = 0
		ToggleTitle.Text = Toggle.Name
		ToggleTitle.TextColor3 = Color3.fromRGB(180,180,180)
		ToggleTitle.Font = Enum.Font.Gotham
		ToggleTitle.TextSize = Library.FontSize
		ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

		ToggleFrame.Position = UDim2.new(1,-34,0.5,-7)
		ToggleFrame.Size = UDim2.new(0,34,0,15)
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.ZIndex = 53

		local TFStroke = Instance.new("UIStroke", ToggleFrame)
		TFStroke.Color = Color3.fromRGB(45,45,45)
		TFStroke.Thickness = 1

		ToggleAccent.Position = UDim2.new(0,0,0,0)
		ToggleAccent.Size = UDim2.new(1,0,1,0)
		ToggleAccent.BackgroundColor3 = Library.Accent
		ToggleAccent.BackgroundTransparency = 1
		ToggleAccent.BorderSizePixel = 0
		ToggleAccent.ZIndex = 53
		table.insert(Library.ThemeObjects, ToggleAccent)

		Circle.Position = UDim2.new(0,2,0.5,-5)
		Circle.Size = UDim2.new(0,10,0,10)
		Circle.BackgroundColor3 = Color3.fromRGB(220,220,220)
		Circle.BorderSizePixel = 0
		Circle.ZIndex = 54

		local function SetState()
			Toggle.Toggled = not Toggle.Toggled
			if Toggle.Toggled then
				TweenService:Create(ToggleAccent, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1,-13,0.5,-5)}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
				TweenService:Create(TFStroke, TweenInfo.new(0.2), {Color = Library.Accent}):Play()
			else
				TweenService:Create(ToggleAccent, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,3,0.5,-6)}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140,140,140)}):Play()
				TweenService:Create(TFStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45,45,45)}):Play()
			end
			Library.Flags[Toggle.Flag] = Toggle.Toggled
			Toggle.Callback(Toggle.Toggled)
		end

		function Toggle:OptionList(Properties)
			if not Properties then Properties = {} end
			local Section = { Elements = {}, Content = {} }
			local OptionButton = Instance.new('ImageButton', NewToggle)
			local OptionList = Instance.new('Frame', OptionButton)
			Instance.new('UICorner', OptionList).CornerRadius = UDim.new(0, 6)
			local UIStroke = Instance.new('UIStroke', OptionList)
			local OptionContent = Instance.new('Frame', OptionList)
			local UIListLayout = Instance.new('UIListLayout', OptionContent)

			OptionButton.Position = UDim2.new(1,-63,0,1)
			OptionButton.Size = UDim2.new(0,15,0,15)
			OptionButton.BackgroundTransparency = 1
			OptionButton.BorderSizePixel = 0
			OptionButton.Image = "http://www.roblox.com/asset/?id=6031280882"
			OptionButton.ImageColor3 = Color3.new(0.7843,0.7843,0.7843)
			OptionButton.ZIndex = 54

			OptionList.Position = UDim2.new(0,70,0,-10)
			OptionList.Size = UDim2.new(0,200,0,10)
			OptionList.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			OptionList.BorderSizePixel = 0
			OptionList.AutomaticSize = Enum.AutomaticSize.Y
			OptionList.Visible = false
			OptionList.ZIndex = 54
			UIStroke.Color = Color3.fromRGB(40, 40, 40)

			OptionContent.Position = UDim2.new(0,10,0,10)
			OptionContent.Size = UDim2.new(1,-20,1,-10)
			OptionContent.BackgroundTransparency = 1
			OptionContent.BorderSizePixel = 0
			OptionContent.AutomaticSize = Enum.AutomaticSize.Y
			OptionContent.ZIndex = 54
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,4)

			Library:Connection(OptionButton.MouseButton1Click, function()
				local State = not OptionList.Visible
				OptionList.Visible = State
				Library.OptionListOpen = State
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Library.DropdownOpen then return end
				if OptionList.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(OptionList) and not Library:IsMouseOverFrame(OptionButton) then
						OptionList.Visible = false
					end
				end
			end)
			Section.Elements = { SectionContent = OptionContent }
			return setmetatable(Section, Library.Sections)
		end

		function Toggle.Set(bool)
			bool = type(bool) == "boolean" and bool or false
			if Toggle.Toggled ~= bool then SetState() end
		end
		Toggle.Set(Toggle.State)
		Library.Flags[Toggle.Flag] = Toggle.State
		Flags[Toggle.Flag] = Toggle.Set

		Library:Connection(NewToggle.MouseButton1Click, SetState)
		return Toggle
	end

	-- // Nest
	function Sections:Nest(Properties)
		if not Properties then Properties = {} end
		local Section = {
			Name = Properties.Name or "Section",
			RealSection = self,
			Size = Properties.size or Properties.Size or 200,
		}

		local NewNest = Instance.new('Frame', Section.RealSection.Elements.SectionContent)
		local NestTitle = Instance.new('TextLabel', NewNest)
		local NestFrame = Instance.new('Frame', NewNest)
		local NestContent = Instance.new('Frame', NestFrame)
		local UIListLayout = Instance.new('UIListLayout', NestContent)

		NewNest.Name = "NewNest"
		NewNest.Size = UDim2.new(1,0,0,25)
		NewNest.BackgroundTransparency = 1
		NewNest.BorderSizePixel = 0
		NewNest.ZIndex = 53
		NewNest.AutomaticSize = Enum.AutomaticSize.Y

		NestTitle.Size = UDim2.new(1,-50,0,18)
		NestTitle.BackgroundTransparency = 1
		NestTitle.BorderSizePixel = 0
		NestTitle.Text = Section.Name
		NestTitle.TextColor3 = Color3.fromRGB(180,180,180)
		NestTitle.Font = Enum.Font.Gotham
		NestTitle.TextSize = Library.FontSize
		NestTitle.TextXAlignment = Enum.TextXAlignment.Left

		NestFrame.Position = UDim2.new(0,0,0,25)
		NestFrame.Size = UDim2.new(1,0,0,0)
		NestFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
		NestFrame.BorderSizePixel = 0
		NestFrame.ZIndex = 53
		NestFrame.AutomaticSize = Enum.AutomaticSize.Y
		Instance.new('UICorner', NestFrame).CornerRadius = UDim.new(0, 6)
		local NFStroke = Instance.new("UIStroke", NestFrame)
		NFStroke.Color = Color3.fromRGB(38,38,38)

		NestContent.Position = UDim2.new(0,10,0,10)
		NestContent.Size = UDim2.new(1,-20,0,0)
		NestContent.BackgroundTransparency = 1
		NestContent.BorderSizePixel = 0
		NestContent.ZIndex = 53
		NestContent.AutomaticSize = Enum.AutomaticSize.Y
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0,8)
		Instance.new('UIPadding', NestContent).PaddingBottom = UDim.new(0, 10)

		Section.Elements = { SectionContent = NestContent }
		return setmetatable(Section, Library.Sections)
	end

	-- // Slider
	function Sections:Slider(Properties)
		if not Properties then Properties = {} end
		local Slider = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
			Name = Properties.Name or "Slider",
			Min = Properties.Min or Properties.min or 0,
			Max = Properties.Max or Properties.max or 100,
			Decimals = Properties.Decimals or Properties.decimals or 1,
			Default = Properties.Default or Properties.default or Properties.def or Properties.Def or 0,
			Suffix = Properties.Suffix or Properties.suffix or "",
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
			Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			Value = 0,
		}

		local NewSlider = Instance.new('TextButton', Slider.Section.Elements.SectionContent)
		local SliderTitle = Instance.new('TextLabel', NewSlider)
		local SliderValue = Instance.new('TextLabel', NewSlider)
		local SliderFrame = Instance.new('Frame', NewSlider)
		local SliderAccent = Instance.new('Frame', SliderFrame)

		NewSlider.Name = "NewSlider"
		NewSlider.Size = UDim2.new(1,0,0,28)
		NewSlider.BackgroundTransparency = 1
		NewSlider.BorderSizePixel = 0
		NewSlider.Text = ""
		NewSlider.AutoButtonColor = false
		NewSlider.ZIndex = 53

		SliderTitle.Size = UDim2.new(1,-50,0,18)
		SliderTitle.BackgroundTransparency = 1
		SliderTitle.BorderSizePixel = 0
		SliderTitle.Text = Slider.Name
		SliderTitle.TextColor3 = Color3.fromRGB(180,180,180)
		SliderTitle.Font = Enum.Font.Gotham
		SliderTitle.TextSize = Library.FontSize
		SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

		SliderValue.Position = UDim2.new(1,-50,0,0)
		SliderValue.Size = UDim2.new(0,50,0,18)
		SliderValue.BackgroundTransparency = 1
		SliderValue.BorderSizePixel = 0
		SliderValue.Text = tostring(Slider.Default) .. Slider.Suffix
		SliderValue.TextColor3 = Color3.fromRGB(180,180,180)
		SliderValue.Font = Enum.Font.Gotham
		SliderValue.TextSize = Library.FontSize
		SliderValue.TextXAlignment = Enum.TextXAlignment.Right

		SliderFrame.Position = UDim2.new(0,0,0,21)
		SliderFrame.Size = UDim2.new(1,0,0,5)
		SliderFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
		SliderFrame.BorderSizePixel = 0
		SliderFrame.ZIndex = 53
		Instance.new('UICorner', SliderFrame).CornerRadius = UDim.new(1, 0)
		local SFStroke = Instance.new("UIStroke", SliderFrame)
		SFStroke.Color = Color3.fromRGB(45,45,45)
		SFStroke.Thickness = 1

		SliderAccent.Size = UDim2.new((Slider.Default - Slider.Min) / (Slider.Max - Slider.Min),0,1,0)
		SliderAccent.BackgroundColor3 = Library.Accent
		SliderAccent.BorderSizePixel = 0
		SliderAccent.ZIndex = 53
		Instance.new('UICorner', SliderAccent).CornerRadius = UDim.new(1, 0)
		table.insert(Library.ThemeObjects, SliderAccent)

		local function Set(value)
			value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)
			Slider.Value = value
			SliderValue.Text = tostring(value) .. Slider.Suffix
			SliderAccent.Size = UDim2.new((value - Slider.Min) / (Slider.Max - Slider.Min),0,1,0)
			Library.Flags[Slider.Flag] = value
			Slider.Callback(value)
		end

		local function Update()
			local Percent = math.clamp((Mouse.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
			local Value = Slider.Min + (Slider.Max - Slider.Min) * Percent
			Set(Value)
		end

		NewSlider.MouseButton1Down:Connect(function()
			Update()
			local Connection
			Connection = game:GetService('UserInputService').InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					Update()
				end
			end)
			game:GetService('UserInputService').InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Connection:Disconnect()
				end
			end)
		end)

		function Slider:Set(value) Set(value) end
		Slider:Set(Slider.Default)
		Library.Flags[Slider.Flag] = Slider.Default
		Flags[Slider.Flag] = Set

		return Slider
	end

	-- // List (Dropdown)
	function Sections:List(Properties)
		if not Properties then Properties = {} end
		local Dropdown = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
			Name = Properties.Name or "Dropdown",
			Options = Properties.Options or {},
			Max = Properties.Max or nil,
			State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil),
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
			Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			OptionInsts = {},
		}

		local NewDropdown = Instance.new('TextButton', Dropdown.Section.Elements.SectionContent)
		local DropdownTitle = Instance.new('TextLabel', NewDropdown)
		local ToggleFrame = Instance.new('TextButton', NewDropdown)
		local DropdownTitle_2 = Instance.new('TextLabel', ToggleFrame)
		local Icon = Instance.new('ImageLabel', ToggleFrame)

		local ToggleContent = Instance.new('ScrollingFrame', Library.ScreenGUI)
		ToggleContent.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		ToggleContent.BorderSizePixel = 0
		ToggleContent.ZIndex = 100
		ToggleContent.Visible = false
		ToggleContent.ScrollBarThickness = 2
		ToggleContent.ScrollBarImageColor3 = Library.Accent
		Instance.new('UICorner', ToggleContent).CornerRadius = UDim.new(0, 6)
		local UIListLayout = Instance.new('UIListLayout', ToggleContent)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local UIStroke = Instance.new('UIStroke', ToggleContent)
		UIStroke.Color = Color3.fromRGB(40, 40, 40)

		NewDropdown.Name = "NewDropdown"
		NewDropdown.Size = UDim2.new(1,0,0,42)
		NewDropdown.BackgroundTransparency = 1
		NewDropdown.BorderSizePixel = 0
		NewDropdown.Text = ""
		NewDropdown.AutoButtonColor = false
		NewDropdown.ZIndex = 53

		DropdownTitle.Size = UDim2.new(1,-50,0,18)
		DropdownTitle.BackgroundTransparency = 1
		DropdownTitle.BorderSizePixel = 0
		DropdownTitle.Text = Dropdown.Name
		DropdownTitle.TextColor3 = Color3.fromRGB(180,180,180)
		DropdownTitle.Font = Enum.Font.Gotham
		DropdownTitle.TextSize = Library.FontSize
		DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

		ToggleFrame.Position = UDim2.new(0,0,0,20)
		ToggleFrame.Size = UDim2.new(1,0,0,22)
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.Text = ""
		ToggleFrame.AutoButtonColor = false
		ToggleFrame.ZIndex = 54
		Instance.new('UICorner', ToggleFrame).CornerRadius = UDim.new(0, 6)
		local TFStroke = Instance.new("UIStroke", ToggleFrame)
		TFStroke.Color = Color3.fromRGB(38,38,38)

		DropdownTitle_2.Position = UDim2.new(0,8,0,0)
		DropdownTitle_2.Size = UDim2.new(1,-34,1,0)
		DropdownTitle_2.BackgroundTransparency = 1
		DropdownTitle_2.Text = ""
		DropdownTitle_2.TextColor3 = Color3.fromRGB(200,200,200)
		DropdownTitle_2.Font = Enum.Font.Gotham
		DropdownTitle_2.TextSize = Library.FontSize
		DropdownTitle_2.TextXAlignment = Enum.TextXAlignment.Left
		DropdownTitle_2.TextTruncate = Enum.TextTruncate.AtEnd

		Icon.Position = UDim2.new(1,-22,0,5)
		Icon.Size = UDim2.new(0,14,0,14)
		Icon.BackgroundTransparency = 1
		Icon.BorderSizePixel = 0
		Icon.Image = "http://www.roblox.com/asset/?id=6034818372"
		Icon.ImageColor3 = Color3.fromRGB(90,90,90)
		Icon.ZIndex = 54

		local Toggled = false
		local Count = 0

		-- Helper: position ToggleContent directly below ToggleFrame in screen space
		local function PositionContent()
			local absPos = ToggleFrame.AbsolutePosition
			local absSize = ToggleFrame.AbsoluteSize
			ToggleContent.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 2)
			ToggleContent.Size = UDim2.fromOffset(absSize.X, math.min(Count * 22, 150))
		end

		Library:Connection(ToggleFrame.MouseButton1Click, function()
			Toggled = not Toggled
			Library.DropdownOpen = Toggled
			if Toggled then
				NewDropdown.ZIndex = 55
				PositionContent()
				ToggleContent.Visible = true
				TweenService:Create(Icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = 180}):Play()
				TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200,200,200)}):Play()
			else
				TweenService:Create(Icon, TweenInfo.new(0.2), {Rotation = 0}):Play()
				TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(90,90,90)}):Play()
				ToggleContent.Visible = false
				task.wait(0.22)
				NewDropdown.ZIndex = 54
			end
		end)

		Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
			if ToggleContent.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if not Library:IsMouseOverFrame(ToggleContent) and not Library:IsMouseOverFrame(ToggleFrame) and not Library.OptionListOpen then
					Toggled = false
					Library.DropdownOpen = false
					TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(90,90,90)}):Play()
					TweenService:Create(Icon, TweenInfo.new(0.2), {Rotation = 0}):Play()
					ToggleContent.Visible = false
					task.wait(0.22)
					NewDropdown.ZIndex = 54
				end
			end
		end)

		local Chosen = Dropdown.Max and {} or nil

		local function handleoptionclick(option, button, text, dot)
			button.MouseButton1Click:Connect(function()
				if Dropdown.Max then
					if table.find(Chosen, option) then
						table.remove(Chosen, table.find(Chosen, option))
						local textchosen = {}
						for _, opt in next, Chosen do table.insert(textchosen, opt) end
						DropdownTitle_2.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ")
						TweenService:Create(text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(90,90,90)}):Play()
						TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
						TweenService:Create(text, TweenInfo.new(0.2), {Position = UDim2.new(0,4,0,0)}):Play()
						Library.Flags[Dropdown.Flag] = Chosen
						Dropdown.Callback(Chosen)
					else
						if #Chosen == Dropdown.Max then
							Dropdown.OptionInsts[Chosen[1]].text.Visible = false
							table.remove(Chosen, 1)
						end
						table.insert(Chosen, option)
						local textchosen = {}
						for _, opt in next, Chosen do table.insert(textchosen, opt) end
						DropdownTitle_2.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ")
						TweenService:Create(text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
						TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
						TweenService:Create(text, TweenInfo.new(0.2), {Position = UDim2.new(0,20,0,0)}):Play()
						Library.Flags[Dropdown.Flag] = Chosen
						Dropdown.Callback(Chosen)
					end
				else
					for opt, tbl in next, Dropdown.OptionInsts do
						if opt ~= option then
							TweenService:Create(tbl.text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(90,90,90)}):Play()
							TweenService:Create(tbl.text, TweenInfo.new(0.2), {Position = UDim2.new(0,4,0,0)}):Play()
							TweenService:Create(tbl.dot, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
						end
					end
					Chosen = option
					DropdownTitle_2.Text = option
					TweenService:Create(text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
					TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
					TweenService:Create(text, TweenInfo.new(0.2), {Position = UDim2.new(0,20,0,0)}):Play()
					Library.Flags[Dropdown.Flag] = option
					Dropdown.Callback(option)
				end
			end)
		end

		local function createoptions(tbl)
			for _, option in next, tbl do
				Dropdown.OptionInsts[option] = {}
				local TextButton = Instance.new('TextButton', ToggleContent)
				local DropdownTitle3 = Instance.new('TextLabel', TextButton)
				local AccentDot = Instance.new('Frame', TextButton)
				Instance.new('UICorner', AccentDot).CornerRadius = UDim.new(1,0)

				TextButton.Size = UDim2.new(1,0,0,22)
				TextButton.BackgroundTransparency = 1
				TextButton.BorderSizePixel = 0
				TextButton.Text = ""
				TextButton.AutoButtonColor = false
				TextButton.ZIndex = 101
				Dropdown.OptionInsts[option].button = TextButton

				TextButton.MouseEnter:Connect(function()
					TweenService:Create(TextButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.92}):Play()
					TextButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
				end)
				TextButton.MouseLeave:Connect(function()
					TweenService:Create(TextButton, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
				end)

				DropdownTitle3.Position = UDim2.new(0,20,0,0)
				DropdownTitle3.Size = UDim2.new(1,-10,1,0)
				DropdownTitle3.BackgroundTransparency = 1
				DropdownTitle3.Text = option
				DropdownTitle3.TextColor3 = Color3.fromRGB(90,90,90)
				DropdownTitle3.Font = Enum.Font.Gotham
				DropdownTitle3.TextSize = Library.FontSize
				DropdownTitle3.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTitle3.ZIndex = 101
				Dropdown.OptionInsts[option].text = DropdownTitle3

				AccentDot.Position = UDim2.new(0,8,0,8)
				AccentDot.Size = UDim2.new(0,6,0,6)
				AccentDot.BackgroundColor3 = Library.Accent
				AccentDot.BackgroundTransparency = 1
				AccentDot.BorderSizePixel = 0
				AccentDot.ZIndex = 101
				table.insert(Library.ThemeObjects, AccentDot)
				Dropdown.OptionInsts[option].dot = AccentDot
				Count += 1

				handleoptionclick(option, TextButton, DropdownTitle3, AccentDot)
			end
		end
		createoptions(Dropdown.Options)

		local set
		set = function(option)
			if Dropdown.Max then
				table.clear(Chosen)
				option = type(option) == "table" and option or {}
				for opt, tbl in next, Dropdown.OptionInsts do
					if not table.find(option, opt) then
						TweenService:Create(tbl.text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(90,90,90)}):Play()
						TweenService:Create(tbl.text, TweenInfo.new(0.2), {Position = UDim2.new(0,4,0,0)}):Play()
						TweenService:Create(tbl.dot, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
					end
				end
				for i, opt in next, option do
					if table.find(Dropdown.Options, opt) and #Chosen < Dropdown.Max then
						table.insert(Chosen, opt)
						TweenService:Create(Dropdown.OptionInsts[opt].text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
						TweenService:Create(Dropdown.OptionInsts[opt].dot, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Dropdown.OptionInsts[opt].text, TweenInfo.new(0.2), {Position = UDim2.new(0,20,0,0)}):Play()
					end
				end
				local textchosen = {}
				for _, opt in next, Chosen do table.insert(textchosen, opt) end
				DropdownTitle_2.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ")
				Library.Flags[Dropdown.Flag] = Chosen
				Dropdown.Callback(Chosen)
			end
		end

		function Dropdown:Set(option)
			if Dropdown.Max then
				set(option)
			else
				for opt, tbl in next, Dropdown.OptionInsts do
					if opt ~= option then
						TweenService:Create(tbl.text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(90,90,90)}):Play()
						TweenService:Create(tbl.text, TweenInfo.new(0.2), {Position = UDim2.new(0,4,0,0)}):Play()
						TweenService:Create(tbl.dot, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
					end
				end
				if table.find(Dropdown.Options, option) then
					Chosen = option
					DropdownTitle_2.Text = option
					TweenService:Create(Dropdown.OptionInsts[option].text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
					TweenService:Create(Dropdown.OptionInsts[option].dot, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Dropdown.OptionInsts[option].text, TweenInfo.new(0.2), {Position = UDim2.new(0,20,0,0)}):Play()
					Library.Flags[Dropdown.Flag] = Chosen
					Dropdown.Callback(Chosen)
				else
					Chosen = nil
					DropdownTitle_2.Text = ""
					Library.Flags[Dropdown.Flag] = Chosen
					Dropdown.Callback(Chosen)
				end
			end
		end

		function Dropdown:Refresh(tbl)
			Count = 0
			for _, opt in next, Dropdown.OptionInsts do
				coroutine.wrap(function() opt.button:Destroy() end)()
			end
			table.clear(Dropdown.OptionInsts)
			Dropdown.Options = tbl
			createoptions(tbl)
			Chosen = nil
			Library.Flags[Dropdown.Flag] = Chosen
			Dropdown.Callback(Chosen)
		end

		if Dropdown.Max then
			Flags[Dropdown.Flag] = set
		else
			Flags[Dropdown.Flag] = Dropdown
		end
		Dropdown:Set(Dropdown.State)
		return Dropdown
	end

	-- // Colorpicker
	function Sections:Colorpicker(Properties)
		local Properties = Properties or {}
		local Colorpicker = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
			Name = (Properties.Name or "Colorpicker"),
			State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Color3.fromRGB(255, 0, 0)),
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
			Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			Colorpickers = 0,
		}

		local NewColor = Instance.new("TextButton")
		NewColor.Text = ""
		NewColor.AutoButtonColor = false
		NewColor.BackgroundTransparency = 1
		NewColor.BorderSizePixel = 0
		NewColor.Size = UDim2.new(1, 0, 0, 17)
		NewColor.ZIndex = 54
		NewColor.Parent = Colorpicker.Section.Elements.SectionContent

		local ToggleTitle = Instance.new("TextLabel")
		ToggleTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		ToggleTitle.Text = Colorpicker.Name
		ToggleTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
		ToggleTitle.TextSize = 13
		ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
		ToggleTitle.BackgroundTransparency = 1
		ToggleTitle.BorderSizePixel = 0
		ToggleTitle.Size = UDim2.new(1, -10, 0, 17)
		ToggleTitle.Parent = NewColor

		Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
		local colorpickertypes = Library:NewPicker(
			Colorpicker.Name,
			Colorpicker.State,
			NewColor,
			Colorpicker.Colorpickers,
			Colorpicker.Flag,
			Colorpicker.Callback
		)

		function Colorpicker:Set(color)
			colorpickertypes:Set(color, false, true)
		end

		function Colorpicker:Colorpicker(Properties)
			local Properties = Properties or {}
			local NewColorpicker = {
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Color3.fromRGB(255, 0, 0)),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			}
			Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
			local Newcolorpickertypes = Library:NewPicker(
				"",
				NewColorpicker.State,
				NewColor,
				Colorpicker.Colorpickers,
				NewColorpicker.Flag,
				NewColorpicker.Callback
			)
			function NewColorpicker:Set(color)
				Newcolorpickertypes:Set(color)
			end
			return NewColorpicker
		end
		return Colorpicker
	end

	-- // Keybind
	function Sections:Keybind(Properties)
		local Properties = Properties or {}
		local Keybind = {
			Section = self,
			Name = Properties.name or Properties.Name or "Keybind",
			State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or Enum.KeyCode.E),
			Mode = (Properties.mode or Properties.Mode or "Toggle"),
			UseKey = (Properties.UseKey or false),
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
			Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			Binding = nil,
		}
		local Key
		local State = false

		local NewKey = Instance.new("TextButton")
		NewKey.Text = ""
		NewKey.AutoButtonColor = false
		NewKey.BackgroundTransparency = 1
		NewKey.BorderSizePixel = 0
		NewKey.Size = UDim2.new(1, 0, 0, 17)
		NewKey.ZIndex = 54
		NewKey.Parent = Keybind.Section.Elements.SectionContent

		local ToggleTitle = Instance.new("TextLabel")
		ToggleTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		ToggleTitle.Text = Keybind.Name
		ToggleTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
		ToggleTitle.TextSize = 13
		ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
		ToggleTitle.BackgroundTransparency = 1
		ToggleTitle.BorderSizePixel = 0
		ToggleTitle.Size = UDim2.new(1, -10, 0, 17)
		ToggleTitle.Parent = NewKey

		local KeyText = Instance.new("TextLabel")
		KeyText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		KeyText.Text = "None"
		KeyText.TextColor3 = Color3.fromRGB(100, 100, 100)
		KeyText.TextSize = 12
		KeyText.TextXAlignment = Enum.TextXAlignment.Right
		KeyText.BackgroundTransparency = 1
		KeyText.BorderSizePixel = 0
		KeyText.Position = UDim2.new(1, -180, 0, 0)
		KeyText.Size = UDim2.new(1, -10, 0, 17)
		KeyText.Parent = NewKey

		local c
		local function set(newkey)
			if string.find(tostring(newkey), "Enum") then
				if c then
					c:Disconnect()
					if Keybind.Flag then Library.Flags[Keybind.Flag] = false end
					Keybind.Callback(false)
				end
				if tostring(newkey):find("Enum.KeyCode.") then
					newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
				elseif tostring(newkey):find("Enum.UserInputType.") then
					newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
				end
				if newkey == Enum.KeyCode.Backspace or newkey == Enum.KeyCode.None then
					Key = nil
					if Keybind.UseKey then
						if Keybind.Flag then Library.Flags[Keybind.Flag] = Key end
						Keybind.Callback(Key)
					end
					KeyText.Text = "None"
				elseif newkey ~= nil then
					Key = newkey
					if Keybind.UseKey then
						if Keybind.Flag then Library.Flags[Keybind.Flag] = Key end
						Keybind.Callback(Key)
					end
					KeyText.Text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
				end
				Library.Flags[Keybind.Flag .. "_KEY"] = newkey
			elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
				if not Keybind.UseKey then
					Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
					Keybind.Mode = newkey
					if Keybind.Mode == "Always" then
						State = true
						if Keybind.Flag then Library.Flags[Keybind.Flag] = State end
						Keybind.Callback(true)
					end
				end
			else
				State = newkey
				if Keybind.Flag then Library.Flags[Keybind.Flag] = newkey end
				Keybind.Callback(newkey)
			end
		end

		set(Keybind.State)
		set(Keybind.Mode)

		NewKey.MouseButton1Click:Connect(function()
			if not Keybind.Binding then
				KeyText.Text = "..."
				TweenService:Create(KeyText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				Keybind.Binding = Library:Connection(
					game:GetService("UserInputService").InputBegan,
					function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.Touch then return end
						local inputType = input.UserInputType
						local keyCode = input.KeyCode
						if inputType == Enum.UserInputType.Keyboard then
							set(keyCode)
						elseif inputType.Name:find("Gamepad") then
							set(keyCode) -- Fixed to use KeyCode for gamepads instead of UserInputType
						else
							set(inputType)
						end
						Library:Disconnect(Keybind.Binding)
						task.wait()
						Keybind.Binding = nil
						TweenService:Create(KeyText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
					end
				)
			end
		end)

		Library:Connection(game:GetService("UserInputService").InputBegan, function(inp, gpe)
			if gpe then return end
			-- Fix: Check if input matches specific key/type exactly
			if Key ~= nil and (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
				if Keybind.Mode == "Hold" then
					if Keybind.Flag then Library.Flags[Keybind.Flag] = true end
					c = Library:Connection(game:GetService("RunService").RenderStepped, function()
						if Keybind.Callback then Keybind.Callback(true) end
					end)
				elseif Keybind.Mode == "Toggle" then
					State = not State
					if Keybind.Flag then Library.Flags[Keybind.Flag] = State end
					Keybind.Callback(State)
				end
			end
		end)

		Library:Connection(game:GetService("UserInputService").InputEnded, function(inp, gpe)
			if gpe then return end
			if Keybind.Mode == "Hold" and not Keybind.UseKey then
				if Key ~= "" or Key ~= nil then
					if Key ~= nil and (inp.KeyCode == Key or inp.UserInputType == Key) then
						if c then
							c:Disconnect()
							if Keybind.Flag then Library.Flags[Keybind.Flag] = false end
							if Keybind.Callback then Keybind.Callback(false) end
						end
					end
				end
			end
		end)

		Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
		Library.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
		Flags[Keybind.Flag] = set
		Flags[Keybind.Flag .. "_KEY"] = set
		Flags[Keybind.Flag .. "_KEY STATE"] = set

		function Keybind:Set(key) set(key) end
		return Keybind
	end

	-- // Textbox
	function Sections:Textbox(Properties)
		local Properties = Properties or {}
		local TextboxName = Properties.Name or Properties.name or nil
		local Textbox = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
			Placeholder = (Properties.placeholder or Properties.Placeholder or Properties.holder or Properties.Holder or "Enter text..."),
			State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or ""),
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
			Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
		}

		local extraHeight = TextboxName and 20 or 0
		local totalHeight = 24 + extraHeight

		local NewBox = Instance.new("Frame")
		NewBox.BackgroundTransparency = 1
		NewBox.BorderSizePixel = 0
		NewBox.Size = UDim2.new(1, 0, 0, totalHeight)
		NewBox.ZIndex = 54
		NewBox.Parent = Textbox.Section.Elements.SectionContent

		if TextboxName then
			local TitleLabel = Instance.new("TextLabel")
			TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			TitleLabel.Text = TextboxName
			TitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
			TitleLabel.TextSize = 12
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0, 2, 0, 0)
			TitleLabel.Size = UDim2.new(1, -8, 0, 20)
			TitleLabel.ZIndex = 55
			TitleLabel.Parent = NewBox
		end

		local ToggleFrame = Instance.new("Frame")
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.Position = UDim2.new(0, 0, 0, extraHeight)
		ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
		ToggleFrame.ZIndex = 55
		Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
		local TBStroke = Instance.new("UIStroke", ToggleFrame)
		TBStroke.Color = Color3.fromRGB(38,38,38)

		local DropdownTitle = Instance.new("TextBox")
		DropdownTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		DropdownTitle.Text = Textbox.State
		DropdownTitle.PlaceholderText = Textbox.Placeholder
		DropdownTitle.PlaceholderColor3 = Color3.fromRGB(80,80,80)
		DropdownTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
		DropdownTitle.TextSize = 12
		DropdownTitle.ClearTextOnFocus = false
		DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
		DropdownTitle.BackgroundTransparency = 1
		DropdownTitle.BorderSizePixel = 0
		DropdownTitle.Position = UDim2.fromOffset(8, 0)
		DropdownTitle.Size = UDim2.new(1, -16, 1, 0)
		DropdownTitle.ZIndex = 53
		DropdownTitle.Parent = ToggleFrame
		DropdownTitle.TextTruncate = Enum.TextTruncate.SplitWord

		DropdownTitle.Focused:Connect(function()
			TweenService:Create(TBStroke, TweenInfo.new(0.2), {Color = Library.Accent}):Play()
		end)
		DropdownTitle.FocusLost:Connect(function(enterPressed)
			TweenService:Create(TBStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(38,38,38)}):Play()
			if enterPressed then
				Textbox.Callback(DropdownTitle.Text)
				Library.Flags[Textbox.Flag] = DropdownTitle.Text
			end
		end)

		ToggleFrame.Parent = NewBox

		local function set(str)
			str = tostring(str or "")
			DropdownTitle.Text = str
			Library.Flags[Textbox.Flag] = str
			Textbox.Callback(str)
		end

		Flags[Textbox.Flag] = set
		Library.Flags[Textbox.Flag] = Textbox.State
		return Textbox
	end

	-- // Button
	function Sections:Button(Properties)
		local Properties = Properties or {}
		local Button = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
			Name = Properties.Name or "Button",
			Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
		}

		local NewButton = Instance.new("TextButton")
		NewButton.Text = ""
		NewButton.AutoButtonColor = false
		NewButton.BackgroundTransparency = 1
		NewButton.BorderSizePixel = 0
		NewButton.Size = UDim2.new(1, 0, 0, 26)
		NewButton.ZIndex = 54
		NewButton.Parent = Button.Section.Elements.SectionContent

		local ToggleFrame = Instance.new("Frame")
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.Size = UDim2.new(1, 0, 1, 0)
		ToggleFrame.ZIndex = 55
		Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
		local BtnStroke = Instance.new("UIStroke", ToggleFrame)
		BtnStroke.Color = Color3.fromRGB(38,38,38)

		local BtnShimmer = Instance.new("Frame", ToggleFrame)
		BtnShimmer.Size = UDim2.new(1,0,1,0)
		BtnShimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
		BtnShimmer.BackgroundTransparency = 1
		BtnShimmer.BorderSizePixel = 0
		BtnShimmer.ZIndex = 56
		Instance.new("UICorner", BtnShimmer).CornerRadius = UDim.new(0,6)

		local DropdownTitle = Instance.new("TextLabel")
		DropdownTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		DropdownTitle.Text = Button.Name
		DropdownTitle.TextColor3 = Color3.fromRGB(190, 190, 190)
		DropdownTitle.TextSize = 12
		DropdownTitle.BackgroundTransparency = 1
		DropdownTitle.BorderSizePixel = 0
		DropdownTitle.Size = UDim2.fromScale(1, 1)
		DropdownTitle.ZIndex = 57
		DropdownTitle.Parent = ToggleFrame

		ToggleFrame.Parent = NewButton

		Library:Connection(NewButton.MouseButton1Down, function()
			Button.Callback()
			TweenService:Create(BtnShimmer, TweenInfo.new(0.08), {BackgroundTransparency = 0.88}):Play()
			TweenService:Create(DropdownTitle, TweenInfo.new(0.08), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			task.spawn(function()
				task.wait(0.12)
				TweenService:Create(BtnShimmer, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				TweenService:Create(DropdownTitle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(190,190,190)}):Play()
			end)
		end)

		NewButton.MouseEnter:Connect(function()
			TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(60,60,60)}):Play()
		end)
		NewButton.MouseLeave:Connect(function()
			TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(38,38,38)}):Play()
		end)
	end

	-- // Watermark
	function Library:Watermark(Properties)
		local Watermark = {
			Name = (Properties.Name or Properties.name or "serial.xyz");
			AnimateText = nil;
		}
		local Outline = Instance.new("Frame")
		Outline.AnchorPoint = Vector2.new(1, 0)
		Outline.AutomaticSize = Enum.AutomaticSize.X
		Outline.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Outline.Position = UDim2.new(1, -10, 0, 10)
		Outline.Size = UDim2.fromOffset(100, 22)
		Outline.Visible = false
		Outline.ZIndex = 50
		Outline.Parent = Library.ScreenGUI
		Instance.new("UICorner", Outline).CornerRadius = UDim.new(0, 6)
		local UIStroke = Instance.new("UIStroke", Outline)
		UIStroke.Color = Color3.fromRGB(40,40,40)

		local Inline = Instance.new("Frame")
		Inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
		Inline.BorderSizePixel = 0
		Inline.Position = UDim2.fromOffset(1, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)
		Inline.ZIndex = 51
		Instance.new("UICorner", Inline).CornerRadius = UDim.new(0, 6)

		local Title = Instance.new("TextLabel")
		Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		Title.RichText = true
		Title.Text = Watermark.Name
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 13
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.AutomaticSize = Enum.AutomaticSize.X
		Title.BackgroundTransparency = 1
		Title.BorderSizePixel = 0
		Title.Position = UDim2.fromOffset(5, 0)
		Title.Size = UDim2.fromScale(0, 1)
		Title.Parent = Inline
		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingRight = UDim.new(0, 6)
		UIPadding.Parent = Inline
		Inline.Parent = Outline

		task.spawn(function()
			while task.wait() do
				for i = 1, #"serial.xyz" do
					Watermark.AnimateText = string.sub("serial.xyz", 1, i) .. "";
					Title.Text = Watermark.AnimateText .. " " .. Watermark.Name;
					task.wait(0.4);
				end;
				for i = #"serial.xyz" - 1, 1, -1 do
					Watermark.AnimateText = string.sub("serial.xyz", 1, i) .. "";
					Title.Text = Watermark.AnimateText .. " " .. Watermark.Name;
					task.wait(0.4);
				end;
			end;
		end)

		function Watermark:UpdateText(NewText)
			Watermark.Name = NewText
			Title.Text = Watermark.AnimateText .. " " .. Watermark.Name;
		end;
		function Watermark:SetVisible(State)
			Outline.Visible = State;
		end;

		return Watermark
	end

	-- // Main Window Element
	function Library:Window(Properties)
		if not Properties then Properties = {} end
		local Window = {
			Name = Properties.Name or "serial.xyz",
			Pages = {},
			Elements = {},
		}

		local ScreenGUI = Instance.new("ScreenGui", (cloneref(game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")))
		ScreenGUI.Name = "serial.xyz"
		ScreenGUI.ResetOnSpawn = false
		Library.ScreenGUI = ScreenGUI

		local Holder = Instance.new("Frame", ScreenGUI)
		Holder.Name = "Main"
		Holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		Holder.BorderSizePixel = 0
		Holder.Position = UDim2.new(0.5, -250, 0.5, -175)
		Holder.Size = UDim2.new(0, 500, 0, 350)
		Holder.ZIndex = 50
		Library.Holder = Holder
		Library.OldSize = Holder.Size
		Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 8)
		MakeDraggable(Holder)

		local Sidebar = Instance.new("Frame", Holder)
		Sidebar.Name = "Sidebar"
		Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
		Sidebar.BorderSizePixel = 0
		Sidebar.Size = UDim2.new(0, 150, 1, 0)
		Sidebar.ZIndex = 51
		Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

		local SidebarFill = Instance.new("Frame", Sidebar)
		SidebarFill.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
		SidebarFill.BorderSizePixel = 0
		SidebarFill.Position = UDim2.new(1, -10, 0, 0)
		SidebarFill.Size = UDim2.new(0, 10, 1, 0)
		SidebarFill.ZIndex = 51

		local SidebarLine = Instance.new("Frame", Sidebar)
		SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		SidebarLine.BorderSizePixel = 0
		SidebarLine.Position = UDim2.new(1, 0, 0, 0)
		SidebarLine.Size = UDim2.new(0, 1, 1, 0)
		SidebarLine.ZIndex = 52

		local Logo = Instance.new("TextLabel", Sidebar)
		Logo.Position = UDim2.new(0, 15, 0, 15)
		Logo.Size = UDim2.new(1, -30, 0, 30)
		Logo.BackgroundTransparency = 1
		Logo.Text = Window.Name
		Logo.Font = Enum.Font.GothamBold
		Logo.TextSize = 16
		Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
		Logo.TextXAlignment = Enum.TextXAlignment.Left
		Logo.ZIndex = 52

		local Tabs = Instance.new("ScrollingFrame", Sidebar)
		Tabs.Name = "Tabs"
		Tabs.Position = UDim2.new(0, 10, 0, 55)
		Tabs.Size = UDim2.new(1, -20, 1, -65)
		Tabs.BackgroundTransparency = 1
		Tabs.BorderSizePixel = 0
		Tabs.ScrollBarThickness = 0
		Tabs.ZIndex = 52
		Instance.new("UIListLayout", Tabs).Padding = UDim.new(0, 4)

		local PageHolder = Instance.new("Frame", Holder)
		PageHolder.Name = "PageHolder"
		PageHolder.Position = UDim2.new(0, 160, 0, 10)
		PageHolder.Size = UDim2.new(1, -170, 1, -20)
		PageHolder.BackgroundTransparency = 1
		PageHolder.ZIndex = 52

		function Window:UpdateTabs()
			local contentSize = Tabs.UIListLayout.AbsoluteContentSize
			Tabs.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
		end

		Window.Elements = {
			Tabs = Tabs,
			PageHolder = PageHolder,
		}

		Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
			if Input.KeyCode == Library.UIKey then
				Library:SetOpen(not Library.Open)
			end
		end)

		return setmetatable(Window, Library)
	end

	function Library:Notification(Text, Duration)
		local Duration = Duration or 3
		local Notification = Instance.new("Frame")
		Notification.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1, 20, 1, -40 - (#Library.Notifs * 45))
		Notification.Size = UDim2.new(0, 200, 0, 40)
		Notification.ZIndex = 100
		Notification.Parent = Library.ScreenGUI
		Instance.new("UICorner", Notification).CornerRadius = UDim.new(0, 6)
		local Stroke = Instance.new("UIStroke", Notification)
		Stroke.Color = Color3.fromRGB(40, 40, 40)

		local Title = Instance.new("TextLabel", Notification)
		Title.Position = UDim2.new(0, 10, 0, 0)
		Title.Size = UDim2.new(1, -20, 1, 0)
		Title.BackgroundTransparency = 1
		Title.Text = Text
		Title.Font = Enum.Font.Gotham
		Title.TextSize = 12
		Title.TextColor3 = Color3.fromRGB(200, 200, 200)
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.ZIndex = 101

		local Timer = Instance.new("Frame", Notification)
		Timer.Position = UDim2.new(0, 0, 1, -2)
		Timer.Size = UDim2.new(1, 0, 0, 2)
		Timer.BackgroundColor3 = Library.Accent
		Timer.BorderSizePixel = 0
		Timer.ZIndex = 102
		Instance.new("UICorner", Timer).CornerRadius = UDim.new(0, 6)

		table.insert(Library.Notifs, Notification)
		TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -210, 1, -40 - ((#Library.Notifs - 1) * 45))}):Play()
		TweenService:Create(Timer, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

		task.delay(Duration, function()
			TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, Notification.Position.Y.Scale, Notification.Position.Y.Offset)}):Play()
			task.wait(0.4)
			Notification:Destroy()
			for i, v in ipairs(Library.Notifs) do
				if v == Notification then
					table.remove(Library.Notifs, i)
					break
				end
			end
			for i, v in ipairs(Library.Notifs) do
				TweenService:Create(v, TweenInfo.new(0.25), {Position = UDim2.new(1, -210, 1, -40 - ((i - 1) * 45))}):Play()
			end
		end)
	end
end

Library.__index = Library
Pages.__index = Pages
Sections.__index = Sections

return Library
