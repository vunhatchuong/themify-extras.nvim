# themify-extras.nvim

A [themify.nvim](https://github.com/LmanTW/themify.nvim) plugin that provides extra features.

## Features

- [x] Randomize theme.
- [x] Change theme based on day or night.

## Installation

### lazy.nvim

```lua
{
    "vunhatchuong/themify-extras.nvim",
    dependencies = { "lmantw/themify.nvim" },
    opts = {},
}
```

## Configuration

These are the default values, you can view it directly in [config.lua](./lua/themify-extras/config.lua).

```lua
{
    randomize = {
        enable = false, -- Uses `:RandomizeTheme`
        daily = false, -- Randomize theme everyday
    },
    daylight = {
        enable = false,
        day_start = 8,
        night_start = 16,
    },
}
```
