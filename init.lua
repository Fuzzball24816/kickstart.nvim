-- Vim Options --
vim.g.mapleader = " "
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.foldenable = false
vim.opt.foldmethod = "indent"
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.updatetime = 250

-- lazy.nvim init --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Keymaps (non-plugin) --
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

vim.keymap.set("i", "jj", "<Esc>", { desc = "Quick leave insert mode" })
vim.keymap.set({ "i", "x", "n", "s" }, "<c-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

vim.keymap.set("n", "<c-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<c-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<c-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<c-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<a-j>", "<c-w>J", { desc = "Move window to bottom" })
vim.keymap.set("n", "<a-h>", "<c-w>H", { desc = "Move window to left" })
vim.keymap.set("n", "<a-l>", "<c-w>L", { desc = "Move window to right" })
vim.keymap.set("n", "<a-k>", "<c-w>K", { desc = "Move window to top" })
vim.keymap.set("n", "<a-m>", "<c-w>o", { desc = "Close other windows" })

vim.keymap.set("v", "<a-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<a-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Autocommands --
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require("lazy").setup({
  "tpope/vim-sleuth",

  "ThePrimeagen/vim-be-good",

  {
    "olimorris/persisted.nvim",
    lazy = false,
    opts = {
      autoload = true,
    },
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("kanagawa-wave")
      vim.cmd.hi("Comment gui=none")
    end,
  },

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<cr>", "Stage Hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<cr>", "Reset Hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gd", gs.diffthis, "Diff This")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<c-U>Gitsigns select_hunk<cr>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<cr>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
      { "<s-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<s-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = { sort_by = "relative_directory" },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup()
      require("which-key").register({
        ["<leader>s"] = { name = "[s]earch", _ = "which_key_ignore" },
        ["<leader>t"] = { name = "[t]oggle", _ = "which_key_ignore" },
        ["<leader>g"] = { name = "[g]it", _ = "which_key_ignore" },
      })
      require("which-key").register({
        ["<leader>h"] = { "Git [h]unk" },
      }, { mode = "v" })
    end,
  },

  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      notify_on_error = false,
      format_after_save = {
        async = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        ["_"] = { { "prettierd", "prettier" } },
      },
    },
  },

  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
      require("mini.files").setup({
        options = { use_as_default_explorer = true },
        windows = { preview = true, width_preview = 80 },
      })
    end,
    keys = {
      {
        "<leader>e",
        function()
          local miniFiles = require("mini.files")
          if not miniFiles.close() then
            miniFiles.open(vim.api.nvim_buf_get_name(0), true)
          end
        end,
        desc = "Toggle File [e]xplorer (Cwd)",
      },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "angular", "bash", "diff", "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "scss" },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<leader>S",
        function()
          require("spectre").toggle()
        end,
        desc = "Search and Replace",
      },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",

      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open({ kind = "vsplit" })
        end,
        desc = "Open Neogit",
      },
    },
  },

  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.lint',
  { import = "custom.plugins" },
})

-- vim: ts=2 sts=2 sw=2 et
