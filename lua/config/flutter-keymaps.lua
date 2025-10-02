-- Flutter Development Keymaps
-- Register mappings only when a Dart/Flutter context is active to avoid race conditions

local map = vim.keymap.set

-- Safely execute a Flutter command, ensuring flutter-tools is loaded
local function exec_flutter(cmd)
  if vim.fn.exists(":" .. cmd) == 0 then
    pcall(require, "flutter-tools")
  end
  if vim.fn.exists(":" .. cmd) == 0 then
    vim.notify("Flutter command not available: " .. cmd, vim.log.levels.WARN)
    return
  end
  vim.cmd(cmd)
end

local function set_flutter_maps(buf)
  local opts = { buffer = buf, silent = true }
  -- Clear conflicting mappings in this buffer to avoid DAP/LazyVim collisions
  pcall(vim.keymap.del, "n", "<leader>fd", { buffer = buf })
  pcall(vim.keymap.del, "n", "<leader>fdb", { buffer = buf })
  pcall(vim.keymap.del, "n", "<leader>fdt", { buffer = buf })
  map("n", "<leader>fh", function() exec_flutter("FlutterHotReload") end, vim.tbl_extend("force", opts, { desc = "Flutter Hot Reload" }))
  map("n", "<leader>fH", function() exec_flutter("FlutterHotRestart") end, vim.tbl_extend("force", opts, { desc = "Flutter Hot Restart" }))
  map("n", "<leader>fr", function() exec_flutter("FlutterRun") end, vim.tbl_extend("force", opts, { desc = "Flutter Run" }))
  map("n", "<leader>fq", function() exec_flutter("FlutterQuit") end, vim.tbl_extend("force", opts, { desc = "Flutter Quit" }))
  map(
    "n",
    "<leader>fd",
    function()
      exec_flutter("FlutterDevices")
    end,
    vim.tbl_extend("force", { noremap = true }, opts, { desc = "Flutter Devices" })
  )
  map("n", "<leader>fe", function() exec_flutter("FlutterEmulators") end, vim.tbl_extend("force", opts, { desc = "Flutter Emulators" }))
  map("n", "<leader>ft", function() exec_flutter("FlutterTest") end, vim.tbl_extend("force", opts, { desc = "Flutter Test" }))
  map("n", "<leader>fb", function() exec_flutter("FlutterBuildApk") end, vim.tbl_extend("force", opts, { desc = "Flutter Build APK" }))
  map("n", "<leader>fB", function() exec_flutter("FlutterBuildIos") end, vim.tbl_extend("force", opts, { desc = "Flutter Build iOS" }))
  map("n", "<leader>fw", function() exec_flutter("FlutterBuildWeb") end, vim.tbl_extend("force", opts, { desc = "Flutter Build Web" }))
  map("n", "<leader>fc", function() exec_flutter("FlutterClean") end, vim.tbl_extend("force", opts, { desc = "Flutter Clean" }))
  map("n", "<leader>fp", function() exec_flutter("FlutterPubGet") end, vim.tbl_extend("force", opts, { desc = "Flutter Pub Get" }))
  map("n", "<leader>fP", function() exec_flutter("FlutterPubUpgrade") end, vim.tbl_extend("force", opts, { desc = "Flutter Pub Upgrade" }))
  map("n", "<leader>fo", function() exec_flutter("FlutterOutlineToggle") end, vim.tbl_extend("force", opts, { desc = "Flutter Outline" }))
  map("n", "<leader>fl", function() exec_flutter("FlutterLogClear") end, vim.tbl_extend("force", opts, { desc = "Flutter Log Clear" }))
  map("n", "<leader>fD", function() exec_flutter("FlutterDoctor") end, vim.tbl_extend("force", opts, { desc = "Flutter Doctor" }))
  map("n", "<leader>fu", function() exec_flutter("FlutterUpgrade") end, vim.tbl_extend("force", opts, { desc = "Flutter Upgrade" }))
  map("n", "<leader>fch", function() exec_flutter("FlutterChannel") end, vim.tbl_extend("force", opts, { desc = "Flutter Channel" }))
  map("n", "<leader>fdb", function() exec_flutter("FlutterDebug") end, vim.tbl_extend("force", opts, { desc = "Flutter Debug" }))
  map("n", "<leader>fdt", function() exec_flutter("FlutterDebugToggle") end, vim.tbl_extend("force", opts, { desc = "Flutter Debug Toggle" }))
  map("n", "<leader>fdev", function() exec_flutter("FlutterOpenDevTools") end, vim.tbl_extend("force", opts, { desc = "Flutter Dev Tools" }))
  map("n", "<leader>fprof", function() exec_flutter("FlutterCopyProfilerUrl") end, vim.tbl_extend("force", opts, { desc = "Flutter Profiler URL" }))
  map("n", "<leader>ftc", function() exec_flutter("FlutterTestCoverage") end, vim.tbl_extend("force", opts, { desc = "Flutter Test Coverage" }))
  map("n", "<leader>fta", function() exec_flutter("FlutterTestAll") end, vim.tbl_extend("force", opts, { desc = "Flutter Test All" }))
  map("n", "<leader>fW", function() exec_flutter("FlutterBuildWindows") end, vim.tbl_extend("force", opts, { desc = "Flutter Build Windows" }))
  map("n", "<leader>fL", function() exec_flutter("FlutterBuildLinux") end, vim.tbl_extend("force", opts, { desc = "Flutter Build Linux" }))
  map("n", "<leader>fM", function() exec_flutter("FlutterBuildMacos") end, vim.tbl_extend("force", opts, { desc = "Flutter Build macOS" }))
end

-- Attach flutter maps when editing Dart files (ensures LSP/plugins ready and prevents early overrides)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dart" },
  callback = function(ev)
    set_flutter_maps(ev.buf)
    -- Register which-key hints for flutter under <leader>f in Dart buffers
    local ok, wk = pcall(require, "which-key")
    if ok and wk then
      wk.register({
        ["<leader>f"] = {
          name = "+flutter",
          h = { "<cmd>FlutterHotReload<cr>", "Hot Reload" },
          H = { "<cmd>FlutterHotRestart<cr>", "Hot Restart" },
          r = { "<cmd>FlutterRun<cr>", "Run" },
          q = { "<cmd>FlutterQuit<cr>", "Quit" },
          d = { "<cmd>FlutterDevices<cr>", "Devices" },
          e = { "<cmd>FlutterEmulators<cr>", "Emulators" },
          t = { "<cmd>FlutterTest<cr>", "Test" },
          b = { "<cmd>FlutterBuildApk<cr>", "Build APK" },
          B = { "<cmd>FlutterBuildIos<cr>", "Build iOS" },
          w = { "<cmd>FlutterBuildWeb<cr>", "Build Web" },
          W = { "<cmd>FlutterBuildWindows<cr>", "Build Windows" },
          L = { "<cmd>FlutterBuildLinux<cr>", "Build Linux" },
          M = { "<cmd>FlutterBuildMacos<cr>", "Build macOS" },
          c = { "<cmd>FlutterClean<cr>", "Clean" },
          p = { "<cmd>FlutterPubGet<cr>", "Pub Get" },
          P = { "<cmd>FlutterPubUpgrade<cr>", "Pub Upgrade" },
          o = { "<cmd>FlutterOutlineToggle<cr>", "Outline" },
          l = { "<cmd>FlutterLogClear<cr>", "Log Clear" },
          D = { "<cmd>FlutterDoctor<cr>", "Doctor" },
          u = { "<cmd>FlutterUpgrade<cr>", "Upgrade" },
          ["ch"] = { "<cmd>FlutterChannel<cr>", "Channel" },
          ["db"] = { "<cmd>FlutterDebug<cr>", "Debug" },
          ["dt"] = { "<cmd>FlutterDebugToggle<cr>", "Debug Toggle" },
          ["dev"] = { "<cmd>FlutterOpenDevTools<cr>", "DevTools" },
          ["prof"] = { "<cmd>FlutterCopyProfilerUrl<cr>", "Profiler URL" },
          ["tc"] = { "<cmd>FlutterTestCoverage<cr>", "Test Coverage" },
          ["ta"] = { "<cmd>FlutterTestAll<cr>", "Test All" },
        },
      }, { buffer = ev.buf })
    end
  end,
})

-- Register which-key groups for better organization
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    local wk = require("which-key")
    if wk then
      -- Register Flutter keymap groups
      wk.register({
        ["<leader>f"] = { name = "+flutter", icon = " " },
        ["<leader>m"] = { name = "+dart", icon = " " },
      })
    end
  end,
})

-- Alternative: Register keymaps when Flutter tools are available
vim.api.nvim_create_autocmd("User", {
  pattern = "FlutterToolsStarted",
  callback = function()
    local wk = require("which-key")
    if wk then
      wk.register({
        ["<leader>m"] = { name = "+dart", icon = " " },
        ["<leader>md"] = { "<cmd>FlutterDevices<cr>", "Flutter Devices (Run)" },
        ["<leader>mm"] = { "<cmd>FlutterRun<cr>", "Flutter Run" },
        ["<leader>mo"] = { "<cmd>FlutterOutlineToggle<cr>", "Flutter Outline" },
        ["<leader>mq"] = { "<cmd>FlutterQuit<cr>", "Flutter Quit" },
        ["<leader>mr"] = { "<cmd>FlutterRestart<cr>", "Flutter Restart" },
        ["<leader>mp"] = { "<cmd>FlutterPubGet<cr>", "Flutter Pub Get" },
        ["<leader>mP"] = { "<cmd>FlutterPubUpgrade<cr>", "Flutter Pub Upgrade" },
        ["<leader>ml"] = { "<cmd>FlutterLogClear<cr>", "Flutter Log Clear" },
        ["<leader>me"] = { "<cmd>FlutterEmulators<cr>", "Emulators" },
        ["<leader>mc"] = { "<cmd>FlutterOpenDevTools<cr><cmd>FlutterCopyProfilerUrl<cr>", "Open Devtools & Copy Profiler Url" },
        ["<leader>mh"] = { "<cmd>FlutterHotReload<cr>", "Hot Reload" },
        ["<leader>mH"] = { "<cmd>FlutterHotRestart<cr>", "Hot Restart" },
        ["<leader>mt"] = { "<cmd>FlutterTest<cr>", "Run Tests" },
        ["<leader>mT"] = { "<cmd>FlutterTestCoverage<cr>", "Test Coverage" },
        ["<leader>mta"] = { "<cmd>FlutterTestAll<cr>", "Run All Tests" },
        ["<leader>mb"] = { "<cmd>FlutterBuildApk<cr>", "Build APK" },
        ["<leader>mB"] = { "<cmd>FlutterBuildIos<cr>", "Build iOS" },
        ["<leader>mw"] = { "<cmd>FlutterBuildWeb<cr>", "Build Web" },
        ["<leader>mW"] = { "<cmd>FlutterBuildWindows<cr>", "Build Windows" },
        ["<leader>mL"] = { "<cmd>FlutterBuildLinux<cr>", "Build Linux" },
        ["<leader>mM"] = { "<cmd>FlutterBuildMacos<cr>", "Build macOS" },
        ["<leader>mD"] = { "<cmd>FlutterDebug<cr>", "Start Debugging" },
        ["<leader>mdd"] = { "<cmd>FlutterDebugToggle<cr>", "Toggle Debug Mode" },
        ["<leader>mC"] = { "<cmd>FlutterClean<cr>", "Flutter Clean" },
        ["<leader>mdo"] = { "<cmd>FlutterDoctor<cr>", "Flutter Doctor" },
        ["<leader>mup"] = { "<cmd>FlutterUpgrade<cr>", "Flutter Upgrade" },
        ["<leader>mch"] = { "<cmd>FlutterChannel<cr>", "Flutter Channel" },
      })
    end
  end,
})
