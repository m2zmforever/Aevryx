# AevryxLib – UI Library

First, thanks to [slf0Dev](https://github.com/slf0Dev) for providing the main code for the UI Library with the old Ocerium_Project.

---

## Installation

```lua
local AevryxLib = loadstring(game:HttpGet("YOUR_RAW_URL_HERE.lua"))()
```

Replace `YOUR_RAW_URL_HERE` with your hosted or GitHub raw URL.

---

## Quick Start

```lua
-- Configure theme first
AevryxLib.Theme.AccentColor = Color3.fromRGB(0, 175, 255)
AevryxLib.Theme.HideKey = "LeftControl"

local Main = AevryxLib.Main("Aevryx", 600, 450)

local MainTab = Main.Tab("Main")
local Section = MainTab.Section("General")

Section.Button("Print Hello", function()
    print("Hello from AevryxLib!")
end)

Section.Checkbox("Auto Farm", function(enabled)
    print("Auto Farm:", enabled)
end, false)

Section.Slider("Speed", 16, 100, function(value)
    print("Speed set to", value)
end, false, 16)

Main.Notification("Loaded", "UI initialized successfully.")
```

---

## Theming

Set properties on `AevryxLib.Theme` **before** calling `AevryxLib.Main`.

```lua
AevryxLib.Theme.Font = "RobotoMono"
AevryxLib.Theme.AccentColor = Color3.fromRGB(60, 60, 60)
AevryxLib.Theme.FontColor = Color3.fromRGB(255, 255, 255)
AevryxLib.Theme.HideKey = "LeftControl"
```

### Theme Properties

| Property      | Type        | Description                          | Default                  |
|---------------|-------------|--------------------------------------|--------------------------|
| `Font`        | string      | Roblox font name                     | `"RobotoMono"`           |
| `AccentColor` | Color3      | Highlight / accent color             | `Color3.fromRGB(60,60,60)` |
| `FontColor`   | Color3      | Primary text color                   | white                    |
| `HideKey`     | string      | Key to toggle UI visibility          | `"LeftControl"`          |

**Supported `HideKey` values**: Any `Enum.KeyCode` or `Enum.UserInputType` name (e.g. `"F"`, `"LeftShift"`, `"MouseButton2"`, `"LeftAlt"`).

---

## API Reference

### `AevryxLib.Main(Name, Width, Height)`

Creates the main draggable window (with fancy loading screen + animated particles).

**Parameters**
- `Name` (string): Window title shown in topbar
- `Width` (number): Topbar width (pixels, UDim2 offset)
- `Height` (number): Content container height (pixels)

**Returns**: `InMain` object

**Behavior**
- Automatically destroys any previous UI named `AevryxLib`
- Topbar is draggable
- Supports many tabs via built-in pagination

---

### `InMain` Object

Returned by `AevryxLib.Main`.

#### `InMain.Tab(Text)`

Creates a new tab page.

**Parameters**
- `Text` (string): Tab button label

**Returns**: `InPage` object

**Behavior**
- Tabs are shown horizontally in the topbar
- When >6 tabs exist, automatic `‹` / `›` pagination arrows appear

#### `InMain.Notification(HeaderText, Text)`

Displays a right-side notification that auto-dismisses after 4 seconds.

**Parameters**
- `HeaderText` (string)
- `Text` (string)

Multiple notifications stack vertically with smooth slide animations.

---

### `InPage` Object

Returned by `InMain.Tab`.

#### `InPage.Section(Text)`

Creates a section card inside the tab.

**Parameters**
- `Text` (string): Section header

**Returns**: `InSection` object

**Important Layout Note**
Tabs use a **two-column** layout. Sections are automatically placed in the column that currently has the least vertical content for balanced appearance.

---

### `InSection` Object

Returned by `InPage.Section`. All elements below live inside a section.

#### `InSection.Button(Text, Callback)`

**Parameters**
- `Text` (string)
- `Callback` (function)

**Returns**: The button instance (for advanced use)

#### `InSection.TextLabel(Text)`

Static text.

**Parameters**
- `Text` (string)

#### `InSection.TextBox(Placeholder, Callback, DefaultValue?)`

**Parameters**
- `Placeholder` (string)
- `Callback` (function(value))
- `DefaultValue` (string, optional)

Focus styling uses the theme accent color.

#### `InSection.Checkbox(Text, Callback, DefaultValue?)`

**Parameters**
- `Text` (string)
- `Callback` (function(boolean))
- `DefaultValue` (boolean, optional) — default `false`

#### `InSection.Slider(Text, Min, Max, Callback, Precise, DefaultValue?)`

**Parameters**
- `Text` (string)
- `Min`, `Max` (number)
- `Callback` (function(value))
- `Precise` (boolean): `true` = 1 decimal place, `false` = integer
- `DefaultValue` (number, optional)

#### `InSection.KeyBind(Text, Callback, DefaultKey?)`

**Parameters**
- `Text` (string)
- `Callback` (function(keyNameString))
- `DefaultKey` (string or EnumItem, optional)

Nice display names are used (LCtrl, RMB, ↑, F1, etc.).

#### `InSection.Dropdown(Text, Options, IndexType, Callback)`

**Parameters**
- `Text` (string): Label
- `Options` (table): e.g. `{["Pistol"] = 1, ["Rifle"] = 3}` or `{1,2,3}`
- `IndexType` (number):
  - `1` = keys are display names, values sent to callback
  - `2` = values are display names, keys sent to callback
- `Callback` (function(displayName, value))

**Returns**: `InDropdown` object

#### `InSection.MultiDropdown(Text, Options, IndexType, Callback)`

Multi-select version of Dropdown. Items show a ● when selected.

**Parameters**: Same as `Dropdown`

**Callback**: Fired on every toggle: `function(name, value)`

**Returns**: `InDropdown` (limited methods)

---

### InDropdown Methods (returned by Dropdown / MultiDropdown)

#### `Dropdown:Refresh(newOptions)`

Replaces all options at runtime.

#### `Dropdown:Set(selectionString)`

Programmatically selects an item (matches against display text or value).

#### `Dropdown:SetByIndex(index)`

Selects the nth option (1-based) from the **original** options table.

> Note: `Set` / `SetByIndex` are only available on single `Dropdown`, not `MultiDropdown`.

---

## UI Controls

- **Hide / Show**: Press the `Theme.HideKey` (default LeftControl). Includes a quick flash animation.
- **Auto Cleanup**: Creating a new UI destroys any old `AevryxLib` instance.
- **Drag**: Topbar is fully draggable; content follows.
- **Responsive**: Sections balance across two columns; tabs paginate automatically.

---
