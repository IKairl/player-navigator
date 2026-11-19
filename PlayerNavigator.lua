local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Destroys existing.
pcall(function()
    local old = PlayerGui:FindFirstChild("PlayerNavigator")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerNavigator"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

local function make(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local COLORS = {
    background = Color3.fromRGB(18, 19, 22),
    panel = Color3.fromRGB(27, 29, 34),
    panel2 = Color3.fromRGB(35, 37, 43),
    border = Color3.fromRGB(55, 58, 66),
    text = Color3.fromRGB(242, 243, 245),
    muted = Color3.fromRGB(155, 160, 170),
    accent = Color3.fromRGB(190, 205, 255),
    accentText = Color3.fromRGB(22, 27, 42),
    danger = Color3.fromRGB(255, 130, 130)
}

local function corner(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 12)}, parent)
end

local function stroke(parent, color, thickness)
    make("UIStroke", {
        Color = color or COLORS.border,
        Thickness = thickness or 1,
        Transparency = 0.15
    }, parent)
end

local Main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(0.88, 0, 0.68, 0),
    BackgroundColor3 = COLORS.background,
    BorderSizePixel = 0
}, ScreenGui)
Main.ClipsDescendants = true
corner(Main, 16)
stroke(Main, COLORS.border, 1)

local sizeConstraint = make("UISizeConstraint", {
    MinSize = Vector2.new(270, 300),
    MaxSize = Vector2.new(470, 560)
}, Main)

local Header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 54),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0
}, Main)

local Title = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 16, 0, 0),
    Size = UDim2.new(1, -100, 1, 0),
    Font = Enum.Font.GothamSemibold,
    Text = "Player Navigator",
    TextColor3 = COLORS.text,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

local Minimize = make("TextButton", {
    Name = "Minimize",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = COLORS.panel2,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "—",
    TextColor3 = COLORS.text,
    TextSize = 18,
    AutoButtonColor = true
}, Header)
corner(Minimize, 10)

local Content = make("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 66),
    Size = UDim2.new(1, -24, 1, -78)
}, Main)

local Search = make("TextBox", {
    Name = "Search",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    PlaceholderText = "Search players...",
    PlaceholderColor3 = COLORS.muted,
    Text = "",
    TextColor3 = COLORS.text,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)
corner(Search, 10)
stroke(Search)

make("UIPadding", {
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12)
}, Search)

local Refresh = make("TextButton", {
    Name = "Refresh",
    Position = UDim2.new(1, -86, 0, 52),
    Size = UDim2.new(0, 86, 0, 34),
    BackgroundColor3 = COLORS.panel2,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamMedium,
    Text = "Refresh",
    TextColor3 = COLORS.text,
    TextSize = 12
}, Content)
corner(Refresh, 9)
stroke(Refresh)

local Count = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 52),
    Size = UDim2.new(1, -96, 0, 34),
    Font = Enum.Font.Gotham,
    Text = "Players in server",
    TextColor3 = COLORS.muted,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

local List = make("ScrollingFrame", {
    Name = "PlayerList",
    Position = UDim2.new(0, 0, 0, 94),
    Size = UDim2.new(1, 0, 1, -164),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = COLORS.muted,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, Content)
corner(List, 10)
stroke(List)

local ListLayout = make("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, List)

make("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
}, List)

local SelectedLabel = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, -62),
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Selected: nobody",
    TextColor3 = COLORS.muted,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd
}, Content)

local Teleport = make("TextButton", {
    Name = "Teleport",
    Position = UDim2.new(0, 0, 1, -36),
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = COLORS.accent,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamSemibold,
    Text = "Teleport to selected player",
    TextColor3 = COLORS.accentText,
    TextSize = 13
}, Content)
corner(Teleport, 10)

local Status = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, 2),
    Size = UDim2.new(1, 0, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "Ready",
    TextColor3 = COLORS.muted,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

local Toggle = make("TextButton", {
    Name = "Reopen",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -18, 1, -18),
    Size = UDim2.fromOffset(48, 48),
    BackgroundColor3 = COLORS.accent,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "PN",
    TextColor3 = COLORS.accentText,
    TextSize = 14,
    Visible = false
}, ScreenGui)
corner(Toggle, 16)
stroke(Toggle, COLORS.border)

local selectedPlayer = nil
local playerButtons = {}

local function setStatus(message, isError)
    Status.Text = message
    Status.TextColor3 = isError and COLORS.danger or COLORS.muted
end

local function clearRows()
    for _, child in ipairs(List:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    table.clear(playerButtons)
end

local function selectPlayer(player)
    selectedPlayer = player
    if player then
        SelectedLabel.Text = "Selected: " .. player.DisplayName .. "  (@" .. player.Name .. ")"
        setStatus("Selected " .. player.Name, false)
    else
        SelectedLabel.Text = "Selected: nobody"
    end
    for target, button in pairs(playerButtons) do
        button.BackgroundColor3 = target == selectedPlayer and COLORS.accent or COLORS.panel2
        button.TextColor3 = target == selectedPlayer and COLORS.accentText or COLORS.text
    end
end

local function refreshPlayers()
    clearRows()
    local query = string.lower(Search.Text or "")
    local allPlayers = Players:GetPlayers()
    local shown = 0

    table.sort(allPlayers, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)

    for _, player in ipairs(allPlayers) do
        local matches = query == ""
            or string.find(string.lower(player.Name), query, 1, true)
            or string.find(string.lower(player.DisplayName), query, 1, true)

        if matches then
            shown += 1
            local label = player.DisplayName
            if player.DisplayName ~= player.Name then
                label = label .. "  @" .. player.Name
            end
            if player == LocalPlayer then
                label = label .. "  (You)"
            end

            local button = make("TextButton", {
                Name = "Player_" .. player.UserId,
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = player == selectedPlayer and COLORS.accent or COLORS.panel2,
                BorderSizePixel = 0,
                Font = Enum.Font.GothamMedium,
                Text = label,
                TextColor3 = player == selectedPlayer and COLORS.accentText or COLORS.text,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                AutoButtonColor = true
            }, List)
            corner(button, 9)
            playerButtons[player] = button
            button.Activated:Connect(function()
                selectPlayer(player)
            end)
        end
    end

    Count.Text = tostring(shown) .. " / " .. tostring(#allPlayers) .. " players"
    if shown == 0 then
        setStatus("No matching players", false)
    end
end

Search:GetPropertyChangedSignal("Text"):Connect(refreshPlayers)
Refresh.Activated:Connect(refreshPlayers)

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function(player)
    if selectedPlayer == player then
        selectPlayer(nil)
    end
    refreshPlayers()
end)

Teleport.Activated:Connect(function()
    if not selectedPlayer then
        setStatus("Select a player first", true)
        return
    end
    if selectedPlayer == LocalPlayer then
        setStatus("You are already that player", true)
        return
    end
    if not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        setStatus("That player's character is not available", true)
        return
    end

    local remote = ReplicatedStorage:FindFirstChild("PlayerNavigatorRemote")
    if remote and remote:IsA("RemoteFunction") then
        setStatus("Requesting server teleport...", false)
        local ok, result = pcall(function()
            return remote:InvokeServer(selectedPlayer.UserId)
        end)
        if ok then
            setStatus(tostring(result or "Teleport request sent"), false)
        else
            setStatus("Server teleport request failed", true)
        end
        return
    end

    -- Local-only fallback for testing. Server-authoritative games may reject it.
    local character = LocalPlayer.Character
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if character and character:FindFirstChild("HumanoidRootPart") and targetRoot then
        local ok = pcall(function()
            character:PivotTo(targetRoot.CFrame * CFrame.new(3, 0, 0))
        end)
        if ok then
            setStatus("Local teleport attempted; server may undo it", false)
        else
            setStatus("Local teleport failed", true)
        end
    else
        setStatus("Your character is not available", true)
    end
end)

Minimize.Activated:Connect(function()
    Main.Visible = false
    Toggle.Visible = true
end)

Toggle.Activated:Connect(function()
    Main.Visible = true
    Toggle.Visible = false
end)

-- Touch and mouse dragging, initiated from the header.
local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
        dragInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

refreshPlayers()
setStatus("Ready. Select a player.", false)
