--[[
    PHANTOM UI LIBRARY
    CSGO-inspired flat tactical UI for Roblox
    Full PC + Mobile + Controller support
    
    Usage:
        local Library = loadstring(...)()
        local win = Library:New({ Size = UDim2.new(0,600,0,460), Icon = "rbxassetid://..." })
        win:Seperator({ Name = "MAIN" })
        local page = win:Page({ Name = "Combat", Icon = "rbxassetid://..." })
        local sec = page:Section({ Name = "Aimbot", Side = "Left" })
        sec:Toggle({ Name = "Enable", Flag = "aim_on", Callback = function(v) end })
]]

local Library = {}
do
    Library = {
        Open       = true,
        Accent     = Color3.fromRGB(200, 170, 90),   -- muted gold
        Pages      = {},
        Sections   = {},
        Flags      = {},
        UnNamedFlags = 0,
        ThemeObjects = {},
        Instances  = {},
        Holder     = nil,
        OldSize    = nil,
        ScreenGUI  = nil,
        DropdownOpen   = false,
        OptionListOpen = false,
        Keys = {
            [Enum.KeyCode.Space]        = "SPACE",
            [Enum.KeyCode.Return]       = "ENTER",
            [Enum.KeyCode.LeftShift]    = "LSHIFT",
            [Enum.KeyCode.RightShift]   = "RSHIFT",
            [Enum.KeyCode.LeftControl]  = "LCTRL",
            [Enum.KeyCode.RightControl] = "RCTRL",
            [Enum.KeyCode.LeftAlt]      = "LALT",
            [Enum.KeyCode.RightAlt]     = "RALT",
            [Enum.KeyCode.CapsLock]     = "CAPS",
            [Enum.KeyCode.One]="1",[Enum.KeyCode.Two]="2",[Enum.KeyCode.Three]="3",
            [Enum.KeyCode.Four]="4",[Enum.KeyCode.Five]="5",[Enum.KeyCode.Six]="6",
            [Enum.KeyCode.Seven]="7",[Enum.KeyCode.Eight]="8",[Enum.KeyCode.Nine]="9",
            [Enum.KeyCode.Zero]="0",
            [Enum.KeyCode.Minus]="-",[Enum.KeyCode.Equals]="=",
            [Enum.KeyCode.LeftBracket]="[",[Enum.KeyCode.RightBracket]="]",
            [Enum.KeyCode.Semicolon]=";",[Enum.KeyCode.Quote]="'",
            [Enum.KeyCode.BackSlash]="\\",[Enum.KeyCode.Comma]=",",
            [Enum.KeyCode.Period]=".",[Enum.KeyCode.Slash]="/",
            [Enum.UserInputType.MouseButton1]="M1",
            [Enum.UserInputType.MouseButton2]="M2",
            [Enum.UserInputType.MouseButton3]="M3",
        },
        Connections  = {},
        FontSize     = 12,
        VisValues    = {},
        UIKey        = Enum.KeyCode.Insert,
        Notifs       = {},
        -- Controller navigation
        ControllerMode    = false,
        FocusedElement    = nil,
        NavigableElements = {},
    }

    -- ╔══════════════════════════════════════════╗
    -- ║  PALETTE                                 ║
    -- ╚══════════════════════════════════════════╝
    local P = {
        bg0     = Color3.fromRGB(14,  14,  14),   -- deepest bg
        bg1     = Color3.fromRGB(20,  20,  20),   -- panel bg
        bg2     = Color3.fromRGB(26,  26,  26),   -- section bg
        bg3     = Color3.fromRGB(32,  32,  32),   -- element bg
        bg4     = Color3.fromRGB(40,  40,  40),   -- hover / input
        border  = Color3.fromRGB(48,  48,  48),   -- borders
        border2 = Color3.fromRGB(60,  60,  60),   -- lighter borders
        text0   = Color3.fromRGB(230, 230, 230),  -- primary text
        text1   = Color3.fromRGB(160, 160, 160),  -- secondary text
        text2   = Color3.fromRGB(90,  90,  90),   -- dim text
        accent  = Color3.fromRGB(200, 170, 90),   -- gold accent
        accentD = Color3.fromRGB(160, 130, 60),   -- dark accent
        red     = Color3.fromRGB(210, 60,  60),   -- danger
        white   = Color3.new(1, 1, 1),
        black   = Color3.new(0, 0, 0),
    }

    -- convenience: create a UICorner
    local function Corner(parent, r)
        local c = Instance.new("UICorner", parent)
        c.CornerRadius = UDim.new(0, r or 2)
        return c
    end

    -- convenience: create a UIStroke
    local function Stroke(parent, color, thickness, trans)
        local s = Instance.new("UIStroke", parent)
        s.Color = color or P.border
        s.Thickness = thickness or 1
        s.Transparency = trans or 0
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return s
    end

    -- convenience: solid frame
    local function Frame(parent, props)
        local f = Instance.new("Frame", parent)
        f.BackgroundColor3 = props.Color or P.bg1
        f.BorderSizePixel = 0
        f.Size = props.Size or UDim2.new(1,0,1,0)
        f.Position = props.Position or UDim2.new(0,0,0,0)
        if props.ZIndex then f.ZIndex = props.ZIndex end
        if props.Clip then f.ClipsDescendants = true end
        if props.AnchorPoint then f.AnchorPoint = props.AnchorPoint end
        if props.Transparency then f.BackgroundTransparency = props.Transparency end
        if props.Name then f.Name = props.Name end
        return f
    end

    -- convenience: text label
    local function Label(parent, props)
        local l = Instance.new("TextLabel", parent)
        l.BackgroundTransparency = 1
        l.BorderSizePixel = 0
        l.Font = props.Font or Enum.Font.GothamBold
        l.TextSize = props.Size or 11
        l.Text = props.Text or ""
        l.TextColor3 = props.Color or P.text1
        l.TextXAlignment = props.AlignX or Enum.TextXAlignment.Left
        l.TextYAlignment = props.AlignY or Enum.TextYAlignment.Center
        l.Size = props.Frame or UDim2.new(1,0,1,0)
        l.Position = props.Position or UDim2.new(0,0,0,0)
        if props.ZIndex then l.ZIndex = props.ZIndex end
        if props.Clip then l.TextTruncate = Enum.TextTruncate.AtEnd end
        if props.Rich then l.RichText = true end
        if props.Name then l.Name = props.Name end
        return l
    end

    -- tween shorthand
    local TS = game:GetService("TweenService")
    local function Tween(obj, t, props)
        TS:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end

    -- ╔══════════════════════════════════════════╗
    -- ║  INTERNALS                               ║
    -- ╚══════════════════════════════════════════╝
    local Flags = {}
    local ColorHolders = {}

    Library.__index = Library
    Library.Pages.__index    = Library.Pages
    Library.Sections.__index = Library.Sections

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Mouse       = LocalPlayer:GetMouse()
    local Players     = game:GetService("Players")
    local UIS         = game:GetService("UserInputService")

    -- ╔══════════════════════════════════════════╗
    -- ║  MISC FUNCTIONS                          ║
    -- ╚══════════════════════════════════════════╝
    do
        function Library:Connection(signal, cb)
            return signal:Connect(cb)
        end
        function Library:Disconnect(con)
            con:Disconnect()
        end
        function Library:Round(n, f)
            return f * math.floor(n / f)
        end
        function Library.NextFlag()
            Library.UnNamedFlags += 1
            return string.format("%.14g", Library.UnNamedFlags)
        end

        function Library:GetConfig()
            local cfg = ""
            for k, v in pairs(self.Flags) do
                if k ~= "ConfigConfig_List" and k ~= "ConfigConfig_Load" and k ~= "ConfigConfig_Save" then
                    local v2, final = v, ""
                    if typeof(v2) == "Color3" then
                        local h,s,val = v2:ToHSV()
                        final = ("rgb(%s,%s,%s,%s)"):format(h,s,val,1)
                    elseif typeof(v2) == "table" and v2.Color and v2.Transparency then
                        local h,s,val = v2.Color:ToHSV()
                        final = ("rgb(%s,%s,%s,%s)"):format(h,s,val,v2.Transparency)
                    elseif typeof(v2) == "table" and v.Mode then
                        local vals = v.current
                        final = ("key(%s,%s,%s)"):format(vals[1] or "nil", vals[2] or "nil", v.Mode)
                    elseif v2 ~= nil then
                        if typeof(v2) == "boolean" then
                            v2 = ("bool(%s)"):format(tostring(v2))
                        elseif typeof(v2) == "table" then
                            local new = "table("
                            for _,v3 in pairs(v2) do new = new..v3.."," end
                            if new:sub(#new) == "," then new = new:sub(0,#new-1) end
                            v2 = new..")"
                        elseif typeof(v2) == "string" then v2 = ("string(%s)"):format(v2)
                        elseif typeof(v2) == "number"  then v2 = ("number(%s)"):format(v2)
                        end
                        final = v2
                    end
                    cfg = cfg..k..": "..tostring(final).."\n"
                end
            end
            return cfg
        end

        function Library:LoadConfig(cfg)
            local t1 = string.split(cfg, "\n")
            local t2 = {}
            for _,v in pairs(t1) do
                local t3 = string.split(v,":")
                if t3[1] ~= "ConfigConfig_List" and #t3 >= 2 then
                    local val = t3[2]:sub(2,#t3[2])
                    if     val:sub(1,3)=="rgb"   then val = string.split(val:sub(5,#val-1),",")
                    elseif val:sub(1,3)=="key"   then
                        local t4 = string.split(val:sub(5,#val-1),",")
                        if t4[1]=="nil" and t4[2]=="nil" then t4[1]=nil;t4[2]=nil end
                        val = t4
                    elseif val:sub(1,4)=="bool"  then val = val:sub(6,#val-1)=="true"
                    elseif val:sub(1,5)=="table" then val = string.split(val:sub(7,#val-1),",")
                    elseif val:sub(1,6)=="string" then val = val:sub(8,#val-1)
                    elseif val:sub(1,6)=="number" then val = tonumber(val:sub(8,#val-1))
                    end
                    t2[t3[1]] = val
                end
            end
            for i,v in pairs(t2) do
                if Flags[i] then
                    if typeof(Flags[i])=="table" then Flags[i]:Set(v) else Flags[i](v) end
                end
            end
        end

        function Library:SetOpen(bool)
            if typeof(bool) ~= "boolean" then return end
            Library.Open = bool
            if bool then
                Library.Holder.Visible = true
                Tween(Library.Holder, 0.2, {Size = UDim2.new(0,Library.OldSize.X.Offset,0,Library.OldSize.Y.Offset)})
            else
                Tween(Library.Holder, 0.2, {Size = UDim2.new(0,Library.OldSize.X.Offset,0,0)})
                task.wait(0.22)
                Library.Holder.Visible = false
            end
        end

        function Library:ChangeAccent(color)
            Library.Accent = color
            P.accent = color
            for _,obj in next, Library.ThemeObjects do
                if obj:IsA("Frame") or obj:IsA("TextButton") then
                    obj.BackgroundColor3 = color
                elseif obj:IsA("TextLabel") then
                    obj.TextColor3 = color
                elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    obj.ImageColor3 = color
                elseif obj:IsA("ScrollingFrame") then
                    obj.ScrollBarImageColor3 = color
                elseif obj:IsA("UIStroke") then
                    obj.Color = color
                end
            end
        end

        function Library:IsMouseOverFrame(f)
            local p,s = f.AbsolutePosition, f.AbsoluteSize
            return Mouse.X>=p.X and Mouse.X<=p.X+s.X and Mouse.Y>=p.Y and Mouse.Y<=p.Y+s.Y
        end

        -- Drag support (PC + touch)
        local function MakeDraggable(inst)
            local dragging, dragInput, startPos, startMouse
            inst.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    startMouse = inp.Position
                    startPos = inst.Position
                    inp.Changed:Connect(function()
                        if inp.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            inst.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    dragInput = inp
                end
            end)
            UIS.InputChanged:Connect(function(inp)
                if dragging and inp == dragInput then
                    local d = inp.Position - startMouse
                    inst.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
                end
            end)
        end

        function Library:GetExecutor()
            if syn then return "SYNAPSE"
            elseif KRNL_LOADED then return "KRNL"
            elseif pebc_execute then return "ELECTRON"
            elseif PROTOSMASHER_LOADED then return "PROTO"
            elseif getexecutorname then local s,r=pcall(getexecutorname); if s then return r:upper() end
            elseif identifyexecutor then local s,r=pcall(identifyexecutor); if s then return r:upper() end
            end
            return "UNKNOWN"
        end
    end

    -- ╔══════════════════════════════════════════╗
    -- ║  COLOR PICKER                            ║
    -- ╚══════════════════════════════════════════╝
    do
        function Library:NewPicker(name, default, parent, count, flag, callback)
            local mouse_pos = Vector2.new(0,0)
            local function setMousePos(pos)
                if typeof(pos)=="Vector3" then mouse_pos=Vector2.new(pos.X,pos.Y)
                elseif typeof(pos)=="Vector2" then mouse_pos=pos end
            end
            UIS.InputChanged:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
                    setMousePos(inp.Position)
                end
            end)
            UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.Touch then setMousePos(inp.Position) end
            end)

            -- Swatch button
            local swatchBtn = Instance.new("TextButton", parent)
            swatchBtn.Size = UDim2.new(0,18,0,18)
            swatchBtn.AnchorPoint = Vector2.new(0,0.5)
            swatchBtn.Position = count==1 and UDim2.new(1,-20,0.5,0) or UDim2.new(1,-20-(count-1)*24,0.5,0)
            swatchBtn.BackgroundColor3 = default
            swatchBtn.BorderSizePixel = 0
            swatchBtn.Text = ""
            swatchBtn.AutoButtonColor = false
            Corner(swatchBtn, 2)
            Stroke(swatchBtn, P.border2, 1)

            -- Picker panel
            local pickerPanel = Instance.new("Frame", Library.ScreenGUI)
            pickerPanel.Size = UDim2.new(0,192,0,190)
            pickerPanel.BackgroundColor3 = P.bg1
            pickerPanel.BorderSizePixel = 0
            pickerPanel.ZIndex = 200
            pickerPanel.Visible = false
            Corner(pickerPanel, 3)
            Stroke(pickerPanel, P.border2, 1)

            -- Header bar
            local hdr = Frame(pickerPanel, {Color=P.bg0, Size=UDim2.new(1,0,0,22)})
            hdr.ZIndex = 201
            Label(hdr, {Text=name~="" and name:upper() or "COLOR", Size=10, Color=P.text2, Position=UDim2.new(0,8,0,0), Frame=UDim2.new(1,-8,1,0), ZIndex=202})

            local h, s, v = default:ToHSV()

            -- SV canvas
            local canvas = Instance.new("ImageButton", pickerPanel)
            canvas.Image = "rbxassetid://14684562507"
            canvas.Position = UDim2.new(0,8,0,28)
            canvas.Size = UDim2.new(1,-16,0,130)
            canvas.BackgroundColor3 = Color3.fromHSV(h,1,1)
            canvas.AutoButtonColor = false
            canvas.ZIndex = 201
            Corner(canvas, 2)

            local svDot = Instance.new("Frame", canvas)
            svDot.Size = UDim2.new(0,8,0,8)
            svDot.AnchorPoint = Vector2.new(0.5,0.5)
            svDot.BackgroundTransparency = 1
            svDot.ZIndex = 202
            Corner(svDot, 4)
            local svStroke = Instance.new("UIStroke", svDot)
            svStroke.Color = P.white; svStroke.Thickness = 2

            -- Hue bar
            local hueBar = Instance.new("ImageButton", pickerPanel)
            hueBar.Image = "rbxassetid://16789872274"
            hueBar.Position = UDim2.new(0,8,0,166)
            hueBar.Size = UDim2.new(1,-16,0,10)
            hueBar.BackgroundTransparency = 1
            hueBar.AutoButtonColor = false
            hueBar.ZIndex = 201
            Corner(hueBar, 5)

            local hueDot = Instance.new("Frame", hueBar)
            hueDot.Size = UDim2.new(0,10,0,16)
            hueDot.AnchorPoint = Vector2.new(0.5,0.5)
            hueDot.Position = UDim2.new(0,0,0.5,0)
            hueDot.BackgroundColor3 = P.white
            hueDot.ZIndex = 202
            Corner(hueDot, 2)
            Stroke(hueDot, P.border2, 1)

            local draggingSV, draggingHue = false, false

            local function update()
                local pPos,pSize = canvas.AbsolutePosition,canvas.AbsoluteSize
                local hPos,hSize = hueBar.AbsolutePosition,hueBar.AbsoluteSize
                local rPal = mouse_pos - pPos
                local rHue = mouse_pos - hPos
                if draggingSV then
                    s = math.clamp(rPal.X/pSize.X,0,1)
                    v = math.clamp(1-rPal.Y/pSize.Y,0,1)
                end
                if draggingHue then h = math.clamp(rHue.X/hSize.X,0,1) end
                local color = Color3.fromHSV(h,s,v)
                canvas.BackgroundColor3 = Color3.fromHSV(h,1,1)
                swatchBtn.BackgroundColor3 = color
                svDot.Position = UDim2.new(s,0,1-v,0)
                hueDot.Position = UDim2.new(h,-5,0.5,0)
                if flag then Library.Flags[flag] = color end
                callback(color)
            end

            local function set(color)
                if typeof(color)=="table" then color=Color3.fromHSV(color[1],color[2],color[3])
                elseif typeof(color)=="string" then color=Color3.fromHex(color) end
                h,s,v = color:ToHSV(); update()
            end
            Flags[flag] = set; set(default)

            canvas.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    draggingSV=true; setMousePos(i.Position); update()
                end
            end)
            canvas.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSV=false end
            end)
            hueBar.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    draggingHue=true; setMousePos(i.Position); update()
                end
            end)
            hueBar.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingHue=false end
            end)
            UIS.InputChanged:Connect(function(i)
                if (draggingSV or draggingHue) and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                    setMousePos(i.Position); update()
                end
            end)

            local function ClosePicker()
                pickerPanel.Visible=false; parent.ZIndex=1; Library.Cooldown=false
            end

            swatchBtn.MouseButton1Down:Connect(function()
                if pickerPanel.Visible then ClosePicker(); return end
                pickerPanel.Position = UDim2.fromOffset(
                    math.clamp(swatchBtn.AbsolutePosition.X-90, 4, 9999),
                    swatchBtn.AbsolutePosition.Y+24
                )
                pickerPanel.Visible=true; parent.ZIndex=100; Library.Cooldown=true
            end)
            UIS.InputBegan:Connect(function(i)
                if not pickerPanel.Visible then return end
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    local pos=i.Position
                    local fp,fs=pickerPanel.AbsolutePosition,pickerPanel.AbsoluteSize
                    if pos.X<fp.X or pos.X>fp.X+fs.X or pos.Y<fp.Y or pos.Y>fp.Y+fs.Y then ClosePicker() end
                end
            end)

            return {}, pickerPanel
        end
    end

    -- ╔══════════════════════════════════════════╗
    -- ║  NOTIFICATIONS                           ║
    -- ╚══════════════════════════════════════════╝
    function Library:updateNotifsPositions()
        for i,n in ipairs(Library.Notifs) do
            Tween(n.Container, 0.4, {Position = UDim2.new(1,-10,0, 10+(i-1)*34)})
        end
    end

    function Library:Notification(message, duration)
        local notif = {Container=nil}

        local container = Frame(Library.ScreenGUI, {
            Color=P.bg0, Size=UDim2.new(0,240,0,28), Transparency=1,
            Position=UDim2.new(1,260,0,10), Name="Notif"
        })
        container.AnchorPoint = Vector2.new(1,0)
        container.ZIndex = 300
        notif.Container = container

        Corner(container, 2)
        Stroke(container, P.border, 1)

        -- accent left strip
        local strip = Frame(container, {Color=P.accent, Size=UDim2.new(0,2,1,0), Position=UDim2.new(0,0,0,0)})
        strip.ZIndex = 301

        local txt = Label(container, {
            Text=message, Color=P.text0, Size=11,
            Position=UDim2.new(0,10,0,0), Frame=UDim2.new(1,-14,1,0),
            ZIndex=301, Clip=true
        })
        txt.Font = Enum.Font.Gotham

        function notif:remove()
            table.remove(Library.Notifs, table.find(Library.Notifs, notif) or 1)
            Library:updateNotifsPositions()
            task.delay(0.5, function() container:Destroy() end)
        end

        task.spawn(function()
            -- slide in
            container.BackgroundTransparency = 0
            Tween(container, 0.25, {Position=UDim2.new(1,-10,0,10)})
            task.wait(duration)
            Tween(container, 0.2, {BackgroundTransparency=1, Position=UDim2.new(1,260,0,10)})
            txt.TextTransparency = 1
        end)

        task.delay(duration + 0.3, function() notif:remove() end)
        table.insert(Library.Notifs, notif)
        Library:updateNotifsPositions()
        return notif
    end

    -- ╔══════════════════════════════════════════╗
    -- ║  MAIN WINDOW                             ║
    -- ╚══════════════════════════════════════════╝
    do
        local Pages = Library.Pages
        local Sections = Library.Sections

        function Library:New(Properties)
            Properties = Properties or {}

            local Window = {
                Size = Properties.Size or UDim2.new(0,600,0,460),
                Pages = {},
                Elements = {},
            }

            -- Screen GUI
            local sg = Instance.new("ScreenGui",
                game:GetService("RunService"):IsStudio()
                    and Players.LocalPlayer.PlayerGui
                    or game:GetService("CoreGui"))
            sg.DisplayOrder = 100
            sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            Library.ScreenGUI = sg

            -- ── Root frame ──────────────────────────────────
            local root = Frame(sg, {
                Color=P.bg0, Size=UDim2.new(0,0,0,0),
                Position=UDim2.new(0.5,0,0.5,0), ZIndex=50, Name="Root"
            })
            root.AnchorPoint = Vector2.new(0.5,0.5)
            -- no corner radius = sharp CSGO style
            Stroke(root, P.border, 1)

            Library.Holder = root
            Library.OldSize = Window.Size

            -- ── Sidebar ──────────────────────────────────────
            local sidebar = Frame(root, {
                Color=P.bg1,
                Size=UDim2.new(0,160,1,0),
                ZIndex=51, Name="Sidebar"
            })

            -- Sidebar top accent line
            local topLine = Frame(sidebar, {
                Color=P.accent,
                Size=UDim2.new(1,0,0,2),
                ZIndex=52
            })
            table.insert(Library.ThemeObjects, topLine)

            -- Logo
            local logoFrame = Frame(sidebar, {
                Color=P.bg0,
                Size=UDim2.new(1,0,0,54),
                Position=UDim2.new(0,0,0,2),
                ZIndex=52
            })
            local logoImg = Instance.new("ImageLabel", logoFrame)
            logoImg.Size = UDim2.new(0,32,0,32)
            logoImg.AnchorPoint = Vector2.new(0.5,0.5)
            logoImg.Position = UDim2.new(0.5,0,0.5,0)
            logoImg.BackgroundTransparency = 1
            logoImg.Image = Properties.Icon or ""
            logoImg.ScaleType = Enum.ScaleType.Fit
            logoImg.ZIndex = 53

            -- Separator line under logo
            local logoDiv = Frame(sidebar, {
                Color=P.border,
                Size=UDim2.new(1,0,0,1),
                Position=UDim2.new(0,0,0,56),
                ZIndex=52
            })

            -- Tab list
            local tabList = Frame(sidebar, {
                Color=P.bg1,
                Size=UDim2.new(1,0,1,-170),
                Position=UDim2.new(0,0,0,57),
                ZIndex=52, Name="TabList"
            })
            tabList.BackgroundTransparency = 1
            local tabLayout = Instance.new("UIListLayout", tabList)
            tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tabLayout.Padding = UDim.new(0,0)

            -- Player card at bottom of sidebar
            local cardY = -104
            local card = Frame(sidebar, {
                Color=P.bg0,
                Size=UDim2.new(1,0,0,100),
                Position=UDim2.new(0,0,1,cardY),
                ZIndex=52, Name="PlayerCard"
            })
            local cardDiv = Frame(sidebar, {
                Color=P.border, Size=UDim2.new(1,0,0,1),
                Position=UDim2.new(0,0,1,cardY-1), ZIndex=52
            })

            -- Avatar
            local avatarBg = Frame(card, {
                Color=P.bg2, Size=UDim2.fromOffset(44,44),
                Position=UDim2.new(0,10,0,10), ZIndex=53
            })
            Corner(avatarBg, 22)
            Stroke(avatarBg, P.accent, 1)
            local avatarImg = Instance.new("ImageLabel", avatarBg)
            avatarImg.Size = UDim2.new(1,-4,1,-4)
            avatarImg.Position = UDim2.fromOffset(2,2)
            avatarImg.BackgroundTransparency = 1
            avatarImg.Image = ""
            avatarImg.ZIndex = 54
            Corner(avatarImg, 22)
            task.spawn(function()
                local ok,res = pcall(function()
                    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
                end)
                if ok then avatarImg.Image = res end
            end)

            local dispName = Label(card, {
                Text=LocalPlayer.DisplayName, Color=P.text0, Size=12,
                Position=UDim2.new(0,62,0,10), Frame=UDim2.new(1,-66,0,16),
                ZIndex=53, Clip=true
            })
            dispName.Font = Enum.Font.GothamBold

            local userName = Label(card, {
                Text="@"..LocalPlayer.Name, Color=P.text2, Size=10,
                Position=UDim2.new(0,62,0,28), Frame=UDim2.new(1,-66,0,14),
                ZIndex=53, Clip=true
            })
            userName.Font = Enum.Font.Gotham

            -- Executor badge
            local badgeBg = Frame(card, {
                Color=P.bg3, Size=UDim2.new(0,0,0,16),
                Position=UDim2.new(0,62,0,48), ZIndex=53
            })
            badgeBg.AutomaticSize = Enum.AutomaticSize.X
            Corner(badgeBg, 2)
            local badgePad = Instance.new("UIPadding", badgeBg)
            badgePad.PaddingLeft = UDim.new(0,6); badgePad.PaddingRight = UDim.new(0,6)
            local badgeTxt = Label(badgeBg, {
                Text=Library:GetExecutor(), Color=P.accent, Size=9,
                Frame=UDim2.new(0,0,1,0), ZIndex=54
            })
            badgeTxt.AutomaticSize = Enum.AutomaticSize.X
            badgeTxt.Font = Enum.Font.GothamBold
            table.insert(Library.ThemeObjects, badgeTxt)

            -- Version / close row
            local closeBtn = Instance.new("TextButton", card)
            closeBtn.Size = UDim2.new(1,0,0,20)
            closeBtn.Position = UDim2.new(0,0,1,-22)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Text = "[ INSERT TO TOGGLE ]"
            closeBtn.TextColor3 = P.text2
            closeBtn.Font = Enum.Font.Gotham
            closeBtn.TextSize = 9
            closeBtn.ZIndex = 53
            closeBtn.TextXAlignment = Enum.TextXAlignment.Center

            -- ── Content area ────────────────────────────────
            local content = Frame(root, {
                Color=P.bg2,
                Size=UDim2.new(1,-160,1,0),
                Position=UDim2.new(0,160,0,0),
                ZIndex=51, Name="Content", Clip=true
            })

            -- Content top accent
            local contentTopLine = Frame(content, {
                Color=P.accent, Size=UDim2.new(1,0,0,2), ZIndex=52
            })
            table.insert(Library.ThemeObjects, contentTopLine)

            -- Vertical divider between sidebar and content
            local divLine = Frame(root, {
                Color=P.border, Size=UDim2.new(0,1,1,0),
                Position=UDim2.new(0,160,0,0), ZIndex=60
            })

            Window.Elements = {
                TabHolder = tabList,
                Holder    = content,
            }

            MakeDraggable(root)

            function Window:UpdateTabs()
                for _,p in pairs(Window.Pages) do p:Turn(p.Open) end
            end

            Library:Connection(UIS.InputBegan, function(inp)
                if inp.KeyCode == Library.UIKey then
                    Library:SetOpen(not Library.Open)
                end
            end)

            -- Controller: gamepad navigation
            Library:Connection(UIS.InputBegan, function(inp)
                if inp.UserInputType == Enum.UserInputType.Gamepad1 then
                    Library.ControllerMode = true
                    if inp.KeyCode == Enum.KeyCode.ButtonB then
                        Library:SetOpen(not Library.Open)
                    end
                end
            end)

            -- Animate open
            Tween(root, 0.25, {Size=UDim2.new(0,Window.Size.X.Offset,0,Window.Size.Y.Offset)})

            Library.Holder = root
            return setmetatable(Window, Library)
        end

        -- ── SEPARATOR ────────────────────────────────────────
        function Library:Seperator(Properties)
            Properties = Properties or {}
            local Page = {Name=Properties.Name or "", Window=self}

            local sep = Frame(Page.Window.Elements.TabHolder, {
                Color=P.bg1, Size=UDim2.new(1,0,0,22),
                Transparency=1
            })
            sep.BackgroundTransparency = 1

            local lbl = Label(sep, {
                Text=string.upper(Page.Name), Color=P.text2, Size=9,
                Position=UDim2.new(0,12,0,0),
                Frame=UDim2.new(1,-12,1,0)
            })
            lbl.Font = Enum.Font.GothamBold

            -- tiny accent line before text
            local accentTick = Frame(sep, {
                Color=P.accent, Size=UDim2.new(0,2,0,8),
                Position=UDim2.new(0,6,0.5,-4), ZIndex=52
            })
            table.insert(Library.ThemeObjects, accentTick)
        end

        -- ── PAGE ─────────────────────────────────────────────
        function Library:Page(Properties)
            Properties = Properties or {}
            local Page = {
                Name    = Properties.Name or "Page",
                Icon    = Properties.Icon or "",
                Window  = self,
                Open    = false,
                Sections= {},
                Elements= {},
            }

            -- Tab button
            local tabBtn = Instance.new("TextButton", Page.Window.Elements.TabHolder)
            tabBtn.Size = UDim2.new(1,0,0,34)
            tabBtn.BackgroundColor3 = P.bg1
            tabBtn.BackgroundTransparency = 1
            tabBtn.BorderSizePixel = 0
            tabBtn.Text = ""
            tabBtn.AutoButtonColor = false

            -- Active indicator bar (left edge)
            local indicator = Frame(tabBtn, {
                Color=P.accent, Size=UDim2.new(0,2,0,18),
                Position=UDim2.new(0,0,0.5,-9), Transparency=1, ZIndex=54
            })
            table.insert(Library.ThemeObjects, indicator)

            -- Hover / active bg
            local tabBg = Frame(tabBtn, {
                Color=P.bg3, Size=UDim2.new(1,0,1,0), Transparency=1, ZIndex=52
            })

            -- Icon
            local tabIcon = Instance.new("ImageLabel", tabBtn)
            tabIcon.Size = UDim2.new(0,14,0,14)
            tabIcon.AnchorPoint = Vector2.new(0,0.5)
            tabIcon.Position = UDim2.new(0,14,0.5,0)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Image = Page.Icon
            tabIcon.ImageColor3 = P.text2
            tabIcon.ScaleType = Enum.ScaleType.Fit
            tabIcon.ZIndex = 53

            -- Label
            local tabLbl = Label(tabBtn, {
                Text=string.upper(Page.Name), Color=P.text2, Size=11,
                Position=UDim2.new(0,34,0,0), Frame=UDim2.new(1,-38,1,0),
                ZIndex=53
            })
            tabLbl.Font = Enum.Font.GothamBold

            -- Hover
            tabBtn.MouseEnter:Connect(function()
                if not Page.Open then Tween(tabBg,0.12,{BackgroundTransparency=0.88}) end
            end)
            tabBtn.MouseLeave:Connect(function()
                if not Page.Open then Tween(tabBg,0.12,{BackgroundTransparency=1}) end
            end)

            -- Page container
            local pageFrame = Frame(Page.Window.Elements.Holder, {
                Color=P.bg2, Size=UDim2.new(1,0,1,0),
                Position=UDim2.new(0,0,0,0), Transparency=1, ZIndex=53, Clip=true
            })
            pageFrame.BackgroundTransparency = 1
            pageFrame.Visible = false

            -- Page header bar
            local pageHdr = Frame(pageFrame, {
                Color=P.bg1, Size=UDim2.new(1,0,0,38), ZIndex=54
            })
            local pageHdrLine = Frame(pageFrame, {
                Color=P.border, Size=UDim2.new(1,0,0,1),
                Position=UDim2.new(0,0,0,38), ZIndex=54
            })
            local pageTitle = Label(pageHdr, {
                Text=string.upper(Page.Name), Color=P.text0, Size=13,
                Position=UDim2.new(0,12,0,0), Frame=UDim2.new(1,-12,1,0),
                ZIndex=55
            })
            pageTitle.Font = Enum.Font.GothamBold

            -- Columns
            local Left  = Instance.new("ScrollingFrame", pageFrame)
            local Right = Instance.new("ScrollingFrame", pageFrame)

            for _, col in ipairs({Left, Right}) do
                col.CanvasSize = UDim2.new(0,0,0,0)
                col.ScrollBarImageTransparency = 0.7
                col.ScrollBarThickness = 2
                col.ScrollBarImageColor3 = P.accent
                col.ScrollingDirection = Enum.ScrollingDirection.Y
                col.BackgroundTransparency = 1
                col.BorderSizePixel = 0
                col.ZIndex = 54
                col.TopImage = ""; col.BottomImage = ""
                col.VerticalScrollBarInset = Enum.ScrollBarInset.Always
            end

            Left.Name = "Left"
            Left.Size = UDim2.new(0.5,-6,1,-46)
            Left.Position = UDim2.new(0,6,0,44)

            Right.Name = "Right"
            Right.Size = UDim2.new(0.5,-6,1,-46)
            Right.Position = UDim2.new(0.5,0,0,44)

            local function SetupCol(col)
                local lay = Instance.new("UIListLayout", col)
                lay.SortOrder = Enum.SortOrder.LayoutOrder
                lay.Padding = UDim.new(0,6)
                local pad = Instance.new("UIPadding", col)
                pad.PaddingTop = UDim.new(0,6)
                pad.PaddingBottom = UDim.new(0,6)
                lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    col.CanvasSize = UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+12)
                end)
            end
            SetupCol(Left); SetupCol(Right)

            function Page:Turn(state)
                Page.Open = state
                pageFrame.Visible = state
                if state then
                    Tween(indicator,0.15,{BackgroundTransparency=0})
                    Tween(tabBg,0.15,{BackgroundTransparency=0.82})
                    tabLbl.TextColor3 = P.text0
                    tabIcon.ImageColor3 = P.accent
                else
                    Tween(indicator,0.15,{BackgroundTransparency=1})
                    Tween(tabBg,0.15,{BackgroundTransparency=1})
                    tabLbl.TextColor3 = P.text2
                    tabIcon.ImageColor3 = P.text2
                end
            end

            Library:Connection(tabBtn.MouseButton1Click, function()
                if not Page.Open then
                    Page:Turn(true)
                    for _,p in pairs(Page.Window.Pages) do
                        if p~=Page and p.Open then p:Turn(false) end
                    end
                end
            end)

            Page.Elements = {Left=Left, Right=Right, TabButton=tabBtn}

            if #Page.Window.Pages == 0 then Page:Turn(true) end
            Page.Window.Pages[#Page.Window.Pages+1] = Page
            Page.Window:UpdateTabs()

            return setmetatable(Page, Library.Pages)
        end

        -- ── SECTION ──────────────────────────────────────────
        function Pages:Section(Properties)
            Properties = Properties or {}
            local Section = {
                Name  = Properties.Name or "Section",
                Page  = self,
                Side  = (Properties.Side or Properties.side or "left"):lower(),
                Size  = Properties.Size or Properties.size or "auto",
                Elements = {},
            }

            local isAuto = Section.Size == "auto"
            local Parent = Section.Side=="left" and Section.Page.Elements.Left or Section.Page.Elements.Right

            local frame = Frame(Parent, {
                Color=P.bg1, ZIndex=55,
                Size=isAuto and UDim2.new(1,0,0,0) or UDim2.new(1,0,0,Section.Size)
            })
            if isAuto then frame.AutomaticSize = Enum.AutomaticSize.Y end
            frame.LayoutOrder = #Section.Page.Sections+1
            Stroke(frame, P.border, 1)
            Corner(frame, 2)

            -- Section header
            local hdr = Frame(frame, {
                Color=P.bg0, Size=UDim2.new(1,0,0,28), ZIndex=56
            })
            Corner(hdr, 2)

            -- Left accent strip in header
            local hdrAccent = Frame(hdr, {
                Color=P.accent, Size=UDim2.new(0,2,1,-8),
                Position=UDim2.new(0,0,0,4), ZIndex=57
            })
            table.insert(Library.ThemeObjects, hdrAccent)

            local hdrTitle = Label(hdr, {
                Text=string.upper(Section.Name), Color=P.text1, Size=10,
                Position=UDim2.new(0,10,0,0), Frame=UDim2.new(1,-12,1,0),
                ZIndex=57
            })
            hdrTitle.Font = Enum.Font.GothamBold

            -- Separator
            local hdrLine = Frame(frame, {
                Color=P.border, Size=UDim2.new(1,0,0,1),
                Position=UDim2.new(0,0,0,28), ZIndex=56
            })

            -- Content
            local content = Frame(frame, {
                Color=P.bg1, ZIndex=56,
                Position=UDim2.new(0,0,0,29),
                Transparency=1
            })
            content.BackgroundTransparency = 1
            if isAuto then
                content.Size = UDim2.new(1,0,0,0)
                content.AutomaticSize = Enum.AutomaticSize.Y
            else
                content.Size = UDim2.new(1,0,1,-30)
            end

            local lay = Instance.new("UIListLayout", content)
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.Padding = UDim.new(0,6)

            local pad = Instance.new("UIPadding", content)
            pad.PaddingLeft = UDim.new(0,8)
            pad.PaddingRight = UDim.new(0,8)
            pad.PaddingTop = UDim.new(0,8)
            pad.PaddingBottom = UDim.new(0,8)

            Section.Elements.SectionContent = content
            Section.Page.Sections[#Section.Page.Sections+1] = Section

            return setmetatable(Section, Library.Sections)
        end

        -- ── TOGGLE ───────────────────────────────────────────
        function Sections:Toggle(Properties)
            Properties = Properties or {}
            local Toggle = {
                Name     = Properties.Name or "Toggle",
                State    = Properties.state or Properties.State or Properties.def or Properties.default or false,
                Callback = Properties.callback or Properties.Callback or function() end,
                Flag     = Properties.flag or Properties.Flag or Library.NextFlag(),
                Toggled  = false,
            }

            local row = Instance.new("TextButton", Toggle.Section and Toggle.Section.Elements.SectionContent or self.Elements.SectionContent)
            row.Size = UDim2.new(1,0,0,22)
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.ZIndex = 57

            local rowBg = Frame(row, {Color=P.bg3, Size=UDim2.new(1,0,1,0), Transparency=1, ZIndex=57})
            Corner(rowBg, 2)

            local lbl = Label(row, {
                Text=Properties.Name or "Toggle", Color=P.text1, Size=11,
                Position=UDim2.new(0,2,0,0), Frame=UDim2.new(1,-52,1,0),
                ZIndex=58, Clip=true
            })
            lbl.Font = Enum.Font.Gotham

            -- Switch track
            local track = Frame(row, {
                Color=P.bg3, Size=UDim2.new(0,36,0,16),
                Position=UDim2.new(1,-38,0.5,-8), ZIndex=58
            })
            Corner(track, 8)
            Stroke(track, P.border, 1)

            -- Active overlay
            local trackFill = Frame(track, {
                Color=P.accent, Size=UDim2.new(1,0,1,0), Transparency=1, ZIndex=59
            })
            Corner(trackFill, 8)
            table.insert(Library.ThemeObjects, trackFill)

            -- Knob
            local knob = Frame(track, {
                Color=P.text1, Size=UDim2.new(0,10,0,10),
                Position=UDim2.new(0,3,0.5,-5), ZIndex=60
            })
            Corner(knob, 5)

            -- Hover
            row.MouseEnter:Connect(function() Tween(rowBg,0.1,{BackgroundTransparency=0.88}) end)
            row.MouseLeave:Connect(function() Tween(rowBg,0.1,{BackgroundTransparency=1}) end)

            local function SetState(v)
                Toggle.Toggled = v ~= nil and v or not Toggle.Toggled
                if Toggle.Toggled then
                    Tween(trackFill,0.15,{BackgroundTransparency=0})
                    Tween(knob,0.18,{Position=UDim2.new(1,-13,0.5,-5), BackgroundColor3=P.white})
                    Tween(track,0.15,{})
                else
                    Tween(trackFill,0.15,{BackgroundTransparency=1})
                    Tween(knob,0.18,{Position=UDim2.new(0,3,0.5,-5), BackgroundColor3=P.text2})
                end
                Library.Flags[Toggle.Flag] = Toggle.Toggled
                Toggle.Callback(Toggle.Toggled)
            end

            function Toggle:OptionList(Properties)
                Properties = Properties or {}
                local Section = {Elements={}}
                local optBtn = Instance.new("ImageButton", row)
                optBtn.Position = UDim2.new(1,-60,0,1)
                optBtn.Size = UDim2.new(0,15,0,15)
                optBtn.BackgroundTransparency = 1
                optBtn.Image = "rbxassetid://6031280882"
                optBtn.ImageColor3 = P.text2
                optBtn.ZIndex = 59

                local optList = Frame(optBtn, {
                    Color=P.bg0, Size=UDim2.new(0,180,0,10),
                    Position=UDim2.new(0,20,0,-5), ZIndex=200
                })
                optList.AutomaticSize = Enum.AutomaticSize.Y
                optList.Visible = false
                Corner(optList, 2)
                Stroke(optList, P.border2, 1)

                local optContent = Frame(optList, {
                    Color=P.bg0, Transparency=1,
                    Position=UDim2.new(0,8,0,8),
                    Size=UDim2.new(1,-16,0,0), ZIndex=201
                })
                optContent.AutomaticSize = Enum.AutomaticSize.Y
                local ol = Instance.new("UIListLayout",optContent)
                ol.Padding = UDim.new(0,4); ol.SortOrder = Enum.SortOrder.LayoutOrder

                local pad = Instance.new("UIPadding",optList)
                pad.PaddingBottom = UDim.new(0,8)

                optBtn.MouseButton1Click:Connect(function()
                    optList.Visible = not optList.Visible
                    Library.OptionListOpen = optList.Visible
                end)
                UIS.InputBegan:Connect(function(inp)
                    if Library.DropdownOpen then return end
                    if optList.Visible and inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        if not Library:IsMouseOverFrame(optList) and not Library:IsMouseOverFrame(optBtn) then
                            optList.Visible = false; Library.OptionListOpen = false
                        end
                    end
                end)
                Section.Elements = {SectionContent=optContent}
                return setmetatable(Section, Library.Sections)
            end

            function Toggle.Set(b)
                b = type(b)=="boolean" and b or false
                if Toggle.Toggled ~= b then SetState(b) end
            end

            Toggle.Set(Toggle.State)
            Library.Flags[Toggle.Flag] = Toggle.State
            Flags[Toggle.Flag] = Toggle.Set
            row.MouseButton1Click:Connect(function() SetState() end)
            -- Gamepad
            row.SelectionImageObject = Instance.new("SelectionBox")
            return Toggle
        end

        -- ── NEST ─────────────────────────────────────────────
        function Sections:Nest(Properties)
            Properties = Properties or {}
            local Section = {
                RealSection=self, Size=Properties.size or Properties.Size or 160,
                Elements={}
            }
            local holder = Frame(Section.RealSection.Elements.SectionContent, {
                Color=P.bg0, Size=UDim2.new(1,0,0,Section.Size),
                ZIndex=58, Clip=true
            })
            Corner(holder, 2)
            Stroke(holder, P.border, 1)

            local scroll = Instance.new("ScrollingFrame", holder)
            scroll.Size = UDim2.new(1,0,1,0)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.CanvasSize = UDim2.new(0,0,0,0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.ScrollBarThickness = 2
            scroll.ScrollBarImageColor3 = P.accent
            scroll.TopImage=""; scroll.BottomImage=""
            scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
            scroll.ZIndex = 59
            table.insert(Library.ThemeObjects, scroll)

            local scrollContent = Frame(scroll, {
                Color=P.bg0, Transparency=1,
                Position=UDim2.new(0,8,0,4),
                Size=UDim2.new(1,-16,0,0), ZIndex=59
            })
            scrollContent.AutomaticSize = Enum.AutomaticSize.Y
            local nl = Instance.new("UIListLayout",scrollContent)
            nl.Padding=UDim.new(0,6); nl.SortOrder=Enum.SortOrder.LayoutOrder

            Section.Elements = {SectionContent=scrollContent}
            return setmetatable(Section, Library.Sections)
        end

        -- ── SLIDER ───────────────────────────────────────────
        function Sections:Slider(Properties)
            Properties = Properties or {}
            local Slider = {
                Name     = Properties.Name or "Slider",
                Min      = Properties.min or Properties.Min or 0,
                Max      = Properties.max or Properties.Max or 100,
                State    = Properties.state or Properties.State or Properties.def or Properties.default or 10,
                Sub      = Properties.suffix or Properties.Suffix or Properties.ending or "",
                Decimals = Properties.decimals or Properties.Decimals or 1,
                Callback = Properties.callback or Properties.Callback or function() end,
                Flag     = Properties.flag or Properties.Flag or Library.NextFlag(),
            }

            local parent = self.Elements.SectionContent
            local container = Frame(parent, {
                Color=P.bg1, Size=UDim2.new(1,0,0,44),
                Transparency=1, ZIndex=57
            })

            local nameLbl = Label(container, {
                Text=Properties.Name or "Slider", Color=P.text1, Size=11,
                Position=UDim2.new(0,0,0,0), Frame=UDim2.new(0.7,0,0,18),
                ZIndex=58
            })
            nameLbl.Font = Enum.Font.Gotham

            local valLbl = Label(container, {
                Text="", Color=P.accent, Size=11,
                Position=UDim2.new(0.7,0,0,0), Frame=UDim2.new(0.3,0,0,18),
                AlignX=Enum.TextXAlignment.Right, ZIndex=58
            })
            valLbl.Font = Enum.Font.GothamBold
            table.insert(Library.ThemeObjects, valLbl)

            -- Track
            local track = Frame(container, {
                Color=P.bg3, Size=UDim2.new(1,0,0,6),
                Position=UDim2.new(0,0,0,26), ZIndex=58
            })
            Corner(track, 3)
            Stroke(track, P.border, 1)

            -- Fill
            local fill = Frame(track, {
                Color=P.accent, Size=UDim2.new(0,0,1,0), ZIndex=59
            })
            Corner(fill, 3)
            table.insert(Library.ThemeObjects, fill)

            -- Knob (larger hit target)
            local knobBtn = Instance.new("TextButton", track)
            knobBtn.Size = UDim2.new(0,18,0,18)
            knobBtn.AnchorPoint = Vector2.new(0.5,0.5)
            knobBtn.Position = UDim2.new(0,0,0.5,0)
            knobBtn.BackgroundColor3 = P.white
            knobBtn.BorderSizePixel = 0
            knobBtn.Text = ""
            knobBtn.AutoButtonColor = false
            knobBtn.ZIndex = 60
            Corner(knobBtn, 9)
            Stroke(knobBtn, P.border2, 1)

            local sliding = false
            local function Set(value)
                value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)
                local pct = (value - Slider.Min) / (Slider.Max - Slider.Min)
                Tween(fill, 0.06, {Size=UDim2.new(pct,0,1,0)})
                Tween(knobBtn, 0.06, {Position=UDim2.new(pct,0,0.5,0)})
                valLbl.Text = string.format("%.14g", value)..Slider.Sub
                Library.Flags[Slider.Flag] = value
                Slider.Callback(value)
            end

            local function Slide(inp)
                local px = (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                Set(Slider.Min + (Slider.Max-Slider.Min)*px)
            end

            local function onBegan(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    sliding=true; Slide(inp)
                end
            end
            local function onEnded(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then sliding=false end
            end

            track.InputBegan:Connect(onBegan)
            track.InputEnded:Connect(onEnded)
            knobBtn.InputBegan:Connect(onBegan)
            knobBtn.InputEnded:Connect(onEnded)

            UIS.InputChanged:Connect(function(inp)
                if sliding and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                    Slide(inp)
                end
            end)

            -- Gamepad thumbstick
            UIS.InputChanged:Connect(function(inp)
                if not sliding then return end
                if inp.UserInputType==Enum.UserInputType.Gamepad1 and inp.KeyCode==Enum.KeyCode.Thumbstick1 then
                    local cur = Library.Flags[Slider.Flag] or Slider.State
                    Set(cur + inp.Position.X * 2)
                end
            end)

            function Slider:Set(v) Set(v) end
            Flags[Slider.Flag] = Set
            Library.Flags[Slider.Flag] = Slider.State
            Set(Slider.State)
            return Slider
        end

        -- ── LIST / DROPDOWN ──────────────────────────────────
        function Sections:List(Properties)
            Properties = Properties or {}
            local Dropdown = {
                Name       = Properties.Name or Properties.name or "",
                Options    = Properties.options or Properties.Options or Properties.values or {"A","B","C"},
                Max        = Properties.Max or Properties.max or nil,
                State      = Properties.state or Properties.State or Properties.def or Properties.default or nil,
                Callback   = Properties.callback or Properties.Callback or function() end,
                Flag       = Properties.flag or Properties.Flag or Library.NextFlag(),
                OptionInsts= {},
            }

            local parent = self.Elements.SectionContent
            local Chosen = Dropdown.Max and {} or nil
            local Count  = 0
            local isOpen = false

            local container = Frame(parent, {
                Color=P.bg1, Size=UDim2.new(1,0,0,42),
                Transparency=1, ZIndex=57
            })

            if Dropdown.Name and Dropdown.Name ~= "" then
                local nameLbl = Label(container, {
                    Text=Dropdown.Name, Color=P.text1, Size=11,
                    Position=UDim2.new(0,0,0,0), Frame=UDim2.new(1,0,0,18),
                    ZIndex=58
                })
                nameLbl.Font = Enum.Font.Gotham
            end

            -- Button
            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(1,0,0,24)
            btn.Position = UDim2.new(0,0,0, Dropdown.Name~="" and 18 or 0)
            btn.BackgroundColor3 = P.bg3
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 58
            Corner(btn, 2)
            Stroke(btn, P.border, 1)

            local selLbl = Label(btn, {
                Text="", Color=P.text0, Size=11,
                Position=UDim2.new(0,8,0,0), Frame=UDim2.new(1,-28,1,0),
                ZIndex=59, Clip=true
            })
            selLbl.Font = Enum.Font.Gotham

            -- Arrow
            local arrow = Instance.new("ImageLabel", btn)
            arrow.Size = UDim2.new(0,12,0,12)
            arrow.AnchorPoint = Vector2.new(1,0.5)
            arrow.Position = UDim2.new(1,-6,0.5,0)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6034818372"
            arrow.ImageColor3 = P.text2
            arrow.ZIndex = 59

            -- Dropdown panel
            local panel = Frame(Library.ScreenGUI, {
                Color=P.bg0, Size=UDim2.new(0,1,0,0),
                ZIndex=300, Name="DropPanel"
            })
            panel.Visible = false
            Corner(panel, 2)
            Stroke(panel, P.border2, 1)

            local scroll = Instance.new("ScrollingFrame", panel)
            scroll.Size = UDim2.new(1,0,1,0)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.CanvasSize = UDim2.new(0,0,0,0)
            scroll.ScrollBarThickness = 2
            scroll.ScrollBarImageColor3 = P.accent
            scroll.ScrollingDirection = Enum.ScrollingDirection.Y
            scroll.TopImage=""; scroll.BottomImage=""
            scroll.ZIndex = 301

            local panelLayout = Instance.new("UIListLayout", scroll)
            panelLayout.SortOrder = Enum.SortOrder.LayoutOrder

            panelLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                scroll.CanvasSize = UDim2.new(0,0,0,panelLayout.AbsoluteContentSize.Y)
            end)

            local function openPanel()
                isOpen = true
                Library.DropdownOpen = true
                local btnPos = btn.AbsolutePosition
                local btnSz  = btn.AbsoluteSize
                local height = math.min(Count*26, 150)
                local screenH = Library.ScreenGUI.AbsoluteSize.Y
                local goUp = (btnPos.Y + btnSz.Y + height) > screenH - 10
                panel.Size = UDim2.new(0, btnSz.X, 0, 0)
                panel.Position = goUp
                    and UDim2.fromOffset(btnPos.X, btnPos.Y - height)
                    or  UDim2.fromOffset(btnPos.X, btnPos.Y + btnSz.Y + 2)
                panel.Visible = true
                Tween(panel, 0.15, {Size=UDim2.new(0,btnSz.X,0,height)})
                Tween(arrow, 0.15, {Rotation=180})
            end

            local function closePanel()
                isOpen = false
                Library.DropdownOpen = false
                Tween(panel, 0.12, {Size=UDim2.new(0,btn.AbsoluteSize.X,0,0)})
                Tween(arrow, 0.12, {Rotation=0})
                task.delay(0.14, function() panel.Visible = false end)
            end

            btn.MouseButton1Click:Connect(function()
                if isOpen then closePanel() else openPanel() end
            end)

            UIS.InputBegan:Connect(function(inp)
                if not isOpen then return end
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    local pos = inp.Position
                    local pp,ps = panel.AbsolutePosition, panel.AbsoluteSize
                    local bp,bs = btn.AbsolutePosition, btn.AbsoluteSize
                    if not (pos.X>=pp.X and pos.X<=pp.X+ps.X and pos.Y>=pp.Y and pos.Y<=pp.Y+ps.Y) and
                       not (pos.X>=bp.X and pos.X<=bp.X+bs.X and pos.Y>=bp.Y and pos.Y<=bp.Y+bs.Y) then
                        closePanel()
                    end
                end
            end)

            local function handleClick(option, optBtn, txt)
                optBtn.MouseButton1Click:Connect(function()
                    if Dropdown.Max then
                        if table.find(Chosen, option) then
                            table.remove(Chosen, table.find(Chosen,option))
                            txt.TextColor3 = P.text2
                        else
                            if #Chosen==Dropdown.Max then table.remove(Chosen,1) end
                            table.insert(Chosen, option)
                            txt.TextColor3 = P.text0
                        end
                        local joined = {}
                        for _,o in next,Chosen do table.insert(joined,o) end
                        selLbl.Text = #Chosen==0 and "" or table.concat(joined,", ")
                        Library.Flags[Dropdown.Flag] = Chosen
                        Dropdown.Callback(Chosen)
                    else
                        for opt,t in next,Dropdown.OptionInsts do
                            t.lbl.TextColor3 = P.text2
                        end
                        Chosen = option
                        selLbl.Text = option
                        txt.TextColor3 = P.accent
                        Library.Flags[Dropdown.Flag] = option
                        Dropdown.Callback(option)
                        closePanel()
                    end
                end)
            end

            local function createOptions(tbl)
                for _,option in next,tbl do
                    Dropdown.OptionInsts[option] = {}
                    local optRow = Instance.new("TextButton", scroll)
                    optRow.Size = UDim2.new(1,0,0,26)
                    optRow.BackgroundColor3 = P.bg0
                    optRow.BackgroundTransparency = 1
                    optRow.BorderSizePixel = 0
                    optRow.Text = ""
                    optRow.AutoButtonColor = false
                    optRow.ZIndex = 302

                    local optBg = Frame(optRow, {Color=P.bg3, Transparency=1, ZIndex=302})
                    local optLbl = Label(optRow, {
                        Text=option, Color=P.text2, Size=11,
                        Position=UDim2.new(0,10,0,0), Frame=UDim2.new(1,-14,1,0),
                        ZIndex=303, Clip=true
                    })
                    optLbl.Font = Enum.Font.Gotham

                    -- Dot for selected state
                    local dot = Frame(optRow, {
                        Color=P.accent, Size=UDim2.new(0,4,0,4),
                        Position=UDim2.new(0,4,0.5,-2), Transparency=1, ZIndex=303
                    })
                    Corner(dot, 2)
                    table.insert(Library.ThemeObjects, dot)

                    optRow.MouseEnter:Connect(function() Tween(optBg,0.08,{BackgroundTransparency=0.88}) end)
                    optRow.MouseLeave:Connect(function() Tween(optBg,0.08,{BackgroundTransparency=1}) end)

                    Dropdown.OptionInsts[option] = {btn=optRow, lbl=optLbl, dot=dot}
                    Count += 1
                    handleClick(option, optRow, optLbl)
                end
            end
            createOptions(Dropdown.Options)

            local function set(option)
                if Dropdown.Max then
                    table.clear(Chosen)
                    option = type(option)=="table" and option or {}
                    for opt,t in next,Dropdown.OptionInsts do t.lbl.TextColor3=P.text2 end
                    for _,opt in next,option do
                        if table.find(Dropdown.Options,opt) and #Chosen<Dropdown.Max then
                            table.insert(Chosen,opt)
                            Dropdown.OptionInsts[opt].lbl.TextColor3 = P.text0
                        end
                    end
                    local j={}; for _,o in next,Chosen do table.insert(j,o) end
                    selLbl.Text = #Chosen==0 and "" or table.concat(j,", ")
                    Library.Flags[Dropdown.Flag]=Chosen; Dropdown.Callback(Chosen)
                end
            end

            function Dropdown:Set(option)
                if Dropdown.Max then set(option)
                else
                    for opt,t in next,Dropdown.OptionInsts do t.lbl.TextColor3=P.text2 end
                    if table.find(Dropdown.Options,option) then
                        Chosen=option; selLbl.Text=option
                        Dropdown.OptionInsts[option].lbl.TextColor3=P.accent
                        Library.Flags[Dropdown.Flag]=option; Dropdown.Callback(option)
                    else
                        Chosen=nil; selLbl.Text=""
                        Library.Flags[Dropdown.Flag]=nil; Dropdown.Callback(nil)
                    end
                end
            end

            function Dropdown:Refresh(tbl)
                Count=0
                for _,t in next,Dropdown.OptionInsts do pcall(function() t.btn:Destroy() end) end
                table.clear(Dropdown.OptionInsts)
                createOptions(tbl)
                Chosen=Dropdown.Max and {} or nil
                selLbl.Text=""
                Library.Flags[Dropdown.Flag]=Chosen; Dropdown.Callback(Chosen)
            end

            if Dropdown.Max then Flags[Dropdown.Flag]=set else Flags[Dropdown.Flag]=Dropdown end
            Dropdown:Set(Dropdown.State)
            return Dropdown
        end

        -- ── COLORPICKER ──────────────────────────────────────
        function Sections:Colorpicker(Properties)
            Properties = Properties or {}
            local Colorpicker = {
                Name     = Properties.Name or "Color",
                State    = Properties.state or Properties.State or Properties.default or Color3.fromRGB(255,0,0),
                Callback = Properties.callback or Properties.Callback or function() end,
                Flag     = Properties.flag or Properties.Flag or Library.NextFlag(),
                Colorpickers = 0,
            }

            local parent = self.Elements.SectionContent
            local row = Instance.new("TextButton", parent)
            row.Size = UDim2.new(1,0,0,22)
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.ZIndex = 57

            local lbl = Label(row, {
                Text=Properties.Name or "Color", Color=P.text1, Size=11,
                Position=UDim2.new(0,2,0,0), Frame=UDim2.new(1,-52,1,0),
                ZIndex=58, Clip=true
            })
            lbl.Font = Enum.Font.Gotham

            Colorpicker.Colorpickers += 1
            local _, picker = Library:NewPicker(
                Colorpicker.Name, Colorpicker.State, row,
                Colorpicker.Colorpickers, Colorpicker.Flag, Colorpicker.Callback
            )

            function Colorpicker:Set(c) Flags[Colorpicker.Flag] and Flags[Colorpicker.Flag](c) end

            function Colorpicker:Colorpicker(P2)
                P2 = P2 or {}
                local NC = {
                    State    = P2.state or P2.State or P2.default or Color3.fromRGB(255,0,0),
                    Callback = P2.callback or P2.Callback or function() end,
                    Flag     = P2.flag or P2.Flag or Library.NextFlag(),
                }
                Colorpicker.Colorpickers += 1
                Library:NewPicker("", NC.State, row, Colorpicker.Colorpickers, NC.Flag, NC.Callback)
                function NC:Set(c) Flags[NC.Flag] and Flags[NC.Flag](c) end
                return NC
            end
            return Colorpicker
        end

        -- ── KEYBIND ──────────────────────────────────────────
        function Sections:Keybind(Properties)
            Properties = Properties or {}
            local Keybind = {
                Name     = Properties.Name or Properties.name or "Keybind",
                State    = Properties.state or Properties.State or Properties.default or Enum.KeyCode.E,
                Mode     = Properties.mode or Properties.Mode or "Toggle",
                UseKey   = Properties.UseKey or false,
                Callback = Properties.callback or Properties.Callback or function() end,
                Flag     = Properties.flag or Properties.Flag or Library.NextFlag(),
                Binding  = nil,
            }
            local Key, State, c = nil, false, nil

            local parent = self.Elements.SectionContent
            local row = Instance.new("TextButton", parent)
            row.Size = UDim2.new(1,0,0,22)
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.ZIndex = 57

            local rowBg = Frame(row, {Color=P.bg3, Transparency=1, ZIndex=57})
            Corner(rowBg, 2)

            local lbl = Label(row, {
                Text=Keybind.Name, Color=P.text1, Size=11,
                Position=UDim2.new(0,2,0,0), Frame=UDim2.new(1,-85,1,0),
                ZIndex=58, Clip=true
            })
            lbl.Font = Enum.Font.Gotham

            -- Key badge
            local keyBg = Frame(row, {
                Color=P.bg3, Size=UDim2.new(0,70,0,16),
                Position=UDim2.new(1,-72,0.5,-8), ZIndex=58
            })
            Corner(keyBg, 2)
            Stroke(keyBg, P.border, 1)

            local keyLbl = Label(keyBg, {
                Text="NONE", Color=P.text2, Size=10,
                Frame=UDim2.new(1,0,1,0), AlignX=Enum.TextXAlignment.Center,
                ZIndex=59
            })
            keyLbl.Font = Enum.Font.GothamBold

            row.MouseEnter:Connect(function() Tween(rowBg,0.1,{BackgroundTransparency=0.88}) end)
            row.MouseLeave:Connect(function() Tween(rowBg,0.1,{BackgroundTransparency=1}) end)

            local function set(newkey)
                if string.find(tostring(newkey),"Enum") then
                    if c then c:Disconnect() end
                    if tostring(newkey):find("Enum.KeyCode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.","")]
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.","")]
                    end
                    if newkey == Enum.KeyCode.Backspace then
                        Key = nil
                        keyLbl.Text = "NONE"
                        if Keybind.UseKey then Library.Flags[Keybind.Flag]=Key; Keybind.Callback(Key) end
                    elseif newkey then
                        Key = newkey
                        keyLbl.Text = Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.",""):upper()
                        if Keybind.UseKey then Library.Flags[Keybind.Flag]=Key; Keybind.Callback(Key) end
                    end
                    Library.Flags[Keybind.Flag.."_KEY"] = newkey
                elseif table.find({"Always","Toggle","Hold"}, newkey) then
                    if not Keybind.UseKey then
                        Keybind.Mode = newkey
                        Library.Flags[Keybind.Flag.."_KEY STATE"] = newkey
                        if Keybind.Mode=="Always" then
                            State=true; Library.Flags[Keybind.Flag]=true; Keybind.Callback(true)
                        end
                    end
                else
                    State=newkey; Library.Flags[Keybind.Flag]=newkey; Keybind.Callback(newkey)
                end
            end

            set(Keybind.State); set(Keybind.Mode)

            row.MouseButton1Click:Connect(function()
                if Keybind.Binding then return end
                keyLbl.Text = "..."
                keyLbl.TextColor3 = P.accent
                Keybind.Binding = Library:Connection(UIS.InputBegan, function(inp, gpe)
                    if gpe then return end
                    if inp.UserInputType==Enum.UserInputType.Touch then return end
                    set(inp.UserInputType==Enum.UserInputType.Keyboard and inp.KeyCode or inp.UserInputType)
                    Library:Disconnect(Keybind.Binding)
                    task.wait()
                    Keybind.Binding = nil
                    keyLbl.TextColor3 = P.text2
                end)
            end)

            Library:Connection(UIS.InputBegan, function(inp, gpe)
                if gpe then return end
                if (inp.KeyCode==Key or inp.UserInputType==Key) and not Keybind.Binding and not Keybind.UseKey then
                    if Keybind.Mode=="Hold" then
                        Library.Flags[Keybind.Flag]=true
                        c = Library:Connection(game:GetService("RunService").RenderStepped, function()
                            Keybind.Callback(true)
                        end)
                    elseif Keybind.Mode=="Toggle" then
                        State = not State
                        Library.Flags[Keybind.Flag]=State; Keybind.Callback(State)
                    end
                end
            end)

            Library:Connection(UIS.InputEnded, function(inp, gpe)
                if gpe then return end
                if Keybind.Mode=="Hold" and not Keybind.UseKey then
                    if inp.KeyCode==Key or inp.UserInputType==Key then
                        if c then c:Disconnect() end
                        Library.Flags[Keybind.Flag]=false; Keybind.Callback(false)
                    end
                end
            end)

            Library.Flags[Keybind.Flag.."_KEY"] = Keybind.State
            Library.Flags[Keybind.Flag.."_KEY STATE"] = Keybind.Mode
            Flags[Keybind.Flag] = set
            Flags[Keybind.Flag.."_KEY"] = set
            Flags[Keybind.Flag.."_KEY STATE"] = set
            function Keybind:Set(k) set(k) end
            return Keybind
        end

        -- ── TEXTBOX ──────────────────────────────────────────
        function Sections:Textbox(Properties)
            Properties = Properties or {}
            local Textbox = {
                Placeholder = Properties.placeholder or Properties.Placeholder or "Type here...",
                State       = Properties.state or Properties.State or Properties.default or "",
                Callback    = Properties.callback or Properties.Callback or function() end,
                Flag        = Properties.flag or Properties.Flag or Library.NextFlag(),
            }

            local hasLabel = Properties.Name and Properties.Name ~= ""
            local parent = self.Elements.SectionContent

            local container = Frame(parent, {
                Color=P.bg1, Transparency=1,
                Size=UDim2.new(1,0,0, hasLabel and 44 or 26),
                ZIndex=57
            })

            if hasLabel then
                local lbl = Label(container, {
                    Text=Properties.Name, Color=P.text1, Size=11,
                    Position=UDim2.new(0,0,0,0), Frame=UDim2.new(1,0,0,18),
                    ZIndex=58
                })
                lbl.Font = Enum.Font.Gotham
            end

            local inputBg = Frame(container, {
                Color=P.bg3,
                Position=UDim2.new(0,0,0,hasLabel and 20 or 0),
                Size=UDim2.new(1,0,0,24), ZIndex=58
            })
            Corner(inputBg, 2)
            local inputStroke = Stroke(inputBg, P.border, 1)

            local input = Instance.new("TextBox", inputBg)
            input.Size = UDim2.new(1,-16,1,0)
            input.Position = UDim2.new(0,8,0,0)
            input.BackgroundTransparency = 1
            input.BorderSizePixel = 0
            input.Text = Textbox.State
            input.PlaceholderText = Textbox.Placeholder
            input.PlaceholderColor3 = P.text2
            input.TextColor3 = P.text0
            input.Font = Enum.Font.Gotham
            input.TextSize = 11
            input.TextXAlignment = Enum.TextXAlignment.Left
            input.ClearTextOnFocus = false
            input.ZIndex = 59
            input.TextTruncate = Enum.TextTruncate.SplitWord

            input.Focused:Connect(function() Tween(inputStroke,0.15,{Color=P.accent}) end)
            input.FocusLost:Connect(function(enter)
                Tween(inputStroke,0.15,{Color=P.border})
                if enter then
                    Textbox.Callback(input.Text)
                    Library.Flags[Textbox.Flag] = input.Text
                end
            end)

            local function set(str)
                str = tostring(str or "")
                input.Text = str
                Library.Flags[Textbox.Flag] = str
                Textbox.Callback(str)
            end

            Flags[Textbox.Flag] = set
            Library.Flags[Textbox.Flag] = Textbox.State
            return Textbox
        end

        -- ── BUTTON ───────────────────────────────────────────
        function Sections:Button(Properties)
            Properties = Properties or {}
            local Button = {
                Name     = Properties.Name or "Button",
                Callback = Properties.callback or Properties.Callback or function() end,
            }

            local parent = self.Elements.SectionContent
            local btn = Instance.new("TextButton", parent)
            btn.Size = UDim2.new(1,0,0,26)
            btn.BackgroundColor3 = P.bg3
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ZIndex = 57
            Corner(btn, 2)
            local btnStroke = Stroke(btn, P.border, 1)

            -- Inner shimmer
            local shimmer = Frame(btn, {Color=P.white, Transparency=1, ZIndex=58})
            Corner(shimmer, 2)

            -- Accent left strip (subtle)
            local strip = Frame(btn, {
                Color=P.accent, Size=UDim2.new(0,2,1,0), ZIndex=58, Transparency=0
            })
            table.insert(Library.ThemeObjects, strip)

            local lbl = Label(btn, {
                Text=Properties.Name, Color=P.text0, Size=11,
                Position=UDim2.new(0,10,0,0), Frame=UDim2.new(1,-12,1,0),
                ZIndex=59
            })
            lbl.Font = Enum.Font.GothamBold

            btn.MouseEnter:Connect(function()
                Tween(btnStroke,0.12,{Color=P.border2})
                Tween(shimmer,0.12,{BackgroundTransparency=0.95})
            end)
            btn.MouseLeave:Connect(function()
                Tween(btnStroke,0.12,{Color=P.border})
                Tween(shimmer,0.12,{BackgroundTransparency=1})
            end)
            btn.MouseButton1Down:Connect(function()
                Button.Callback()
                Tween(shimmer,0.06,{BackgroundTransparency=0.88})
                Tween(lbl,0.06,{TextColor3=P.white})
                task.delay(0.15, function()
                    Tween(shimmer,0.15,{BackgroundTransparency=1})
                    Tween(lbl,0.15,{TextColor3=P.text0})
                end)
            end)
        end

        -- ── WATERMARK ────────────────────────────────────────
        function Library:Watermark(Properties)
            Properties = Properties or {}
            local WM = { Name = Properties.Name or Properties.name or "" }

            local frame = Frame(Library.ScreenGUI, {
                Color=P.bg0, Size=UDim2.new(0,0,0,24),
                Position=UDim2.new(1,-10,0,10),
                ZIndex=150, Name="Watermark"
            })
            frame.AnchorPoint = Vector2.new(1,0)
            frame.AutomaticSize = Enum.AutomaticSize.X
            frame.Visible = false
            Corner(frame, 2)
            Stroke(frame, P.border, 1)

            -- Accent strip
            local strip = Frame(frame, {Color=P.accent, Size=UDim2.new(0,2,1,0), ZIndex=151})
            table.insert(Library.ThemeObjects, strip)

            local lbl = Label(frame, {
                Text=WM.Name, Color=P.text0, Size=11,
                Position=UDim2.new(0,10,0,0),
                Frame=UDim2.new(0,0,1,0), ZIndex=151
            })
            lbl.Font = Enum.Font.GothamBold
            lbl.AutomaticSize = Enum.AutomaticSize.X

            local pad = Instance.new("UIPadding", frame)
            pad.PaddingRight = UDim.new(0,8)

            function WM:UpdateText(t) WM.Name=t; lbl.Text=t end
            function WM:SetVisible(v) frame.Visible=v end
            return WM
        end
    end
end

local library = Library
return library
