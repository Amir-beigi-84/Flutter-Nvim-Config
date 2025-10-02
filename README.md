# Amir's LazyVim Neovim Setup

<p align="center">
  <a href="https://neovim.io">
    <img src="https://img.shields.io/badge/Neovim-0.9+-57A143?style=for-the-badge&amp;logo=neovim&amp;logoColor=white" alt="Neovim 0.9+ badge" />
  </a>
  <a href="https://lazyvim.org">
    <img src="https://img.shields.io/badge/Built%20with-LazyVim-1a1b26?style=for-the-badge&amp;logo=lazyvim&amp;color=1a1b26" alt="LazyVim badge" />
  </a>
  <a href="https://github.com/folke/lazy.nvim">
    <img src="https://img.shields.io/badge/Plugin%20Manager-lazy.nvim-cc0066?style=for-the-badge&amp;logo=lua&amp;logoColor=white" alt="lazy.nvim badge" />
  </a>
  <a href="https://www.lua.org">
    <img src="https://img.shields.io/badge/Language-Lua-00007d?style=for-the-badge&amp;logo=lua&amp;logoColor=white" alt="Lua badge" />
  </a>
  <a href="https://github.com/Amir-beigi-84/Flutter-Nvim-Config">
    <img src="https://img.shields.io/badge/Platforms-Linux%20%7C%20macOS%20%7C%20Windows-2b303b?style=for-the-badge&amp;logo=apple&amp;logoColor=white" alt="Cross platform badge" />
  </a>
  <a href="https://www.linkedin.com/in/amir-beigi-code/">
    <img src="https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&amp;logo=linkedin&amp;logoColor=white" alt="LinkedIn badge" />
  </a>
</p>

A cross-platform Neovim configuration centered around LazyVim, Dart/Flutter craftsmanship, and a curated set of quality-of-life tweaks. It bootstraps quickly with `lazy.nvim`, ships with thoughtful defaults for macOS, Linux, Windows, and WSL, and keeps the editing experience consistent whether you're in the terminal, Neovide, or VS Code.

## Highlights
- **Dart/Flutter power tools** - rich `flutter-tools.nvim` integration, log colorization, custom snippets, and an on-save pipeline that hoists imports, runs `source.organizeImports`, `source.fixAll`, and formats via `dartls`.
- **LazyVim foundation** - leverages LazyVim defaults plus extras for Rust, Python, Kotlin, TypeScript, OmniSharp, DAP tooling, tests, and smarter text objects.
- **Curated UI** - Themery-driven theme switcher with 12+ presets, Snacks dashboard art, tuned Bufferline indicators, and Neovide-specific polish.
- **Everyday ergonomics** - subword motions through `neowords.nvim`, better escape handling, auto-save with noise filtering, WakaTime tracking, quick math scratchpad, and log syntax highlighting.
- **Platform-aware** - picks the best shell per OS, bridges the WSL clipboard, honors per-project `.nvim.lua` via `exrc`, and has a slimmed-down profile for the VSCode Neovim extension.

## Getting Started
1. **Install prerequisites**
   - Neovim 0.9+
   - Git, `ripgrep`, and `fd` in your `$PATH`
   - Flutter SDK (or FVM) for Dart tooling
   - Optional: `sqlite3` DLL on Windows for Telescope history providers
2. **Clone the config**
   ```bash
   git clone git@github.com:Amir-beigi-84/Flutter-Nvim-Config.git ~/.config/nvim
   # Windows (PowerShell)
   git clone git@github.com:Amir-beigi-84/Flutter-Nvim-Config.git $env:LOCALAPPDATA\nvim
   ```
3. **Start Neovim** - the first launch will bootstrap `lazy.nvim`, install plugins, and compile the startup cache.
4. **Review health** - run `:checkhealth` and `:Lazy sync` after the initial bootstrap to verify dependencies.

## Layout
```text
~/.config/nvim/
|-- init.lua              # Minimal entry point that loads lazy.nvim
|-- lua/
|   |-- config/           # Options, keymaps, autocmds, lazy.nvim bootstrap
|   `-- plugins/          # Custom plugin specs layered on top of LazyVim
|-- lazy-lock.json        # Pinned plugin revisions (managed by lazy.nvim)
`-- stylua.toml           # Lua formatter settings
```

## Feature Tour
### Dart & Flutter Workflow
- `flutter-tools.nvim` exposes device, emulator, log, outline, pub, and devtools commands under `<leader>m*` (see `lua/plugins/flutter.lua`).
- `baleia.nvim` keeps `__FLUTTER_DEV_LOG__` buffers colorized for readability.
- `Luasnip` ships with authoring-focused snippets for stateless/stateful widgets (`stl`, `stf`).
- Custom `BufWritePre` automation (`lua/config/autocmds.lua`) hoists stray imports/exports, then chains organize-imports, fix-all, and formatting, failing gracefully if the file has diagnostics.
- `neotest-dart` plugs Dart tests into the standard LazyVim testing UX.

### Languages & LSP
- LazyVim extras bring batteries-included setups for Rust, Python, Kotlin, TypeScript, JSON, Markdown, and OmniSharp C#.
- `lspconfig` tweaks ship with SchemaStore-backed JSON validation and SourceKit root detection for Swift projects.
- Treesitter ensures parsers for Dart, C#, and modern JSON variants are always available, while disabling textobject selection for Dart to work around upstream performance issues.

### User Interface & Theming
- Themery provides instant theme switching with presets for Kanagawa, Tokyo Night Moon, Catppuccin Mocha, GitHub Dark, and more.
- Optional local theme switcher support (`lua/local_theme_switcher`) loads automatically when present, letting you script custom palettes.
- Snacks dashboard greets you with bespoke ASCII art; Bufferline's indicators are adjusted for a minimalist tab feel.
- Neovide gains Nerd Font defaults, blur, and opacity tweaks when `vim.g.neovide` is detected.

### Editing Experience
- `neowords.nvim` remaps `w/e/b/ge` to hop by subwords, punctuation, and hex colors, great for camelCase and snake_case.
- `better-escape.nvim` makes exiting insert mode with `jk` consistent.
- `auto-save.nvim` listens for buffer leaves, focus loss, and insert exits while skipping readonly buffers, VCS messages, and other noisy targets.
- WakaTime runs eagerly (`lazy = false`) so coding activity is always tracked.
- `log-highlight.nvim` highlights levels inside log files, and `quickmath.nvim` offers inline arithmetic.

### Cross-Platform Touches
- Shell detection picks PowerShell on Windows and zsh/bash on Unix; Windows setups automatically configure quoting flags.
- When running inside WSL with `clip.exe` available, yank operations mirror to the Windows clipboard.
- `.nvim.lua` files are opt-in per project (`vim.o.exrc = true`); `<leader>S` sources the local file on demand.
- Tab navigation is streamlined (`<Tab>`/`<S-Tab>`), `zz` folds everything except the current block, and `<leader>p` pastes over selections without clobbering the default register.

### VS Code & GUI
- Launching through the VSCode Neovim extension activates `lua/plugins/vscode.lua`, which narrows the plugin list and remaps core shortcuts to VS Code commands.
- GUI users get instant Neovide support; other GUIs honor the same settings through standard Neovim options.

## Live Widgets
Current repo metrics and profile links:

<p align="center">
  <a href="https://github.com/Amir-beigi-84/Flutter-Nvim-Config">
    <img src="https://img.shields.io/github/stars/Amir-beigi-84/Flutter-Nvim-Config?style=for-the-badge&amp;logo=github" alt="GitHub stars" />
  </a>
  <a href="https://github.com/Amir-beigi-84/Flutter-Nvim-Config/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/Amir-beigi-84/Flutter-Nvim-Config/ci.yml?branch=main&amp;style=for-the-badge&amp;label=CI" alt="CI status badge" />
  </a>
  <a href="https://github.com/Amir-beigi-84/Flutter-Nvim-Config/issues">
    <img src="https://img.shields.io/github/issues/Amir-beigi-84/Flutter-Nvim-Config?style=for-the-badge&amp;logo=github" alt="Open issues" />
  </a>
  <a href="https://github.com/Amir-beigi-84/Flutter-Nvim-Config/commits/main">
    <img src="https://img.shields.io/github/last-commit/Amir-beigi-84/Flutter-Nvim-Config?style=for-the-badge" alt="Last commit" />
  </a>
  <a href="https://www.linkedin.com/in/amir-beigi-code/">
    <img src="https://img.shields.io/badge/LinkedIn-Amir%20Beigi-0A66C2?style=for-the-badge&amp;logo=linkedin&amp;logoColor=white" alt="LinkedIn profile" />
  </a>
</p>

Optional extras you can add later:
- A `docs/` folder with dashboard screenshots referenced via standard Markdown: `![Lazy dashboard](docs/dashboard.png)`.
- A pinned gist of key mappings or an asciinema session recorded with `asciinema rec`.

## Theme Switching Cheatsheet
- Run `:Themery` or `:Themery random` to pick a palette.
- Themes are stored in `lua/plugins/themery.lua`; add new options by appending to the `themes` table.
- Current selection persists to `lua/themery_current.lua` so restarts keep your choice.

## Maintenance
- Update plugins: `:Lazy sync`
- Inspect plugin status: `:Lazy`
- Format Lua modules: `stylua .`
- Regenerate `lazy-lock.json`: `:Lazy lock`

## Credits
Built on top of [LazyVim](https://lazyvim.org/), LazyVim extras, and a hand-picked selection of plugins maintained by their respective authors. Huge thanks to the Neovim community.
