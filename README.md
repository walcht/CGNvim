# About

**CGNvim** is a simple and modern **Neovim >= 0.11** configuration for game and
computer graphics development environment (e.g., Unity game engine or C++ game
development/graphics, development using low-level graphics API).

Since this configuration is highly modular, you can simply see how certain
functionalities are done (e.g., Roslyn LS C# LSP) and simply copy and integrate
their config into you own Neovim config.

## Features

This configuration tries to provide a *minimal* set of plugins to approximate
the usual game/graphics IDEs (e.g., Visual Studio).

- [X] LSP completion/hints and linting support for: C# (Roslyn LS), C/C++ (clangd),
      Lua (lua-language-server), GLSL (glsl-analyzer). LSP is implemented using Neovim's >= 0.11 core LSP module.
- [X] Detailed guide for integration with the Unity game engine
- [X] Fast and lightweight default configuration
- [X] Syntax highlighting using [nvim-treesitter][nvim-treesitter] for: C#, C/C++, GLSL, HLSL, XML, YAML, etc.
- [X] Formatting (and autoformatting on save) using [conform.nvim][conform] for: C# (csharpier), Lua (stylua), C++, etc.
- [X] Integrated terminal using [toggleterm.nvim][toggleterm] (togglable using: `<Space>tt`)
- [X] Git integration using [gitsigns.nvim][gitsigns]
- [X] Mnemonic keymaps that make sense (e.g., `<Space>tt` for (t)oggle (t)erminal)
- [X] Lazy Neovim plugin management (i.e., plugins are only loaded when needed)
- [X] 3rd party LSPs/formatters/DAPs are automatically handled by [mason.nvim][mason] using [lazy.nvim][lazynvim]
- [X] Clear project structure that is highly customizable and easily extensible:
    - To add/edit a plugin, see [Adding or Editing Plugins](#adding-or-editing-plugins)
    - To add/edit a LSP, see [Adding or Editing LSPs](#adding-or-editing-lsps)
    - To add/edit a formatter, see [Adding or Editing Formatters](#adding-or-editing-formatters)
    - To add/edit a DAP, see [Adding or Editing DAPs](#adding-or-editing-daps)
- [X] Debugging support using [nvim-dap][nvim-dap] with sensible default configurations for: C/C++ (codelldb),
      Python (debugpy), C# (Unity)
- [X] Attaching to the Unity debugger to debug editor/player instances (see [neovim-unity][neovim-unity] for details)

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
│       ├── configs             --> configs for plugins (maps 1-to-1 with ./plugins/)
│       │   ├── bufferline.lua
│       │   ├── ...
│       │   └── trouble.lua
│       ├── daps                --> DAPs are added/configured here
│       │   ├── python.lua
│       │   ├── ...
│       │   └── unity.lua
│       ├── gautocmds.lua       --> set of non-plugin-specific autocmd calls
│       ├── gmappings.lua       --> set of non-plugin-specific mappings
│       ├── gsettings.lua       --> set of non-buffer-specific settings and options
│       ├── gusercmds.lua       --> set of non-plugin-specific user commands
│       ├── init.lua            --> lsps setup, daps setups, lazynvim bootstrapping
│       ├── lsps                --> LSPs are added/configured here
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

[<u>lua/cgnvim/plugins/</u>](lua/cgnvim/plugins/) and [<u>lua/cgnvim/configs/</u>](lua/cgnvim/configs/) have a one-to-one
association where each file in [<u>lua/cgnvim/plugins/</u>](lua/cgnvim/plugins/) denotes a plugin name
(usually `<plugin-name>.lua`) and describes how it should be fetched and loaded
by the LazeNvim plugin manager. The options passed to its LSP setup are defined
in a file of similar name in [<u>lua/cgnvim/configs/</u>](lua/cgnvim/configs/).

Each entry in [<u>lua/cgnvim/lsps/</u>](lua/cgnvim/lsps/) denotes a specific LSP configuration that
is usually copied from [nvim-lspconfig/lsp][nvim-lspconfig-lsps]
and is loaded and enabled in [<u>lua/cgnvim/lspconfig.lua</u>](lua/cgnvim/lspconfig.lua).

## Default Keymaps Overview

Most commently used keymaps are listed in a cheatsheet that is automatically
updated in the [releases page][]. Maybe print it out (using a laser printer ;-))
and keep it nearby (that's what I do - because I constantly forget keymaps).

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
from [<u>lua/cgnvim/plugins/</u>](lua/cgnvim/plugins/) where each file corresponds to a plugin.

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
in [<u>lua/cgnvim/plugins/</u>](lua/cgnvim/plugins/)) at ```lua/cgnvim/configs/<plugin-name>.lua```
and define your plugin setup options there:

    ```lua
    return {
      -- here goes plugin setup options
    }
    ```

3. restart Neovim and check the command `:Lazy` to see if your plugin has
successfully been added

## Adding or Editing LSPs

LSPs are enabled in [<u>lua/cgnvim/init.lua</u>](lua/cgnvim/init.lua) and their configurations
live in [<u>lua/cgnvim/lsps/</u>](lua/cgnvim/lsps/)

To add a new LSP, say a LSP for Python files (e.g., ruff):

1. create a new lua file under the path [<u>lua/cgnvim/lsps/ruff.lua</u>](lua/cgnvim/lsps/ruff.lua) and
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
    }
    ```

2. (optionally) for automatic installation and management of your LSP by Mason,
if it is available in Mason (check command `:Mason`), then navigate to
[<u>lua/cgnvim/configs/mason-tool-installer.lua</u>](lua/cgnvim/configs/mason-tool-installer.lua):

    ```lua
    -- a list of all tools you want to ensure are installed upon start by Mason
    ensure_installed = {
      ...,  -- other lsps/formatters/linters
      { "ruff", auto_update = true },
    }
    ```

3. restart Neovim and open a file that can trigger the LSP (in this example, 
a Python file). Check `:LspInfo` to see if your LSP configuration is there
and a LSP client is successfully attached. Check `:LspLog` for LSP logs.


## Removing or Disabling LSPs

To remove a LSP, navigate to [<u>lua/cgnvim/lsps/</u>](lua/cgnvim/lsps/) and remove the
corresponding LSP entry. Navigate to [<u>lua/cgnvim/configs/mason-tool-installer.lua</u>](lua/cgnvim/configs/mason-tool-installer.lua)
and remove the plugin from ```ensure_installed``` table in case it is there.


To disable a LSP without removing its configuration, navigate to [<u>lua/cgnvim/init.lua</u>](lua/cgnvim/init.lua)
then add the lsp name (same as in [<u>lua/cgnvim/lsps/</u>](lua/cgnvim/lsps/) but without the lua extension) to
the ```lsp_ignore``` table.


## Adding or Editing Formatters

Formatting is managed by the [conform.nvim][conform] plugin
in addition to [mason-tool-installer.nvim][mason-tool-installer] for automatic
installation by [mason.nvim][mason].

To add a new formatter, say a formatter (e.g., `prettierd`) for Javascript files:

1. navigate to [<u>lua/cgnvim/configs/conform.lua</u>](lua/cgnvim/configs/conform.lua)
   and add the formatter to `formatters_by_ft`:

    ```lua
    -- add new formatters here (also add them in ./mason-tool-installer.lua for automatic installation by Mason)
    formatters_by_ft = {
      ...,  -- other formatters
      javascript = { "prettierd", stop_after_first = true },
    },
    ```

    Here we are assuming the command `prettierd` is globally accessible (see next point)


3. (optionally) for automatic installation and management of your formatter by
Mason, if it is listed in Mason (check command `:Mason`), then navigate to
[<u>lua/cgnvim/configs/mason-tool-installer.lua</u>](lua/cgnvim/configs/mason-tool-installer.lua)
and add it as an entry in `ensure_installed`:

    ```lua
    -- a list of all tools you want to ensure are installed upon start by Mason
    ensure_installed = {
      ...,  -- other lsps/formatters/linters
      { "prettierd", auto_update = true },
    }
    ```

5. restart Neovim. Check `:ConformInfo` and see if your formatter is ready. Otherwise
check `:Mason` to see if your formatter is installed.
Try  to open a file with the right extension and format it (either by
format on write using `:w`, or using `:lua require("conform").format({ async = true }))`


## Adding or Editing DAs

Debug adapters (DA)s are enabled in [<u>lua/cgnvim/init.lua</u>](lua/cgnvim/init.lua) and their configurations
live in [<u>lua/cgnvim/daps/</u>](lua/cgnvim/daps/).

To add a new DA, say a DA for javascript/Firefox:

1. install the DA and the debugger (both may reside in the same executable).
In this case, the debugger is already integrated within Firefox. You just have to
install the DA (e.g., [vscode-firefox-debug][vscode-firefox-debug]).

2. create a new lua file under the path ```lua/cgnvim/lsps/firefox.lua``` and
define the DA configuration in it as follows (it is usually copied
and adjusted from: [nvim-dap configs][nvim-dap-configs]):

    ```lua
    local dap = require('dap')
    dap.adapters.firefox = {
      type = 'executable',
      command = 'node',  -- command to launch the DA
      -- path to the DA node package (and other optional args)
      args = {os.getenv('HOME') .. '/path/to/vscode-firefox-debug/dist/adapter.bundle.js'},
    }

    -- make sure not to override other typescript DAP configs
    if dap.configurations.python == nil then
      dap.configurations.python = {}
    end
    
    -- do NOT overwrite the Language configuration as multiple DAs may add multiple configurations for the same
    -- ft (e.g., Chrome debug adapter may already have an entry in the table dap.configurations.typescript)
    table.insert(dap.configurations.typescript, {  
      -- mandatory options expected by nvim-dap
      name = 'Debug with Firefox',
      type = 'firefox',
      request = 'launch',

      -- options below are debug-adapter specific
      reAttach = true,
      url = 'http://localhost:3000',
      webRoot = '${workspaceFolder}',
      -- adjust Firefox path accordingly if necessary
      firefoxExecutable = '/usr/bin/firefox'
    })
    ```

3. (optionally) for automatic installation and management of your DA by Mason,
if it is available in Mason (check command `:Mason`), then navigate to
[<u>lua/cgnvim/configs/mason-tool-installer.lua</u>](lua/cgnvim/configs/mason-tool-installer.lua)

    ```lua
    -- a list of all tools you want to ensure are installed upon start by Mason
    ensure_installed = {
      ...,  -- other lsps/formatters/linters
      { "<your-da-name>", auto_update = true },
    }
    ```
    
    in the case of vscode-firefox-debug, it is not available in Mason (at least
    officially) and has to be installed manually.

4. restart Neovim and start debugging a Javascript file. Check the `:DapShowLog`
command output for any potential issues.


## TODOs

- [ ] Support large files (usually JSON files that are too large completely
crash Neovim because of treesitter and/or LSP)
    - [ ] Disable Treesitter for large files (e.g., >= 128KBs)
    - [ ] Disable LSP for large files (e.g., 32KBs)
- [ ] Add script for the generation of single-page PDF overview of keymaps
(IMPORTANT)
- [ ] Add Yaml highlighting and formatting support (IMPORTANT)
- [ ] Add snippets completion (OPTIONAL)
- [ ] Add a minimal spell checker (OPTIONAL)
- [ ] Add OpenGL completion (from https://github.com/vurentjie/cmp-gl)

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
[gitsigns]: https://github.com/lewis6991/gitsigns.nvim
[diffview]: https://github.com/sindrets/diffview.nvim
[nvim-dap-configs]: https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
[vscode-firefox-debug]: https://github.com/firefox-devtools/vscode-firefox-debug
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
