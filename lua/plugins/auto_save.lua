return {
  "Pocco81/auto-save.nvim",
  event = "VeryLazy",
  config = function()
    require("auto-save").setup({
      enabled = true,
      execution_message = {
        message = function() -- message to print on save
          return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
        dim = 0.18, -- dim the color of `message`
        cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
      },
      trigger_events = { -- See :h events
        immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
        defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
      },
      -- function that determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- don't save if file is not writable
        if fn.getbufvar(buf, "&readonly") then
          return false
        end

        -- don't save if file type is in the blacklist
        local filetype = fn.getbufvar(buf, "&filetype")
        local blacklist = { "gitcommit", "gitrebase", "svn", "hgcommit" }
        if vim.tbl_contains(blacklist, filetype) then
          return false
        end

        -- don't save if file is in the blacklist
        local filename = fn.bufname(buf)
        local blacklist_patterns = { "COMMIT_EDITMSG", "MERGE_MSG", "PULLREQ_EDITMSG", "TAG_EDITMSG" }
        for _, pattern in ipairs(blacklist_patterns) do
          if string.match(filename, pattern) then
            return false
          end
        end

        return true
      end,
      write_all_buffers = false, -- write all buffers when the current one meets `condition`
      debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
      callbacks = { -- functions to be executed at different intervals
        enabling = nil, -- ran when enabling auto-save
        disabling = nil, -- ran when disabling auto-save
        before_asserting_save = nil, -- ran before checking `condition`
        before_saving = nil, -- ran before doing the actual save
        after_saving = nil, -- ran after doing the actual save
      },
    })
  end,
}