# About

CGNvim is a **Neovim >= 0.11** configuration for computer graphics development
(e.g., Unity game engine, C++ game development, development using low-level
graphics API etc.).

## Unity Game Engine

For integration with the Unity game engine see: [neovim-unity](https://github.com/walcht/neovim-unity)

## Godot

TODO

## 

## Potential LSP Issues

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

## TODOs

- [ ] Add propert Unity debugging support
- [ ] Add Godot game engine integration
- [ ] Add Unreal Engine integratio

## License

MIT License. Read `license.txt` file.
