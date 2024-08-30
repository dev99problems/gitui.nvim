# gitui.nvim

[Gitui](https://github.com/extrawurst/gitui) in your Neovim as terminal window.

## How it's different from the original?

Original [aspeddro/gitui.nvim](https://github.com/aspeddro/gitui.nvim) plugin had `.open()` method which would open `gitui` interface as terminal window, but would not provide a simple way to toggle it's visibility and switch between nvim and `gitui` back & force.

This implementation **deprecates** `.open()` method and **replaces** it with `.toggle()`
which hides current `gitui` window and reuses created buffer between invocations, 
instead of re-creating it every time **from scratch** (this let's preserve gitui interface state between toggles) and `.terminate()` method which would gracefully remove reusable `buffer` and `window`.

Because of it, all previosly selected items in different tabs, collapsed/expanded folders, searches, etc.
keep their state. 

https://github.com/user-attachments/assets/12a76daf-35de-4b11-9ed8-4c78aeada8d5

## Prerequisites

- Neovim >= 0.5.0
- [Gitui](https://github.com/extrawurst/gitui)

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use 'dev99problems/gitui.nvim'
```

## Setup

```lua
require("gitui").setup()
```

## Configuration (optional)

Following are the default config for the `setup()`. If you want to override, just modify the option that you want then it will be merged with the default config, like

```lua
require('gitui').setup({
  window = {
    options = {
      width = 95,
      height = 100,
      border = 'rounded'
    }
  },
})
```

**Default config**

```lua
{
  -- Command Options
  command = {
    -- Enable :Gitui command
    -- @type: bool
    enable = true,
  },
  -- Path to binary
  -- @type: string
  binary = "gitui",
  -- Argumens to gitui
  -- @type: table of string
  args = {},
  -- WIndow Options
  window = {
    options = {
      -- Width window in %
      -- @type: number
      width = 90,
      -- Height window in %
      -- @type: number
      height = 80,
      -- Border Style
      -- Enum: "none", "single", "rounded", "solid" or "shadow"
      -- @type: string
      border = "rounded",
    },
  },
}
```

## Lua API

```lua
require("gitui").toggle() -- toggles gitui window
-- and
require("gitui").terminate() -- removes cached buffer & window objects, usually should not be used manually
```

## Hotkeys

If you're using `.lua` files for `nvim` configurations, the possible hotkeys can be set like

```lua
-- ## gitui
keymap("n", "gui", ":lua require('gitui').toggle()<CR>", opts)
keymap("t", "gui", "<C-\\><C-n>:lua require('gitui').toggle()<CR>", opts)
```

**Important** this plugin does not set any hotkeys by default, so you can use provided example or 
set your own instead of `gui`, but please keep in mind setting `hotkey` for at least
`normal` and `terminal` modes to be able to show & hide gitui properly.
