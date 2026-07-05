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
			[Enum.UserInputType.MouseButton3] = "MB3"
		};
		Connections = {};
		FontSize = 12;
		VisValues = {};
		UIKey = Enum.KeyCode.Insert;
		Notifs = {};

		-- NEW: Search index for all registered UI elements
		SearchIndex = {};

		-- NEW: Addon registry
		Addons = {};
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

	-- // =============================================
	-- // ADDON SYSTEM
	-- // =============================================
	--[[
		ADDON API:
		Register an addon (do this in your addon script):
			Library:RegisterAddon("MyAddon", function(window)
				local page = window:Page({ Name = "My Addon", Icon = "rbxassetid://..." })
				local section = page:Section({ Name = "Settings", Side = "left" })
				section:Toggle({ Name = "My Feature", Callback = function(v) end })
			end)

		Load an addon by name (call after creating your window):
			window:LoadAddon("MyAddon")

		Or load all registered addons at once:
			window:LoadAllAddons()

		Addon authors can also use Library.Flags to read/write any flag,
		and Library.SearchIndex is updated automatically for any elements they add.
	]]
	function Library:RegisterAddon(name, callback)
		Library.Addons[name] = callback
	end

	-- LoadAddon / LoadAllAddons are added to the window object inside Library:New()

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

		-- Works the same as the per-window Window:SetBackground, but callable
		-- directly on the Library/module table — matching how ChangeAccent,
		-- Notification, GetConfig, and LoadConfig are already called as
		-- "library:MethodName(...)" in most scripts.
		function Library:SetBackground(imageSource, transparency)
			if not imageSource or imageSource == "" then
				task.spawn(function()
					if Library._DisableBackground then Library._DisableBackground() end
				end)
			else
				task.spawn(function()
					if Library._ApplyBackground then Library._ApplyBackground(imageSource, transparency) end
				end)
			end
		end

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
			ColorpickerFrame.Name = "ColorpickerFrame"
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
			Colorpicker.Name = "ColorpickerPopup"
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
			HueSlider.Name = "HueSlider"
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
			UIS.InputChanged:Connect(function(i)
				if draggingSV or draggingHue then
					if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
						setMousePos(i.Position)
						update()
					end
				end
			end)

			local function ClosePicker()
				Colorpicker.Visible = false
				parent.ZIndex = 1
				Library.Cooldown = false
			end

			ColorpickerFrame.MouseButton1Down:Connect(function()
				if Colorpicker.Visible then
					ClosePicker()
					return
				end
				Colorpicker.Position = UDim2.fromOffset(
					ColorpickerFrame.AbsolutePosition.X - 100,
					ColorpickerFrame.AbsolutePosition.Y
				)
				Colorpicker.Visible = true
				parent.ZIndex = 100
				Library.Cooldown = true
			end)

			UIS.InputBegan:Connect(function(i)
				if not Colorpicker.Visible then return end
				if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
					local pos = i.Position
					local framePos = Colorpicker.AbsolutePosition
					local frameSize = Colorpicker.AbsoluteSize
					if pos.X < framePos.X or pos.X > framePos.X + frameSize.X
					or pos.Y < framePos.Y or pos.Y > framePos.Y + frameSize.Y then
						ClosePicker()
					end
				end
			end)

			return {}, Colorpicker
		end
	end

	function Library:updateNotifsPositions(position)
		for i, v in pairs(Library.Notifs) do
			local Position = Vector2.new(20, 20)
			game:GetService("TweenService"):Create(v.Container, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,Position.X,0,Position.Y + (i * 25))}):Play()
		end
	end

	function Library:Notification(message, duration)
		local notification = {Container = nil, Objects = {}}
		local Position = Vector2.new(20, 20)

		local NewInd = Instance.new("Frame")
		NewInd.Name = "NewInd"
		NewInd.AutomaticSize = Enum.AutomaticSize.X
		NewInd.Position = UDim2.new(0,20,0,20)
		NewInd.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		NewInd.BackgroundTransparency = 1
		NewInd.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NewInd.Size = UDim2.fromOffset(0, 20)
		NewInd.Parent = Library.ScreenGUI
		notification.Container = NewInd

		local Outline = Instance.new("Frame")
		Outline.Name = "Outline"
		Outline.AnchorPoint = Vector2.new(0, 0)
		Outline.AutomaticSize = Enum.AutomaticSize.X
		Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Outline.BorderSizePixel = 1
		Outline.Position = UDim2.new(0,0,0,0)
		Outline.Size = UDim2.fromOffset(0, 20)
		Outline.Visible = true
		Outline.ZIndex = 50
		Outline.Parent = NewInd
		Outline.BackgroundTransparency = 1
		Instance.new("UICorner", Outline).CornerRadius = UDim.new(0, 6)
		local UIStroke = Instance.new("UIStroke", Outline)
		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(60, 60, 60)

		local Inline = Instance.new("Frame")
		Inline.Name = "Inline"
		Inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
		Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Inline.BorderSizePixel = 0
		Inline.Position = UDim2.fromOffset(1, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)
		Inline.ZIndex = 51
		Inline.BackgroundTransparency = 1
		Instance.new("UICorner", Inline).CornerRadius = UDim.new(0, 6)

		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		Title.RichText = true
		Title.Text = message
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 13
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.AutomaticSize = Enum.AutomaticSize.X
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.fromOffset(5, 0)
		Title.Size = UDim2.fromScale(0, 1)
		Title.Parent = Inline
		Title.TextTransparency = 1
		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingRight = UDim.new(0, 6)
		UIPadding.Parent = Inline
		Inline.Parent = Outline

		function notification:remove()
			table.remove(Library.Notifs, table.find(Library.Notifs, notification))
			Library:updateNotifsPositions(Position)
			task.wait(0.5)
			NewInd:Destroy()
		end

		task.spawn(function()
			Outline.AnchorPoint = Vector2.new(1,0)
			for i,v in next, NewInd:GetDescendants() do
				if v:IsA("Frame") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				elseif v:IsA("UIStroke") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0}):Play()
				end
			end
			game:GetService("TweenService"):Create(Outline, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(0,0)}):Play()
			game:GetService("TweenService"):Create(Title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			task.wait(duration)
			for i,v in next, NewInd:GetDescendants() do
				if v:IsA("Frame") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
				elseif v:IsA("UIStroke") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 1}):Play()
				end
			end
			game:GetService("TweenService"):Create(Title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		end)

		task.delay(duration + 0.1, function()
			notification:remove()
		end)

		table.insert(Library.Notifs, notification)
		Library:updateNotifsPositions(Position)
		NewInd.Position = UDim2.new(0,Position.X,0,Position.Y + (table.find(Library.Notifs, notification) * 25))
		return notification
	end

	-- // Main
	do
		local Pages = Library.Pages;
		local Sections = Library.Sections;

		-- Stamps a dark outline stroke on any TextLabel/TextButton
		-- so text stays legible over any background image.
		local function AddTextStroke(label, thickness, transparency)
			local s = Instance.new("UIStroke", label)
			s.Color = Color3.fromRGB(0, 0, 0)
			s.Thickness = thickness or 1.2
			s.Transparency = transparency or 0.1
			s.LineJoinMode = Enum.LineJoinMode.Round
			return s
		end

		-- =============================================
		-- SECTION-ONLY BACKGROUND IMAGE
		-- Applies ONLY to Section boxes (the frames created by
		-- Pages:Section). Sidebar, tabs, toggles, sliders, lists,
		-- dropdowns, textboxes, buttons, player card, search bar —
		-- none of that is touched, ever.
		--
		-- Usage:
		--   window:SetBackground("rbxassetid://12345678", 0.3)
		--   window:SetBackground("https://i.imgur.com/xyz.jpg")
		--   window:SetBackground()  -- clears it
		-- =============================================

		-- Resolves rbxassetid://, rbxthumb://, or any http(s) URL
		-- (downloads + getcustomasset, since executors can't load
		-- remote URLs directly into ImageLabel.Image).
		local function ResolveImageSource(src)
			if type(src) ~= "string" or src == "" then return "" end

			if src:sub(1, 13) == "rbxassetid://"
			or src:sub(1, 11) == "rbxthumb://"
			or src:sub(1, 12) == "rbxgameasset"
			or src:sub(1, 7)  == "rbxhttp" then
				return src
			end

			if src:sub(1, 4) == "http" then
				if not writefile or not getcustomasset then
					if not writefile then
						warn("[UI Background] writefile is not available in this executor. Cannot load external image URLs.")
					end
					if not getcustomasset then
						warn("[UI Background] getcustomasset is not available in this executor. Cannot load external image URLs. Use rbxassetid:// instead.")
					end
					return ""
				end

				local ext = src:match("%.(%a+)%??") or "png"
				if ext ~= "png" and ext ~= "jpg" and ext ~= "jpeg" and ext ~= "gif" and ext ~= "webp" then
					ext = "png"
				end

				-- IMPORTANT: give every distinct URL its own filename.
				-- getcustomasset caches by file PATH, not file content — if
				-- every image reused the same "UIBackground_cache.<ext>"
				-- path, switching images would overwrite the file but the
				-- executor would hand back the SAME cached asset it gave
				-- last time, so the picture never visually changed.
				local hash = 5381
				for i = 1, #src do
					hash = (hash * 33 + string.byte(src, i)) % 2147483647
				end
				local localPath = "UIBackground_" .. tostring(hash) .. "." .. ext

				-- Delete any stale file at that path first, just in case
				-- the executor's cache also keys off of write timestamps.
				pcall(function() if isfile and isfile(localPath) then delfile(localPath) end end)

				local dlOk, dlResult = pcall(function()
					return game:HttpGet(src)
				end)
				if not dlOk or not dlResult or dlResult == "" then
					warn("[UI Background] Failed to download image from: " .. src .. "\nReason: " .. tostring(dlResult))
					return ""
				end

				local writeOk, writeErr = pcall(writefile, localPath, dlResult)
				if not writeOk then
					warn("[UI Background] Failed to write image to disk.\nReason: " .. tostring(writeErr))
					return ""
				end

				local assetOk, assetResult = pcall(getcustomasset, localPath)
				if not assetOk or not assetResult or assetResult == "" then
					warn("[UI Background] getcustomasset failed for local file: " .. localPath .. "\nReason: " .. tostring(assetResult))
					return ""
				end

				return assetResult
			end

			return src
		end

		-- Background image machinery (EnableBackground/DisableBackground/
		-- ApplyBackground) lives inside Library:New(), right after Inline
		-- is created, since it needs a closure over that window's Outline.
		function Library:New(Properties)
			if not Properties then
				Properties = {}
			end

			local Window = {
				Size = Properties.Size or UDim2.new(0,560,0,460),
				Pages = {},
				PageAxis = 0,
				Dragging = { false, UDim2.new(0, 0, 0, 0) },
				Resized = nil,
				Elements = {},
			}

			local ScreenGui = Instance.new('ScreenGui', game:GetService("RunService"):IsStudio() and game.Players.LocalPlayer.PlayerGui or game.CoreGui)
			ScreenGui.DisplayOrder = 100
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Library.ScreenGUI = ScreenGui

			local Outline = Instance.new('Frame', ScreenGui)
			Outline.Name = "Outline"
			Outline.Position = UDim2.new(0.5, -60, 0.5, 0)
			Outline.Size = UDim2.new(0,0,0,40)
			Outline.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			Outline.BorderColor3 = Color3.new(0,0,0)
			Outline.AnchorPoint = Vector2.new(0.5,0.5)
			Outline.ZIndex = 50
			Outline.ClipsDescendants = false
			Instance.new('UICorner', Outline).CornerRadius = UDim.new(0, 0)
			local OutlineStroke = Instance.new('UIStroke', Outline)
			OutlineStroke.Color = Color3.fromRGB(45, 45, 45)
			OutlineStroke.Thickness = 1

			Library.Holder = Outline
			Library.OldSize = Window.Size

			local Inline = Instance.new('Frame', Outline)
			Inline.Name = "Inline"
			Inline.Position = UDim2.new(0,1,0,1)
			Inline.Size = UDim2.new(1,-2,1,-2)
			Inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
			Inline.BorderSizePixel = 0
			Inline.ZIndex = 51
			Instance.new('UICorner', Inline).CornerRadius = UDim.new(0, 0)

			-- =============================================
			-- BACKGROUND IMAGE — one single image behind the whole
			-- window (parented to Outline), revealed only where it's
			-- allowed to show through: Sections and the tab sidebar.
			-- Toggles, sliders, lists, dropdowns, textboxes, buttons,
			-- the player card, and the search bar all stay fully opaque.
			-- =============================================
			local _bgSnapshot = {}
			local _bgActive = false

			-- Frame names that must ALWAYS stay opaque — this is what
			-- keeps the image off of every interactive element.
			local BG_KEEP_OPAQUE = {
				ToggleFrame    = true,  -- toggle pill / slider bar / dropdown box / button bg / textbox input (shared name)
				ToggleAccent   = true,  -- toggle fill color
				Circle         = true,  -- toggle knob
				Fill           = true,  -- slider filled portion
				FillHold       = true,  -- slider fill container
				PlayerCard     = true,  -- bottom-of-sidebar player card
				AvatarFrame    = true,  -- avatar circle inside card
				ExecutorBadge  = true,  -- executor name pill
				SearchBarFrame = true,  -- search input bar
				SearchResults  = true,  -- search results dropdown
				HoverFill      = true,  -- tab button hover tint
				ActiveFill     = true,  -- tab button active tint
				AccentBar      = true,  -- tab left accent stripe
				BtnShimmer     = true,  -- button click flash
				ToggleContent  = true,  -- dropdown/list open option panel
				ColorpickerFrame = true, -- colorpicker swatch
				ColorpickerPopup = true, -- colorpicker's open hue/sat panel
				HueSlider      = true,  -- colorpicker's hue-bar knob
				Outline        = true,  -- top-level window border (has the image as a child)
				-- Inline is NOT kept opaque — it covers nearly the whole
				-- window, so keeping it solid hides the image behind
				-- everything. Letting it go transparent is what lets
				-- Sections/Sidebar show the image at all.
			}

			local function EnableBackground(BgImage)
				_bgActive = true
				for _, obj in ipairs(Outline:GetDescendants()) do
					if obj == BgImage then continue end
					if (obj:IsA("Frame") or obj:IsA("ScrollingFrame")) and not BG_KEEP_OPAQUE[obj.Name] then
						_bgSnapshot[obj] = obj.BackgroundTransparency
						obj.BackgroundTransparency = 1
						for _, gc in ipairs(obj:GetChildren()) do
							if gc:IsA("UIGradient") then gc.Enabled = false end
						end
					end
				end

				if Library._bgDescConn then Library._bgDescConn:Disconnect() end
				Library._bgDescConn = Outline.DescendantAdded:Connect(function(obj)
					if not _bgActive then return end
					task.defer(function()
						if not _bgActive then return end
						if (obj:IsA("Frame") or obj:IsA("ScrollingFrame")) and not BG_KEEP_OPAQUE[obj.Name] then
							_bgSnapshot[obj] = obj.BackgroundTransparency
							obj.BackgroundTransparency = 1
							for _, gc in ipairs(obj:GetChildren()) do
								if gc:IsA("UIGradient") then gc.Enabled = false end
							end
						end
					end)
				end)
			end

			local function DisableBackground()
				_bgActive = false
				if Library._bgDescConn then Library._bgDescConn:Disconnect(); Library._bgDescConn = nil end
				if Library.BackgroundImageLabel and Library.BackgroundImageLabel.Parent then
					Library.BackgroundImageLabel.Image = ""
					Library.BackgroundImageLabel.Visible = false
				end
				for obj, origTrans in pairs(_bgSnapshot) do
					if obj and obj.Parent then
						obj.BackgroundTransparency = origTrans
						for _, gc in ipairs(obj:GetChildren()) do
							if gc:IsA("UIGradient") then gc.Enabled = true end
						end
					end
				end
				_bgSnapshot = {}
			end

			local function ApplyBackground(imgSrc, transparency)
				local resolved = ResolveImageSource(imgSrc or "")
				if resolved == "" then
					warn("[UI Background] Could not resolve image source: " .. tostring(imgSrc))
					return
				end
				-- Same dimming behavior as before: nudge a bit more
				-- transparent than requested so text/UI stays legible.
				local requested = transparency or 0.35
				local trans = math.clamp(requested + 0.15, 0, 0.92)

				if Library.BackgroundImageLabel and Library.BackgroundImageLabel.Parent then
					Library.BackgroundImageLabel.Image = resolved
					Library.BackgroundImageLabel.ImageTransparency = trans
					Library.BackgroundImageLabel.Visible = true
					if not _bgActive then
						EnableBackground(Library.BackgroundImageLabel)
					end
				else
					local BgImage = Instance.new("ImageLabel", Outline)
					BgImage.Name = "BackgroundImage"
					BgImage.Image = resolved
					BgImage.ScaleType = Enum.ScaleType.Crop
					BgImage.Size = UDim2.new(1, 0, 1, 0)
					BgImage.Position = UDim2.new(0, 0, 0, 0)
					BgImage.BackgroundTransparency = 1
					BgImage.ImageTransparency = trans
					BgImage.ZIndex = 1
					BgImage.BorderSizePixel = 0
					Library.BackgroundImageLabel = BgImage
					EnableBackground(BgImage)
				end
			end

			Library._ApplyBackground  = ApplyBackground
			Library._DisableBackground = DisableBackground

			-- === FIX: CARD_HEIGHT was previously undefined here, causing
			-- "attempt to perform arithmetic (add) on nil and number"
			-- when CARD_TOTAL was computed below. Declared explicitly now.
			local CARD_HEIGHT = 58
			local CARD_MARGIN = 8
			local CARD_TOTAL = CARD_HEIGHT + CARD_MARGIN * 2

			local Sidebar = Instance.new('Frame', Inline)
			Sidebar.Name = "Sidebar"
			Sidebar.Position = UDim2.new(0,0,0,0)
			Sidebar.Size = UDim2.new(0,155,1,0)
			Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
			Sidebar.BorderSizePixel = 0
			Sidebar.ZIndex = 52
			Instance.new('UICorner', Sidebar).CornerRadius = UDim.new(0, 0)

			local SidebarClip = Instance.new("Frame", Sidebar)
			SidebarClip.Name = "SidebarClip"
			SidebarClip.Position = UDim2.new(1,-2,0,0)
			SidebarClip.Size = UDim2.new(0,2,1,0)
			SidebarClip.BackgroundColor3 = Color3.fromRGB(10,10,10)
			SidebarClip.BorderSizePixel = 0
			SidebarClip.ZIndex = 52

			local SidebarGrad = Instance.new("UIGradient", Sidebar)
			SidebarGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,22)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,10)),
			})
			SidebarGrad.Rotation = 90

			local Logo = Instance.new("ImageLabel", Sidebar)
			Logo.Name = "Logo"
			Logo.Image = Properties.Icon or "http://www.roblox.com/asset/?id=17669613413"
			Logo.ScaleType = Enum.ScaleType.Fit
			Logo.BackgroundTransparency = 1
			Logo.BorderSizePixel = 0
			Logo.AnchorPoint = Vector2.new(0.5, 0)
			Logo.Position = UDim2.new(0.5, 0, 0, 10)
			Logo.Size = UDim2.fromOffset(54, 54)
			Logo.ZIndex = 53

			local LogoDivider = Instance.new("Frame", Sidebar)
			LogoDivider.Name = "LogoDivider"
			LogoDivider.Position = UDim2.new(0, 12, 0, 70)
			LogoDivider.Size = UDim2.new(1, -24, 0, 1)
			LogoDivider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			LogoDivider.BorderSizePixel = 0
			LogoDivider.ZIndex = 53

			-- =============================================
			-- NEW: SEARCH BAR (sits between logo divider and tabs)
			-- =============================================
			local SearchBarFrame = Instance.new("Frame", Sidebar)
			SearchBarFrame.Name = "SearchBarFrame"
			SearchBarFrame.Position = UDim2.new(0, 4, 0, 79)
			SearchBarFrame.Size = UDim2.new(1, -6, 0, 20)
			SearchBarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			SearchBarFrame.BorderSizePixel = 0
			SearchBarFrame.ZIndex = 54
			Instance.new("UICorner", SearchBarFrame).CornerRadius = UDim.new(0, 3)
			local SearchStroke = Instance.new("UIStroke", SearchBarFrame)
			SearchStroke.Color = Color3.fromRGB(38, 38, 38)
			SearchStroke.Thickness = 1

			local SearchIcon = Instance.new("ImageLabel", SearchBarFrame)
			SearchIcon.Size = UDim2.fromOffset(10, 10)
			SearchIcon.Position = UDim2.new(0, 7, 0.5, 0)
			SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
			SearchIcon.BackgroundTransparency = 1
			SearchIcon.Image = "rbxassetid://3926305904"  -- magnifier icon
			SearchIcon.ImageColor3 = Color3.fromRGB(70, 70, 70)
			SearchIcon.ZIndex = 55

			local SearchBox = Instance.new("TextBox", SearchBarFrame)
			SearchBox.Name = "SearchBox"
			SearchBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			SearchBox.PlaceholderText = "Search..."
			SearchBox.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
			SearchBox.Text = ""
			SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
			SearchBox.TextSize = 10
			SearchBox.TextXAlignment = Enum.TextXAlignment.Left
			SearchBox.BackgroundTransparency = 1
			SearchBox.BorderSizePixel = 0
			SearchBox.ClearTextOnFocus = false
			SearchBox.Position = UDim2.new(0, 22, 0, 0)
			SearchBox.Size = UDim2.new(1, -28, 1, 0)
			SearchBox.ZIndex = 55

			-- Search results overlay (parented to ScreenGUI so it floats above everything)
			local SearchResults = Instance.new("Frame", ScreenGui)
			SearchResults.Name = "SearchResults"
			SearchResults.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
			SearchResults.BorderSizePixel = 0
			SearchResults.Size = UDim2.fromOffset(170, 0)
			SearchResults.AutomaticSize = Enum.AutomaticSize.None
			SearchResults.Visible = false
			SearchResults.ZIndex = 200
			Instance.new("UICorner", SearchResults).CornerRadius = UDim.new(0, 8)
			local SRStroke = Instance.new("UIStroke", SearchResults)
			SRStroke.Color = Color3.fromRGB(40, 40, 40)
			SRStroke.Thickness = 1

			local SearchScroll = Instance.new("ScrollingFrame", SearchResults)
			SearchScroll.Name = "SearchScroll"
			SearchScroll.Size = UDim2.new(1, 0, 1, 0)
			SearchScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			SearchScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			SearchScroll.ScrollBarThickness = 2
			SearchScroll.ScrollBarImageColor3 = Library.Accent
			SearchScroll.BackgroundTransparency = 1
			SearchScroll.BorderSizePixel = 0
			SearchScroll.ScrollingDirection = Enum.ScrollingDirection.Y
			SearchScroll.ZIndex = 201
			SearchScroll.TopImage = ""
			SearchScroll.BottomImage = ""

			local SearchLayout = Instance.new("UIListLayout", SearchScroll)
			SearchLayout.SortOrder = Enum.SortOrder.LayoutOrder
			SearchLayout.Padding = UDim.new(0, 2)

			local SearchPad = Instance.new("UIPadding", SearchScroll)
			SearchPad.PaddingTop = UDim.new(0, 5)
			SearchPad.PaddingBottom = UDim.new(0, 5)
			SearchPad.PaddingLeft = UDim.new(0, 5)
			SearchPad.PaddingRight = UDim.new(0, 5)

			-- Helper: position results panel below the search bar
			local function PositionSearchResults()
				local absPos = SearchBarFrame.AbsolutePosition
				local absSize = SearchBarFrame.AbsoluteSize
				SearchResults.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 4)
			end

			-- Helper: clear all result rows
			local function ClearSearchResults()
				for _, child in ipairs(SearchScroll:GetChildren()) do
					if child:IsA("Frame") or child:IsA("TextButton") then
						child:Destroy()
					end
				end
			end

			-- =============================================
			-- NAVIGATE TO ELEMENT: switches to the right page,
			-- then scrolls the section column until the element
			-- frame is visible, then flashes it so the user
			-- immediately sees where to look.
			-- =============================================
			local function NavigateToElement(elementData)
				-- 1. Close the search dropdown
				SearchResults.Visible = false
				SearchBox.Text = ""

				-- 2. Switch to the page that owns this element
				local targetPage = elementData.PageRef
				if targetPage and not targetPage.Open then
					-- Turn off all other pages
					for _, p in pairs(Window.Pages) do
						if p.Open then p:Turn(false) end
					end
					targetPage:Turn(true)
				end

				-- 3. Wait a frame so layout settles
				task.wait(0.05)

				-- 4. Find the element's GuiObject and scroll to it, then flash
				local guiObj = elementData.GuiObject
				if guiObj then
					-- Find which ScrollingFrame column owns it
					local function findScrollParent(obj)
						local cur = obj.Parent
						while cur do
							if cur:IsA("ScrollingFrame") and
								(cur.Name == "Left" or cur.Name == "Right") then
								return cur
							end
							cur = cur.Parent
						end
						return nil
					end
					local col = findScrollParent(guiObj)
					if col then
						-- Scroll so the element sits ~1/4 from the top
						local objRelY = guiObj.AbsolutePosition.Y - col.AbsolutePosition.Y + col.CanvasPosition.Y
						local targetY = math.max(0, objRelY - col.AbsoluteSize.Y * 0.25)
						TweenService:Create(col, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{CanvasPosition = Vector2.new(0, targetY)}):Play()
					end

					-- Flash highlight — a bright accent frame that fades out
					task.wait(0.1)
					local Flash = Instance.new("Frame", guiObj)
					Flash.Size = UDim2.new(1, 4, 1, 4)
					Flash.Position = UDim2.new(0, -2, 0, -2)
					Flash.BackgroundColor3 = Library.Accent
					Flash.BackgroundTransparency = 0.55
					Flash.BorderSizePixel = 0
					Flash.ZIndex = guiObj.ZIndex + 10
					Instance.new("UICorner", Flash).CornerRadius = UDim.new(0, 6)
					-- Pulse: fade in then out
					TweenService:Create(Flash, TweenInfo.new(0.18), {BackgroundTransparency = 0.3}):Play()
					task.delay(0.22, function()
						TweenService:Create(Flash, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
						task.delay(0.52, function() Flash:Destroy() end)
					end)
				end
			end

			-- Helper: create a search result row
			-- elementData = { Type, Name, Ref, PageName, SectionName, PageRef, GuiObject }
			local function CreateSearchRow(elementData)
				-- All rows use the UI accent color — consistent with the rest of the UI theme.
				-- The type label still shows the element kind so users can tell them apart.
				local accent = Library.Accent

				-- Row button (entire row is clickable)
				local Row = Instance.new("TextButton", SearchScroll)
				Row.Size = UDim2.new(1, 0, 0, 38)
				Row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				Row.BackgroundTransparency = 0
				Row.BorderSizePixel = 0
				Row.Text = ""
				Row.AutoButtonColor = false
				Row.ZIndex = 202
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 7)
				local RowStroke = Instance.new("UIStroke", Row)
				RowStroke.Color = Color3.fromRGB(35, 35, 35)
				RowStroke.Thickness = 1
				-- Track in ThemeObjects so accent changes apply live
				table.insert(Library.ThemeObjects, RowStroke)

				-- Left accent bar — UI accent color
				local AccentBar = Instance.new("Frame", Row)
				AccentBar.Size = UDim2.new(0, 3, 0.6, 0)
				AccentBar.Position = UDim2.new(0, 0, 0.2, 0)
				AccentBar.BackgroundColor3 = accent
				AccentBar.BorderSizePixel = 0
				AccentBar.ZIndex = 203
				Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)
				table.insert(Library.ThemeObjects, AccentBar)

				-- Element name
				local NameLabel = Instance.new("TextLabel", Row)
				NameLabel.Position = UDim2.new(0, 12, 0, 4)
				NameLabel.Size = UDim2.new(1, -80, 0, 16)
				NameLabel.BackgroundTransparency = 1
				NameLabel.Text = elementData.Name
				NameLabel.Font = Enum.Font.GothamBold
				NameLabel.TextSize = 11
				NameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
				NameLabel.TextXAlignment = Enum.TextXAlignment.Left
				NameLabel.ZIndex = 203
				NameLabel.TextTruncate = Enum.TextTruncate.AtEnd

				-- Breadcrumb  Page › Section
				local BreadLabel = Instance.new("TextLabel", Row)
				BreadLabel.Position = UDim2.new(0, 12, 0, 21)
				BreadLabel.Size = UDim2.new(1, -80, 0, 13)
				BreadLabel.BackgroundTransparency = 1
				BreadLabel.Text = (elementData.PageName or "?") .. " › " .. (elementData.SectionName or "?")
				BreadLabel.Font = Enum.Font.Gotham
				BreadLabel.TextSize = 9
				BreadLabel.TextColor3 = Color3.fromRGB(75, 75, 75)
				BreadLabel.TextXAlignment = Enum.TextXAlignment.Left
				BreadLabel.ZIndex = 203
				BreadLabel.TextTruncate = Enum.TextTruncate.AtEnd

				-- Type pill badge (top-right) — accent color
				local TypeBadge = Instance.new("Frame", Row)
				TypeBadge.Size = UDim2.fromOffset(0, 14)
				TypeBadge.AutomaticSize = Enum.AutomaticSize.X
				TypeBadge.Position = UDim2.new(1, -6, 0, 6)
				TypeBadge.AnchorPoint = Vector2.new(1, 0)
				TypeBadge.BackgroundColor3 = accent
				TypeBadge.BackgroundTransparency = 0.6
				TypeBadge.BorderSizePixel = 0
				TypeBadge.ZIndex = 203
				Instance.new("UICorner", TypeBadge).CornerRadius = UDim.new(0, 4)
				table.insert(Library.ThemeObjects, TypeBadge)
				local BP = Instance.new("UIPadding", TypeBadge)
				BP.PaddingLeft = UDim.new(0, 4)
				BP.PaddingRight = UDim.new(0, 4)
				local TypeLabel = Instance.new("TextLabel", TypeBadge)
				TypeLabel.Size = UDim2.new(0, 0, 1, 0)
				TypeLabel.AutomaticSize = Enum.AutomaticSize.X
				TypeLabel.BackgroundTransparency = 1
				TypeLabel.Text = elementData.Type:upper()
				TypeLabel.Font = Enum.Font.GothamBold
				TypeLabel.TextSize = 7
				TypeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TypeLabel.ZIndex = 204

				-- Navigate icon (arrow) bottom-right — dim until hover
				local NavIcon = Instance.new("ImageLabel", Row)
				NavIcon.Size = UDim2.fromOffset(10, 10)
				NavIcon.Position = UDim2.new(1, -10, 1, -13)
				NavIcon.AnchorPoint = Vector2.new(1, 0)
				NavIcon.BackgroundTransparency = 1
				NavIcon.Image = "rbxassetid://6034818372"
				NavIcon.ImageColor3 = Color3.fromRGB(55, 55, 55)
				NavIcon.ZIndex = 203

				-- Hover: stroke + nav icon go accent, name brightens
				Row.MouseEnter:Connect(function()
					local a = Library.Accent
					TweenService:Create(Row,       TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
					TweenService:Create(RowStroke, TweenInfo.new(0.12), {Color = a}):Play()
					TweenService:Create(NavIcon,   TweenInfo.new(0.12), {ImageColor3 = a}):Play()
					TweenService:Create(NameLabel, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end)
				Row.MouseLeave:Connect(function()
					TweenService:Create(Row,       TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
					TweenService:Create(RowStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(35, 35, 35)}):Play()
					TweenService:Create(NavIcon,   TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(55, 55, 55)}):Play()
					TweenService:Create(NameLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
				end)

				-- Click: flash row with accent then navigate
				Row.MouseButton1Click:Connect(function()
					TweenService:Create(Row, TweenInfo.new(0.08), {BackgroundColor3 = Library.Accent}):Play()
					task.delay(0.1, function()
						NavigateToElement(elementData)
					end)
				end)

				return Row
			end

			-- The main search logic
			local function RunSearch(query)
				ClearSearchResults()
				query = query:lower():gsub("^%s+", ""):gsub("%s+$", "")

				if query == "" then
					SearchResults.Visible = false
					return
				end

				local results = {}
				for _, entry in ipairs(Library.SearchIndex) do
					if entry.Name and entry.Name:lower():find(query, 1, true) then
						table.insert(results, entry)
					end
				end

				if #results == 0 then
					-- Show "no results" row
					SearchResults.Size = UDim2.fromOffset(170, 44)
					PositionSearchResults()
					SearchResults.Visible = true
					local NoRow = Instance.new("Frame", SearchScroll)
					NoRow.Size = UDim2.new(1, 0, 0, 34)
					NoRow.BackgroundTransparency = 1
					NoRow.ZIndex = 202
					local NoLabel = Instance.new("TextLabel", NoRow)
					NoLabel.Size = UDim2.new(1, 0, 1, 0)
					NoLabel.BackgroundTransparency = 1
					NoLabel.Text = "No results for \"" .. query .. "\""
					NoLabel.Font = Enum.Font.Gotham
					NoLabel.TextSize = 10
					NoLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
					NoLabel.ZIndex = 203
					return
				end

				local rowH = 38
				local gap = 3
				local pad = 10
				local maxRows = math.min(#results, 5)
				SearchResults.Size = UDim2.fromOffset(170, maxRows * (rowH + gap) + pad)

				PositionSearchResults()
				SearchResults.Visible = true

				for _, entry in ipairs(results) do
					CreateSearchRow(entry)
				end
			end

			SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
				RunSearch(SearchBox.Text)
			end)

			SearchBox.Focused:Connect(function()
				TweenService:Create(SearchStroke, TweenInfo.new(0.2), {Color = Library.Accent}):Play()
				TweenService:Create(SearchIcon, TweenInfo.new(0.2), {ImageColor3 = Library.Accent}):Play()
				if SearchBox.Text ~= "" then
					PositionSearchResults()
					SearchResults.Visible = true
				end
			end)

			SearchBox.FocusLost:Connect(function()
				TweenService:Create(SearchStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(38, 38, 38)}):Play()
				TweenService:Create(SearchIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(70, 70, 70)}):Play()
				-- Small delay so clicks on results register before hiding
				task.delay(0.15, function()
					SearchResults.Visible = false
				end)
			end)

			-- Close search results on click outside
			Library:Connection(game:GetService("UserInputService").InputBegan, function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
					if SearchResults.Visible then
						if not Library:IsMouseOverFrame(SearchResults) and not Library:IsMouseOverFrame(SearchBarFrame) then
							SearchResults.Visible = false
						end
					end
				end
			end)

			-- =============================================
			-- TABS (now SCROLLABLE ScrollingFrame)
			-- =============================================
			-- Shifted down 30px to accommodate search bar
			local Tabs = Instance.new('ScrollingFrame', Sidebar)
			Tabs.Name = "Tabs"
			Tabs.Position = UDim2.new(0, 4, 0, 108)
			Tabs.Size = UDim2.new(1, -6, 1, -(108 + CARD_TOTAL))
			Tabs.BackgroundTransparency = 1
			Tabs.BorderSizePixel = 0
			Tabs.ZIndex = 53
			Tabs.ClipsDescendants = true
			-- Scrolling settings
			Tabs.ScrollingDirection = Enum.ScrollingDirection.Y
			Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
			Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
			Tabs.ScrollBarThickness = 2
			Tabs.ScrollBarImageColor3 = Library.Accent
			Tabs.ScrollBarImageTransparency = 0.6
			Tabs.TopImage = ""
			Tabs.BottomImage = ""
			Tabs.VerticalScrollBarInset = Enum.ScrollBarInset.Always
			table.insert(Library.ThemeObjects, Tabs)

			local TabLayout = Instance.new('UIListLayout', Tabs)
			TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
			TabLayout.Padding = UDim.new(0, 3)

			local CardDivider = Instance.new("Frame", Sidebar)
			CardDivider.Name = "CardDivider"
			CardDivider.Position = UDim2.new(0, 12, 1, -(CARD_TOTAL + 1))
			CardDivider.Size = UDim2.new(1, -24, 0, 1)
			CardDivider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			CardDivider.BorderSizePixel = 0
			CardDivider.ZIndex = 53

			local PlayerCard = Instance.new("Frame", Sidebar)
			PlayerCard.Name = "PlayerCard"
			PlayerCard.Position = UDim2.new(0, 4, 1, -(CARD_HEIGHT + CARD_MARGIN))
			PlayerCard.Size = UDim2.new(1, -22, 0, CARD_HEIGHT)
			PlayerCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			PlayerCard.BorderSizePixel = 0
			PlayerCard.ZIndex = 53
			Instance.new("UICorner", PlayerCard).CornerRadius = UDim.new(0, 8)
			local PlayerCardStroke = Instance.new("UIStroke", PlayerCard)
			PlayerCardStroke.Color = Color3.fromRGB(35, 35, 35)
			PlayerCardStroke.Thickness = 1

			local AvatarFrame = Instance.new("Frame", PlayerCard)
			AvatarFrame.Name = "AvatarFrame"
			AvatarFrame.Position = UDim2.new(0, 8, 0.5, 0)
			AvatarFrame.AnchorPoint = Vector2.new(0, 0.5)
			AvatarFrame.Size = UDim2.fromOffset(42, 42)
			AvatarFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			AvatarFrame.BorderSizePixel = 0
			AvatarFrame.ZIndex = 54
			Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(1, 0)
			local AvatarStroke = Instance.new("UIStroke", AvatarFrame)
			AvatarStroke.Color = Color3.fromRGB(50, 50, 50)

			local AvatarImg = Instance.new("ImageLabel", AvatarFrame)
			AvatarImg.Name = "Avatar"
			AvatarImg.Size = UDim2.new(1, -4, 1, -4)
			AvatarImg.Position = UDim2.fromOffset(2, 2)
			AvatarImg.BackgroundTransparency = 1
			AvatarImg.BorderSizePixel = 0
			AvatarImg.ZIndex = 55
			AvatarImg.Image = ""
			Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

			task.spawn(function()
				local success, result = pcall(function()
					return Players:GetUserThumbnailAsync(
						LocalPlayer.UserId,
						Enum.ThumbnailType.HeadShot,
						Enum.ThumbnailSize.Size60x60
					)
				end)
				if success then
					AvatarImg.Image = result
				end
			end)

			local textLeft = 58

			local DisplayNameLabel = Instance.new("TextLabel", PlayerCard)
			DisplayNameLabel.Name = "DisplayName"
			DisplayNameLabel.Position = UDim2.new(0, textLeft, 0, 10)
			DisplayNameLabel.Size = UDim2.new(1, -(textLeft + 8), 0, 15)
			DisplayNameLabel.BackgroundTransparency = 1
			DisplayNameLabel.Text = LocalPlayer.DisplayName
			DisplayNameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
			DisplayNameLabel.Font = Enum.Font.GothamBold
			DisplayNameLabel.TextSize = 12
			DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
			DisplayNameLabel.ZIndex = 54
			DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd

			local UsernameLabel = Instance.new("TextLabel", PlayerCard)
			UsernameLabel.Name = "Username"
			UsernameLabel.Position = UDim2.new(0, textLeft, 0, 27)
			UsernameLabel.Size = UDim2.new(1, -(textLeft + 8), 0, 13)
			UsernameLabel.BackgroundTransparency = 1
			UsernameLabel.Text = "@" .. LocalPlayer.Name
			UsernameLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
			UsernameLabel.Font = Enum.Font.Gotham
			UsernameLabel.TextSize = 11
			UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
			UsernameLabel.ZIndex = 54
			UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd

			local ExecutorBadge = Instance.new("Frame", PlayerCard)
			ExecutorBadge.Name = "ExecutorBadge"
			ExecutorBadge.Position = UDim2.new(0, textLeft, 0, 44)
			ExecutorBadge.Size = UDim2.new(0, 0, 0, 15)
			ExecutorBadge.AutomaticSize = Enum.AutomaticSize.X
			ExecutorBadge.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
			ExecutorBadge.BorderSizePixel = 0
			ExecutorBadge.ZIndex = 54
			Instance.new("UICorner", ExecutorBadge).CornerRadius = UDim.new(0, 4)
			table.insert(Library.ThemeObjects, ExecutorBadge)

			local BadgePad = Instance.new("UIPadding", ExecutorBadge)
			BadgePad.PaddingLeft = UDim.new(0, 5)
			BadgePad.PaddingRight = UDim.new(0, 5)

			local ExecutorLabel = Instance.new("TextLabel", ExecutorBadge)
			ExecutorLabel.Name = "ExecutorLabel"
			ExecutorLabel.Size = UDim2.new(0, 0, 1, 0)
			ExecutorLabel.AutomaticSize = Enum.AutomaticSize.X
			ExecutorLabel.BackgroundTransparency = 1
			ExecutorLabel.Text = Library:GetExecutor()
			ExecutorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ExecutorLabel.Font = Enum.Font.GothamBold
			ExecutorLabel.TextSize = 10
			ExecutorLabel.ZIndex = 55

			local Holder = Instance.new('Frame', Inline)
			Holder.Name = "Holder"
			Holder.Position = UDim2.new(0,155,0,0)
			Holder.Size = UDim2.new(1,-155,1,0)
			Holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
			Holder.BorderSizePixel = 0
			Holder.ZIndex = 52
			Instance.new('UICorner', Holder).CornerRadius = UDim.new(0, 0)

			local HolderGrad = Instance.new("UIGradient", Holder)
			HolderGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(16,16,16)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,10)),
			})
			HolderGrad.Rotation = 90

			local SepLine = Instance.new("Frame", Inline)
			SepLine.Size = UDim2.new(0,1,1,0)
			SepLine.Position = UDim2.new(0,155,0,0)
			SepLine.BackgroundColor3 = Color3.fromRGB(0,0,0)
			SepLine.BorderSizePixel = 0
			SepLine.ZIndex = 53

			local FadeThing = Instance.new("Frame", Holder)
			FadeThing.Name = "FadeThing"
			FadeThing.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
			FadeThing.BorderSizePixel = 0
			FadeThing.Position = UDim2.fromOffset(8, 8)
			FadeThing.Size = UDim2.new(1, -16, 1, -16)
			FadeThing.ZIndex = 55
			FadeThing.Visible = false

			Window.Elements = {
				TabHolder = Tabs,
				Holder = Holder,
				FadeThing = FadeThing
			}

			MakeDraggable(Outline)

			function Window:UpdateTabs()
				for Index, Page in pairs(Window.Pages) do
					Page:Turn(Page.Open)
				end
			end

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Inp)
				if Inp.KeyCode == Library.UIKey then
					Library:SetOpen(not Library.Open)
				end
			end)

			game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Window.Size.X.Offset, 0, Window.Size.Y.Offset)}):Play()

			Library.Holder = Outline

			-- =============================================
			-- ADDON SYSTEM: LoadAddon / LoadAllAddons
			-- =============================================
			function Window:LoadAddon(name)
				local fn = Library.Addons[name]
				if fn then
					local ok, err = pcall(fn, self)
					if not ok then
						warn("[UI Addon '" .. name .. "'] Error: " .. tostring(err))
					end
				else
					warn("[UI Addon] No addon registered under name: '" .. tostring(name) .. "'")
				end
			end

			function Window:LoadAllAddons()
				for name, fn in pairs(Library.Addons) do
					local ok, err = pcall(fn, self)
					if not ok then
						warn("[UI Addon '" .. name .. "'] Error: " .. tostring(err))
					end
				end
			end

			-- =============================================
			-- BACKGROUND IMAGE: runtime setter
			-- Accepts rbxassetid://, rbxthumb://, or any
			-- https:// URL (requires getcustomasset).
			-- Examples:
			--   window:SetBackground("rbxassetid://12345678")
			--   window:SetBackground("https://i.imgur.com/abc.png", 0.3)
			--   window:SetBackground("https://files.catbox.moe/xyz.jpg", 0.2)
			-- =============================================
			function Window:SetBackground(imageSource, transparency)
				if not imageSource or imageSource == "" then
					task.spawn(function()
						Library._DisableBackground()
					end)
				else
					task.spawn(function()
						Library._ApplyBackground(imageSource, transparency)
					end)
				end
			end

			return setmetatable(Window, Library)
		end

		function Library:Seperator(Properties)
			if not Properties then Properties = {} end
			local Page = {
				Name = Properties.Name or "Page",
				Window = self,
				Elements = {},
			}
			local TextSep = Instance.new('Frame', Page.Window.Elements.TabHolder)
			local TextLabel = Instance.new('TextLabel', TextSep)
			TextSep.Name = "TextSep"
			TextSep.Size = UDim2.new(1,0,0,18)
			TextSep.BackgroundTransparency = 1
			TextSep.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0,4,0,0)
			TextLabel.Size = UDim2.new(1,-8,1,0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.BorderSizePixel = 0
			TextLabel.Text = string.upper(Page.Name)
			TextLabel.TextColor3 = Color3.fromRGB(70,70,70)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 9
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		end

		function Library:Page(Properties)
			Properties = Properties or {}

			local Page = {
				Name = Properties.Name or "Page",
				Icon = Properties.Icon or "http://www.roblox.com/asset/?id=6022668955",
				Window = self,
				Open = false,
				Sections = {},
				Elements = {},
			}

			local TabButton = Instance.new("TextButton", Page.Window.Elements.TabHolder)
			TabButton.Size = UDim2.new(1, 0, 0, 32)
			TabButton.BackgroundColor3 = Color3.fromRGB(255,40,40)
			TabButton.BackgroundTransparency = 1
			TabButton.Text = ""
			TabButton.AutoButtonColor = false
			TabButton.BorderSizePixel = 0
			Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 7)

			local HoverFill = Instance.new("Frame", TabButton)
			HoverFill.Name = "HoverFill"
			HoverFill.Size = UDim2.new(1,0,1,0)
			HoverFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
			HoverFill.BackgroundTransparency = 1
			HoverFill.BorderSizePixel = 0
			HoverFill.ZIndex = TabButton.ZIndex
			Instance.new("UICorner", HoverFill).CornerRadius = UDim.new(0,7)

			local ActiveFill = Instance.new("Frame", TabButton)
			ActiveFill.Name = "ActiveFill"
			ActiveFill.Size = UDim2.new(1,0,1,0)
			ActiveFill.BackgroundColor3 = Library.Accent
			ActiveFill.BackgroundTransparency = 1
			ActiveFill.BorderSizePixel = 0
			ActiveFill.ZIndex = TabButton.ZIndex
			Instance.new("UICorner", ActiveFill).CornerRadius = UDim.new(0,7)
			table.insert(Library.ThemeObjects, ActiveFill)

			local AccentBar = Instance.new("Frame", TabButton)
			AccentBar.Name = "AccentBar"
			AccentBar.Position = UDim2.new(0,0,0.15,0)
			AccentBar.Size = UDim2.new(0,3,0.7,0)
			AccentBar.BackgroundColor3 = Library.Accent
			AccentBar.BackgroundTransparency = 1
			AccentBar.BorderSizePixel = 0
			AccentBar.ZIndex = TabButton.ZIndex + 1
			Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1,0)
			table.insert(Library.ThemeObjects, AccentBar)

			local Icon = Instance.new("ImageLabel", TabButton)
			Icon.Position = UDim2.new(0, 10, 0.5, 0)
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.Size = UDim2.new(0, 14, 0, 14)
			Icon.BackgroundTransparency = 1
			Icon.Image = Page.Icon
			Icon.ImageColor3 = Color3.fromRGB(90, 90, 90)
			Icon.ZIndex = TabButton.ZIndex + 2

			local Title = Instance.new("TextLabel", TabButton)
			Title.Position = UDim2.new(0, 30, 0, 0)
			Title.Size = UDim2.new(1, -34, 1, 0)
			Title.BackgroundTransparency = 1
			Title.Text = Page.Name
			Title.Font = Enum.Font.GothamBold
			Title.TextSize = 12
			Title.TextColor3 = Color3.fromRGB(90, 90, 90)
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.ZIndex = TabButton.ZIndex + 2

			TabButton.MouseEnter:Connect(function()
				if not Page.Open then
					TweenService:Create(HoverFill, TweenInfo.new(0.15), {BackgroundTransparency = 0.93}):Play()
				end
			end)
			TabButton.MouseLeave:Connect(function()
				TweenService:Create(HoverFill, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
			end)

			local NewPage = Instance.new("Frame", Page.Window.Elements.Holder)
			NewPage.Position = UDim2.new(0, 0, 0, 8)
			NewPage.Size = UDim2.new(1, -11, 1, -16)
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
			Left.Size = UDim2.new(0.5, -4, 1, 0)
			Left.Position = UDim2.new(0, 0, 0, 0)

			Right.Name = "Right"
			Right.Size = UDim2.new(0.5, -4, 1, 0)
			Right.Position = UDim2.new(0.5, 4, 0, 0)

			local function SetupColumn(column)
				local layout = Instance.new("UIListLayout", column)
				layout.SortOrder = Enum.SortOrder.LayoutOrder
				layout.Padding = UDim.new(0, 8)

				-- Give Section boxes a couple pixels of breathing room on
				-- BOTH sides — a ScrollingFrame always clips exactly at its
				-- own edge, and Section frames previously filled 100% of
				-- the column's width with zero margin, so their border
				-- stroke had nowhere to render without getting clipped.
				local pad = Instance.new("UIPadding", column)
				pad.PaddingLeft = UDim.new(0, 2)
				pad.PaddingRight = UDim.new(0, 2)

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
			Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
			Frame.BackgroundTransparency = 0.3
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
			FrameStroke.Color = Color3.fromRGB(70, 70, 70)
			FrameStroke.Thickness = 1
			FrameStroke.Transparency = 0.4
			-- No gradient — semi-transparent fill lets background image show through

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
			HeaderTitle.TextColor3 = Section.Color or Color3.fromRGB(200, 200, 200)
			HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
			HeaderTitle.ZIndex = 57
			local HeaderStroke = Instance.new("UIStroke", HeaderTitle)
			HeaderStroke.Color = Color3.fromRGB(0, 0, 0)
			HeaderStroke.Thickness = 1.5
			HeaderStroke.Transparency = 0.2

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
			Content.Position = UDim2.new(0, 8, 0, 36)
			Content.BackgroundTransparency = 1
			Content.BorderSizePixel = 0
			Content.ZIndex = 56

			if isAuto then
				Content.Size = UDim2.new(1, -16, 0, 0)
				Content.AutomaticSize = Enum.AutomaticSize.Y
			else
				Content.Size = UDim2.new(1, -16, 1, -44)
				Content.AutomaticSize = Enum.AutomaticSize.None
			end

			local Layout = Instance.new("UIListLayout", Content)
			Layout.Padding = UDim.new(0, 8)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder

			local BottomPad = Instance.new("UIPadding", Content)
			BottomPad.PaddingBottom = UDim.new(0, 8)
			BottomPad.PaddingRight = UDim.new(0, 2)

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
			ToggleFrame.Name = "ToggleFrame"
			Instance.new('UICorner', ToggleFrame).CornerRadius = UDim.new(1, 0)
			local ToggleAccent = Instance.new('Frame', ToggleFrame)
			ToggleAccent.Name = "ToggleAccent"
			Instance.new('UICorner', ToggleAccent).CornerRadius = UDim.new(1, 0)
			local Circle = Instance.new('Frame', ToggleFrame)
			Circle.Name = "Circle"
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
			ToggleTitle.TextColor3 = Color3.fromRGB(210,210,210)
			ToggleTitle.Font = Enum.Font.GothamBold
			ToggleTitle.TextSize = Library.FontSize
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			AddTextStroke(ToggleTitle)

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

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "Toggle",
				Name = Toggle.Name,
				Ref = Toggle,
				PageName = (Toggle.Section and Toggle.Section.Page and Toggle.Section.Page.Name) or "?",
				SectionName = (Toggle.Section and Toggle.Section.Name) or "?",
				PageRef = (Toggle.Section and Toggle.Section.Page) or nil,
				GuiObject = NewToggle,
			})

			return Toggle
		end

		-- // Nest
		function Sections:Nest(Properties)
			if not Properties then Properties = {} end
			local Section = {
				Name = Properties.Name or "Section",
				RealSection = self,
				Size = Properties.size or Properties.Size or 200,
				Elements = {},
				Content = {},
			}
			local ScrollHolder = Instance.new("Frame", Section.RealSection.Elements.SectionContent)
			Instance.new('UICorner', ScrollHolder).CornerRadius = UDim.new(0, 6)
			local UIStroke = Instance.new('UIStroke', ScrollHolder)
			local NewScroll = Instance.new('ScrollingFrame', ScrollHolder)
			local ScrollContent = Instance.new('Frame', NewScroll)
			local UIListLayout = Instance.new('UIListLayout', ScrollContent)

			ScrollHolder.Size = UDim2.new(1,0,0,Section.Size)
			ScrollHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			ScrollHolder.BorderSizePixel = 0
			ScrollHolder.ClipsDescendants = true
			UIStroke.Color = Color3.fromRGB(35, 35, 35)

			NewScroll.Size = UDim2.new(1,0,1,0)
			NewScroll.BackgroundTransparency = 1
			NewScroll.BorderSizePixel = 0
			NewScroll.CanvasSize = UDim2.new(0,0,0,0)
			NewScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			NewScroll.ScrollBarThickness = 2
			NewScroll.TopImage = ""
			NewScroll.BottomImage = ""
			NewScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
			NewScroll.ScrollBarImageColor3 = Library.Accent
			NewScroll.ClipsDescendants = true
			table.insert(Library.ThemeObjects, NewScroll)

			ScrollContent.Position = UDim2.new(0,10,0,5)
			ScrollContent.Size = UDim2.new(1,-20,0,0)
			ScrollContent.BackgroundTransparency = 1
			ScrollContent.BorderSizePixel = 0
			ScrollContent.AutomaticSize = Enum.AutomaticSize.Y
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,4)

			Section.Elements = { SectionContent = ScrollContent }
			return setmetatable(Section, Library.Sections)
		end

		-- // DependencyBox
		function Sections:DependencyBox(Properties)
			Properties = Properties or {}
			local DepBox = {
				Section = self,
				Dependencies = {},
				Elements = {},
			}

			local Container = Instance.new("Frame")
			Container.Name = "DependencyBox"
			Container.BackgroundTransparency = 1
			Container.BorderSizePixel = 0
			Container.Size = UDim2.new(1, 0, 0, 0)
			Container.AutomaticSize = Enum.AutomaticSize.Y
			Container.ClipsDescendants = false
			Container.ZIndex = 56
			Container.Visible = false
			Container.Parent = self.Elements.SectionContent

			local Layout = Instance.new("UIListLayout", Container)
			Layout.Padding = UDim.new(0, 8)
			Layout.SortOrder = Enum.SortOrder.LayoutOrder

			DepBox.Elements.SectionContent = Container

			local function UpdateVisibility()
				for _, dep in ipairs(DepBox.Dependencies) do
					local toggle = dep[1]
					local expected = dep[2]
					local current = (type(toggle) == "table" and toggle.Toggled ~= nil)
						and toggle.Toggled
						or Library.Flags[toggle.Flag]
					if current ~= expected then
						Container.Visible = false
						return
					end
				end
				Container.Visible = true
			end

			function DepBox:SetupDependencies(deps)
				DepBox.Dependencies = deps
				for _, dep in ipairs(deps) do
					local toggle = dep[1]
					local origCallback = toggle.Callback
					toggle.Callback = function(state)
						origCallback(state)
						UpdateVisibility()
					end
				end
				UpdateVisibility()
			end

			return setmetatable(DepBox, Library.Sections)
		end

		-- // Slider
		function Sections:Slider(Properties)
			if not Properties then Properties = {} end
			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "Slider",
				Min = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or 10),
				Max = (Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 100),
				Sub = (Properties.suffix or Properties.Suffix or Properties.ending or Properties.Ending or Properties.prefix or Properties.Prefix or Properties.measurement or Properties.Measurement or ""),
				Decimals = (Properties.decimals or Properties.Decimals or 1),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
			}
			local TextValue = ("[value]" .. Slider.Sub)

			local NewSlider = Instance.new('TextButton', Slider.Section.Elements.SectionContent)
			local SliderTitle = Instance.new('TextLabel', NewSlider)
			local ToggleFrame = Instance.new('Frame', NewSlider)
			ToggleFrame.Name = "ToggleFrame"
			Instance.new('UICorner', ToggleFrame).CornerRadius = UDim.new(1, 0)
			local FillHold = Instance.new('Frame', ToggleFrame)
			FillHold.Name = "FillHold"
			Instance.new('UICorner', FillHold).CornerRadius = UDim.new(1, 0)
			local Fill = Instance.new('TextButton', FillHold)
			Fill.Name = "Fill"
			Instance.new('UICorner', Fill).CornerRadius = UDim.new(1, 0)
			local Circle = Instance.new('Frame', Fill)
			Circle.Name = "Circle"
			Instance.new('UICorner', Circle).CornerRadius = UDim.new(1, 0)
			local SliderValue = Instance.new('TextLabel', NewSlider)

			NewSlider.Size = UDim2.new(1,0,0,32)
			NewSlider.BackgroundTransparency = 1
			NewSlider.BorderSizePixel = 0
			NewSlider.Text = ""
			NewSlider.AutoButtonColor = false
			NewSlider.ZIndex = 53

			SliderTitle.Size = UDim2.new(1,-10,0,17)
			SliderTitle.BackgroundTransparency = 1
			SliderTitle.BorderSizePixel = 0
			SliderTitle.Text = Slider.Name
			SliderTitle.TextColor3 = Color3.fromRGB(210,210,210)
			SliderTitle.Font = Enum.Font.GothamBold
			SliderTitle.TextSize = Library.FontSize
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
			AddTextStroke(SliderTitle)

			ToggleFrame.Position = UDim2.new(0,0,1,-9)
			ToggleFrame.Size = UDim2.new(1,0,0,9)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.ZIndex = 53
			local TFStroke = Instance.new("UIStroke", ToggleFrame)
			TFStroke.Color = Color3.fromRGB(40,40,40)
			TFStroke.Thickness = 1

			FillHold.Position = UDim2.new(0,1,0,1)
			FillHold.Size = UDim2.new(1,-2,1,-2)
			FillHold.BackgroundTransparency = 1
			FillHold.BorderSizePixel = 0
			FillHold.ZIndex = 53

			Fill.Size = UDim2.new(0,0,1,0)
			Fill.BackgroundColor3 = Library.Accent
			Fill.BorderSizePixel = 0
			Fill.Text = ""
			Fill.AutoButtonColor = false
			Fill.ZIndex = 53
			table.insert(Library.ThemeObjects, Fill)

			Circle.Position = UDim2.new(1,-7,0.5,-7)
			Circle.Size = UDim2.new(0,14,0,14)
			Circle.BackgroundColor3 = Color3.new(1,1,1)
			Circle.BorderSizePixel = 0
			Circle.ZIndex = 54
			local CircleStroke = Instance.new("UIStroke", Circle)
			CircleStroke.Color = Color3.fromRGB(40,40,40)
			CircleStroke.Thickness = 1

			SliderValue.Size = UDim2.new(1,0,0,17)
			SliderValue.BackgroundTransparency = 1
			SliderValue.BorderSizePixel = 0
			SliderValue.Text = ""
			SliderValue.TextColor3 = Color3.fromRGB(160,160,160)
			SliderValue.Font = Enum.Font.Gotham
			SliderValue.TextSize = Library.FontSize
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			AddTextStroke(SliderValue)

			local Sliding = false
			local Val = Slider.State
			local function Set(value)
				value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)
				local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
				TweenService:Create(Fill, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
				SliderValue.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
				Val = value
				Library.Flags[Slider.Flag] = value
				Slider.Callback(value)
			end

			local function Slide(input)
				local sizeX = (input.Position.X - NewSlider.AbsolutePosition.X) / NewSlider.AbsoluteSize.X
				local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
				Set(value)
			end

			Library:Connection(NewSlider.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Sliding = true
					Slide(input)
				end
			end)
			Library:Connection(NewSlider.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Sliding = false
				end
			end)
			Library:Connection(Fill.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Sliding = true
					Slide(input)
				end
			end)
			Library:Connection(Fill.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Sliding = false
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if Sliding then Slide(input) end
				end
			end)

			function Slider:Set(Value) Set(Value) end
			Flags[Slider.Flag] = Set
			Library.Flags[Slider.Flag] = Slider.State
			Set(Slider.State)

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "Slider",
				Name = Slider.Name,
				Ref = Slider,
				PageName = (Slider.Section and Slider.Section.Page and Slider.Section.Page.Name) or "?",
				SectionName = (Slider.Section and Slider.Section.Name) or "?",
				PageRef = (Slider.Section and Slider.Section.Page) or nil,
				GuiObject = NewSlider,
			})

			return Slider
		end

		function Sections:List(Properties)
			local Properties = Properties or {};
			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Open = false,
				Name = Properties.Name or Properties.name or nil,
				Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {"1","2","3"}),
				Max = (Properties.Max or Properties.max or nil),
				State = (Properties.state or Properties.State or Properties.def or Properties.Def or Properties.default or Properties.Default or nil),
				Callback = (Properties.callback or Properties.Callback or Properties.callBack or Properties.CallBack or function() end),
				Flag = (Properties.flag or Properties.Flag or Properties.pointer or Properties.Pointer or Library.NextFlag()),
				OptionInsts = {},
			}

			local NewDropdown = Instance.new('Frame', Dropdown.Section.Elements.SectionContent)
			local DropdownTitle = Instance.new('TextLabel', NewDropdown)
			local ToggleFrame = Instance.new('TextButton', NewDropdown)
			ToggleFrame.Name = "ToggleFrame"
			Instance.new('UICorner', ToggleFrame).CornerRadius = UDim.new(0,6)

			local ToggleContent = Instance.new('ScrollingFrame')
			ToggleContent.Name = "ToggleContent"
			Instance.new('UICorner', ToggleContent).CornerRadius = UDim.new(0,6)
			local UIListLayout = Instance.new('UIListLayout', ToggleContent)

			UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				ToggleContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
			end)

			local DropdownTitle_2 = Instance.new('TextLabel', ToggleFrame)
			local Icon = Instance.new('ImageLabel', ToggleFrame)

			NewDropdown.Size = UDim2.new(1,0,0,48)
			NewDropdown.BackgroundTransparency = 1
			NewDropdown.BorderSizePixel = 0
			NewDropdown.ZIndex = 54

			DropdownTitle.Size = UDim2.new(1,-10,0,17)
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.BorderSizePixel = 0
			DropdownTitle.Text = Dropdown.Name or ""
			DropdownTitle.TextColor3 = Color3.fromRGB(210,210,210)
			DropdownTitle.Font = Enum.Font.GothamBold
			DropdownTitle.TextSize = Library.FontSize
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			AddTextStroke(DropdownTitle)

			ToggleFrame.Position = UDim2.new(0,0,1,-24)
			ToggleFrame.Size = UDim2.new(1,0,0,24)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.ZIndex = 54
			ToggleFrame.AutoButtonColor = false
			ToggleFrame.Text = ""
			local TFStroke2 = Instance.new("UIStroke", ToggleFrame)
			TFStroke2.Color = Color3.fromRGB(38,38,38)

			ToggleContent.BackgroundColor3 = Color3.fromRGB(16,16,16)
			ToggleContent.BorderSizePixel = 0
			ToggleContent.ZIndex = 100
			ToggleContent.ClipsDescendants = true
			ToggleContent.ScrollBarImageTransparency = 0.5
			ToggleContent.ScrollBarThickness = 3
			ToggleContent.ScrollingDirection = Enum.ScrollingDirection.Y
			ToggleContent.AutomaticCanvasSize = Enum.AutomaticSize.None
			ToggleContent.CanvasSize = UDim2.new(0,0,0,0)
			ToggleContent.Size = UDim2.fromOffset(0, 0)
			ToggleContent.Visible = false
			ToggleContent.Parent = Library.ScreenGUI
			local TCStroke = Instance.new("UIStroke", ToggleContent)
			TCStroke.Color = Color3.fromRGB(35,35,35)

			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			DropdownTitle_2.Position = UDim2.new(0,8,0,0)
			DropdownTitle_2.Size = UDim2.new(1,-32,1,0)
			DropdownTitle_2.BackgroundTransparency = 1
			DropdownTitle_2.BorderSizePixel = 0
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

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "List",
				Name = Dropdown.Name or "List",
				Ref = Dropdown,
				PageName = (Dropdown.Section and Dropdown.Section.Page and Dropdown.Section.Page.Name) or "?",
				SectionName = (Dropdown.Section and Dropdown.Section.Name) or "?",
				PageRef = (Dropdown.Section and Dropdown.Section.Page) or nil,
				GuiObject = NewDropdown,
			})

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
			ToggleTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
			ToggleTitle.Text = Colorpicker.Name
			ToggleTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
			ToggleTitle.TextSize = 13
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -10, 0, 17)
			ToggleTitle.Parent = NewColor
			AddTextStroke(ToggleTitle)

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

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "Colorpicker",
				Name = Colorpicker.Name,
				Ref = Colorpicker,
				PageName = (Colorpicker.Section and Colorpicker.Section.Page and Colorpicker.Section.Page.Name) or "?",
				SectionName = (Colorpicker.Section and Colorpicker.Section.Name) or "?",
				PageRef = (Colorpicker.Section and Colorpicker.Section.Page) or nil,
				GuiObject = NewColor,
			})

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

			local function resolveKey(inp)
				local t = inp.UserInputType
				if t == Enum.UserInputType.Gamepad1
				or t == Enum.UserInputType.Gamepad2
				or t == Enum.UserInputType.Gamepad3
				or t == Enum.UserInputType.Gamepad4 then
					return inp.KeyCode
				end
				return t
			end

			local NewKey = Instance.new("TextButton")
			NewKey.Text = ""
			NewKey.AutoButtonColor = false
			NewKey.BackgroundTransparency = 1
			NewKey.BorderSizePixel = 0
			NewKey.Size = UDim2.new(1, 0, 0, 17)
			NewKey.ZIndex = 54
			NewKey.Parent = Keybind.Section.Elements.SectionContent

			local ToggleTitle = Instance.new("TextLabel")
			ToggleTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
			ToggleTitle.Text = Keybind.Name
			ToggleTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
			ToggleTitle.TextSize = 13
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -10, 0, 17)
			ToggleTitle.Parent = NewKey
			AddTextStroke(ToggleTitle)

			local KeyText = Instance.new("TextLabel")
			KeyText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			KeyText.Text = "None"
			KeyText.TextColor3 = Color3.fromRGB(150, 150, 150)
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
					if newkey == Enum.KeyCode.Backspace then
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
							set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or resolveKey(input))
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
				if (inp.KeyCode == Key or resolveKey(inp) == Key) and not Keybind.Binding and not Keybind.UseKey then
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
						if inp.KeyCode == Key or resolveKey(inp) == Key then
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

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "Keybind",
				Name = Keybind.Name,
				Ref = Keybind,
				PageName = (Keybind.Section and Keybind.Section.Page and Keybind.Section.Page.Name) or "?",
				SectionName = (Keybind.Section and Keybind.Section.Name) or "?",
				PageRef = (Keybind.Section and Keybind.Section.Page) or nil,
				GuiObject = NewKey,
			})

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
				TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
				TitleLabel.Text = TextboxName
				TitleLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
				TitleLabel.TextSize = 12
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Position = UDim2.new(0, 2, 0, 0)
				TitleLabel.Size = UDim2.new(1, -8, 0, 20)
				TitleLabel.ZIndex = 55
				TitleLabel.Parent = NewBox
				AddTextStroke(TitleLabel)
			end

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "ToggleFrame"
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

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "Textbox",
				Name = TextboxName or "Textbox",
				Ref = Textbox,
				PageName = (Textbox.Section and Textbox.Section.Page and Textbox.Section.Page.Name) or "?",
				SectionName = (Textbox.Section and Textbox.Section.Name) or "?",
				PageRef = (Textbox.Section and Textbox.Section.Page) or nil,
				GuiObject = NewBox,
			})

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
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Size = UDim2.new(1, 0, 1, 0)
			ToggleFrame.ZIndex = 55
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
			local BtnStroke = Instance.new("UIStroke", ToggleFrame)
			BtnStroke.Color = Color3.fromRGB(38,38,38)

			local BtnShimmer = Instance.new("Frame", ToggleFrame)
			BtnShimmer.Name = "BtnShimmer"
			BtnShimmer.Size = UDim2.new(1,0,1,0)
			BtnShimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
			BtnShimmer.BackgroundTransparency = 1
			BtnShimmer.BorderSizePixel = 0
			BtnShimmer.ZIndex = 56
			Instance.new("UICorner", BtnShimmer).CornerRadius = UDim.new(0,6)

			local DropdownTitle = Instance.new("TextLabel")
			DropdownTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
			DropdownTitle.Text = Button.Name
			DropdownTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
			DropdownTitle.TextSize = 12
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.BorderSizePixel = 0
			DropdownTitle.Size = UDim2.fromScale(1, 1)
			DropdownTitle.ZIndex = 57
			DropdownTitle.Parent = ToggleFrame
			AddTextStroke(DropdownTitle)

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

			-- SEARCH: register this element
			table.insert(Library.SearchIndex, {
				Type = "Button",
				Name = Button.Name,
				Ref = Button,
				PageName = (Button.Section and Button.Section.Page and Button.Section.Page.Name) or "?",
				SectionName = (Button.Section and Button.Section.Name) or "?",
				PageRef = (Button.Section and Button.Section.Page) or nil,
				GuiObject = NewButton,
			})
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
	end
end

local library = Library;
return library;
