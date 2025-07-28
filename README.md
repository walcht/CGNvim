# About

!!WORK IN PROGRESS PROJECT!!

CGNvim is a simple and modern **Neovim >= 0.11** configuration for game and computer
graphics development environment (e.g., Unity game engine, C++ game development,
development using low-level graphics API etc.).

## Features

This configuration tries to provide a *minimal* set of plugins to approximate
the usual game/graphics IDEs (e.g., Visual Studio).

- [X] LSP completion/hints and linting support for: C# (Roslyn LS), C/C++ (clangd),
      Lua (lua-language-server), GLSL (glsl-analyzer). LSP is implemented using Neovim's >= 0.11 core LSP module.
- [X] Detailed guide for integration with the Unity game engine
- [X] Fast and lightweight default configuration
- [X] Syntax highlighting using [nvim-treesitter][nvim-treesitter] for: C#, C/C++, GLSL, HLSL, XML, YAML, etc.
- [X] Formatting (and autoformatting on save) for: C# (csharpier), Lua (stylua), C++
- [X] Integrated terminal using [toggleterm.nvim][toggleterm] (togglable using: `<Space>tt`)
- [X] Mnemonic keymaps that make sense (e.g., `<Space>tt` for (t)oggle (t)erminal)
- [X] Lazy Neovim plugin management (i.e., plugins are only loaded when needed)
- [X] 3rd party LSPs/formatters/DAPs are automatically handled by [mason.nvim][mason] using [lazy.nvim][lazynvim]
- [X] Clear project structure that is highly customizable and easily extendable:
    - To add/edit a plugin, see [Adding or Editing Plugins](#adding-or-editing-plugins)
    - To add/edit a LSP, see [Adding or Editing LSPs](#adding-or-editing-lsps)
    - To add/edit a formatter, see [Adding or Editing Formatters](#adding-or-editing-formatters)

## Unity Game Engine

For integration with the Unity game engine see this detailed guide:
[neovim-unity][neovim-unity]

## Project Structure

```
.
├── init.lua                    --> loads the config: require("cgnvim")
├── LICENSE.txt
├── lua
│   └── cgnvim
│       ├── configs             --> configuration for plugins (maps 1-to-1 with ./plugins/)
│       │   ├── bufferline.lua
│       │   ├── ...
│       │   └── trouble.lua
│       ├── gautocmds.lua       --> set of non-plugin-specific ```vim.api.nvim_create_autocmd``` autocmd calls
│       ├── gmappings.lua       --> set of non-plugin-specific mappings
│       ├── gsettings.lua       --> set of non-buffer-specific settings and options (vim.opt & vim.g)
│       ├── gusercmds.lua       --> set of non-plugin-specific ```vim.api.nvim_create_user_command``` user commands
│       ├── init.lua            --> bootstraps LazyNvim plugin manager and loads
│       ├── lspconfig.lua       --> default LSP configuration + LSPs are enabled/disabled here
│       ├── lsps                --> LSPs are configured here
│       │   ├── clangd.lua
│       │   ├── ...
│       │   └── roslyn_ls.lua
│       └── plugins             --> plugins to be managed by LazyNvim are added here
│           ├── bufferline.lua
│           ├── ...
│           └── trouble.lua
├── README.md
└── stylua.toml                 --> for lua formatting using StyLua
```

```lua/cgnvim/plugins/``` and ```lua/cgnvim/configs/``` have a one-to-one
association where each file in ```lua/cgnvim/plugins/``` denotes a plugin name
(usually `<plugin-name>.lua`) and describes how it should be fetched and loaded
by the LazeNvim plugin manager. The options passed to its LSP setup are defined
in a file of similar name in ```lua/cgnvim/configs/```.

Each entry in ```lua/cgnvim/lsps/``` denotes a specific LSP configuration that
is usually copied from [nvim-lspconfig/lsp][nvim-lspconfig-lsps]
and is loaded and enabled in ```lua/cgnvim/lspconfig.lua```.

## Keymaps Overview

To list all the defined and default keymaps, enter the command `:map`. CGNvim
tries to simplify the memorization of keymaps by relying on mnemonics.

The main keymaps that contribute the most at simplifying the usual workflow are
(`<leader>` is `<Space>` unless you have changed the default configuration):

| Keymap        | Short Description                          | Detailed Description                                                                                                                                                                                                          |
| ------------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<leader>tt`  | (t)oggle (t)erminal                        | toggle the integrated terminal                                                                                                                                                                                                |
| `<leader>ex`  | toggle file (ex)plorer                     | toggle the NvimTree file explorer                                                                                                                                                                                             |
| `<leader>rs`  | (r)ename (s)ymbol                          | rename symbol under the cursor and all of its references using LSP                                                                                                                                                            |
| `<leader>rw`  | (r)ename (w)ord                            | rename all occurences of the word under the cursor in current buffer                                                                                                                                                          |    
| `<leader>ts`  | (t)oggle (s)pell                           | toggle spell checking for current buffer                                                                                                                                                                                      |    
| `<leader>ss`  | (s)pell (s)uggest                          | show Telescope's spell suggestion for the word under the cursor                                                                                                                                                               |
| `<leader>tr`  | (t)oggle (r)elative line numbering         | toggle relative line numbering (default: off)                                                                                                                                                                                 |
| `<leader>tih` | (t)oggle (i)nlay (h)ints                   | toggle LSP inlay hints. E.g., uses virtual text to show parameter names)                                                                                                                                                      |
| `<leader>tvt` | (t)oggle (v)irtual (t)ext diagnostics      | toggle LSP virtual text diagnostics. Shows diagnostics at the right of the corresponding line using virtual text                                                                                                              |
| `<leader>tvl` | (t)oggle (v)irtual (l)ines diagnostics     | toggle virtual lines diagnostics. Uses multiple virtual lines under the corresponding line to show diagnostics. Better than virtual text diagnostics but consumes more visual space (i.e., adds a lot of lines on hover).     |
| `K`           | show LSP (K)ownledge                       | LSP hover information about symbol under cursor                                                                                                                                                                               |
| `KK`          | (K)indly jump to LSP (K)ownledge           | jumps to LSP hover information window about symbol under cursor                                                                                                                                                               |
| `<leader>bd`  | (b)uffer (d)iagnostics                     | toggle Trouble's buffer (local) diagnostics window                                                                                                                                                                            |
| `<leader>gd`  | (g)lobal (d)iagnostics                     | toggle Trouble's global diagnostics window                                                                                                                                                                                    |
| `<leader>ql`  | (q)uickfix (l)ist                          | toggle Trouble's quickfix list window                                                                                                                                                                                         |

## Potential LSP Issues

Getting a LSP to work properly (especially in the case of C# with Unity) can be
a daunting task. I have spent a significant amount of time tinkering with
different LSPs for C# on Linux. Omnisharp is simply not usable, any mid-sized
Unity projects can cause memory consumption of up-to 20GBs or more (very
probably due to a severe memory leakage problem).

The relatively new Roslyn Language Server seems to perform better, but there
are a couple of caveats that one has to be aware of.

### C# LSP (Roslyn Language Server)

In case you get ```System.IO.IOException: The configured user limit (128) on
the number of inotify instances has been reached.``` in the LSP log (accessible
in the filesystem at ```:lua =require('vim.lsp.log').get_filename()```) then
you have to increase the maximum number of file descriptors that can be opened
by a process:

```bash
echo fs.inotify.max_user_instances=4096 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

In case you get `Undefined reference` warnings/errors in the LSP log, you have
to run dotnet restore in your solution/project root directory:

```bash
dotnet restore "<unity-project-name>.sln"
```

It is important to note that LSPs can be quite verbose and a lot of errors and
warnings can be safely ignored. This is the case with Roslyn LS, a lot of
`Unresolved references` can be simply ignored (hence why its logger level is set
to ERROR).

## Adding or Editing Plugins

Plugins are managed by [lazy.nvim][lazynvim] and are automatically loaded
from ```lua/cgnvim/plugins/``` where each file corresponds to a plugin.

To add a new plugin:

1. create a new lua file at ```lua/cgnvim/plugins/<plugin-name>.lua``` and
add the LazyNvim configuration for it. For example:

    ```lua
    return {
      "<plugin-github-repo>/<plugin-name>.nvim",
      lazy = false,
      version = "*",
      -- plugin's setup options are loaded from a file of similar name in lua/cgnvim/configs/
      -- this makes plugin configurations that are frequently changed in a single
      -- convenient location
      opts = function()
        return require("cgnvim.configs.<plugin-name>")
      end,
      ...,  -- other LazyNvim configurations
    }
    ```

2. for a consistent configuration, create a new lua file (with same name as
in ```lua/cgnvim/plugins/```) at ```lua/cgnvim/configs/<plugin-name>.lua```
and define your plugin setup options there:

    ```lua
    return {
      -- here goes plugin setup options
    }
    ```

3. restart Neovim and check the command `:Lazy` to see if your plugin has
successfully been added

## Adding or Editing LSPs

LSPs are enabled in ```lua/cgnvim/lspconfig.lua``` and their configurations
live in ```lua/cgnvim/lsps/```.

To add a new LSP, say a LSP for Python files (e.g., ruff):

1. navigate to ```lua/cgnvim/lspconfig.lua``` then add the following 2 lines:

    ```lua
    -- Python LSP (comment both lines to disable)
    vim.lsp.config("ruff", require("cgnvim.lsps.ruff"))
    vim.lsp.enable("ruff")
    ```

    `vim.lsp.enable("<lsp-name>")` allows you to enable/disable the LSP
    configuration for `<lsp-name>`. Check `:LspInfo` for active LSPs and enabled
    configurations.

2. create a new lua file under the path ```lua/cgnvim/lsps/ruff.lua``` and
define the LSP client configuration in it as follows (it is usually copied
from: [nvim-lspconfig/lsps][nvim-lspconfig-lsps]):

    ```lua
    return {
        -- LSP client configuration following: https://neovim.io/doc/user/lsp.html#vim.lsp.ClientConfig
        -- you usually copy this configuration from https://github.com/neovim/nvim-lspconfig/tree/master/lsp
        -- and adjust it accordingly (e.g., by changing the LSP cmd)
        cmd = { "ruff" },
        filetypes = { "py" },
        root_markers = { ".git" }
        -- etc ...
    ```

3. (optionally) for automatic installation and management of your LSP by Mason,
if it is available in Mason (check command `:Mason`), then navigate to
`lua/cgnvim/configs/mason-tool-installer.lua`:

    ```lua
    -- a list of all tools you want to ensure are installed upon start by Mason
    ensure_installed = {
      ...,  -- other lsps/formatters/linters
      { "ruff", auto_update = true },
    }
    ```

4. restart Neovim and open a file that can trigger the LSP (in this example, 
a Python file). Check `:LspInfo` to see if your LSP configuration is there
and a LSP client is successfully attached. Check `:LspLog` for LSP logs.

## Adding or Editing Formatters

Formatting is managed by the [conform.nvim][conform] plugin
in addition to [mason-tool-installer.nvim][mason-tool-installer] for automatic
installation by [mason.nvim][mason].

To add a new formatter, say a formatter (e.g., `prettierd`) for Javascript files:

1. navigate to `lua/cgnvim/configs/conform.lua` and add the formatter
to *formatters\_by\_ft*:

    ```lua
    -- add new formatters here (also add them in ./mason-tool-installer.lua for automatic installation by Mason)
    formatters_by_ft = {
      ...,  -- other formatters
      javascript = { "prettierd", stop_after_first = true },
    },
    ```

    Here we are assuming the command `prettierd` is globally accessible (see next point)


2. (optionally) for automatic installation and management of your formatter by
Mason, if it is listed in Mason (check command `:Mason`), then navigate to
`lua/cgnvim/configs/mason-tool-installer.lua` and add it as an entry in *ensure\_installed*:

    ```lua
    -- a list of all tools you want to ensure are installed upon start by Mason
    ensure_installed = {
      ...,  -- other lsps/formatters/linters
      { "prettierd", auto_update = true },
    }
    ```

3. restart Neovim. Check `:ConformInfo` and see if your formatter is ready. Otherwise
check `:Mason` to see if your formatter is installed.
Try  to open a file with the right extension and format it (either by
format on write using `:w`, or using `:lua require("conform").format({ async = true }))`


## TODOs

- [ ] Add general DAP support (CRUCIAL)
- [ ] Add proper Unity debugging support (CRUCIAL)
- [ ] Add Godot game engine integration (IMPORTANT)
- [ ] Add Unreal Engine integration (IMPORTANT)
- [ ] Support large files (usually JSON files that are too large completely
crash Neovim because of treesitter and/or LSP)
    - [X] Disable Treesitter for large files (e.g., >= 128KBs)
    - [ ] Disable LSP for large files (e.g., 32KBs)
- [ ] Add script for the generation of single-page PDF overview of keymaps
(IMPORTANT)
- [ ] Add Yaml highlighting and formatting support (IMPORTANT)
- [ ] Add snippets completion (OPTIONAL)
- [ ] Add a minimal spell checker (OPTIONAL)

## License

MIT License. Read `license.txt` file.

[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[toggleterm]: https://github.com/akinsho/toggleterm.nvim
[mason]: https://github.com/mason-org/mason.nvim
[lazynvim]: https://github.com/folke/lazy.nvim
[neovim-unity]: https://github.com/walcht/neovim-unity
[nvim-lspconfig-lsps]: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
[conform]: https://github.com/stevearc/conform.nvim/tree/master
[mason-tool-installer]: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
