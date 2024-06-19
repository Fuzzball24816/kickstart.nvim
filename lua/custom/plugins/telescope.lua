return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        path_display = { "truncate", "filename_first" },
        file_ignore_patterns = { "node_modules", "package%-lock.json" },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })
    local telescope = require("telescope")
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "projects")
    pcall(telescope.load_extension, "persisted")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[s]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[s]earch existing [b]uffers" })
    vim.keymap.set("n", "<leader>p", function()
      telescope.extensions.projects.projects()
    end, { desc = "Project list" })

    vim.keymap.set("n", "<leader>sc", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[s]earch [c]urrent file" })
    vim.keymap.set("n", "<leader>sa", builtin.live_grep, { desc = "[s]earch [a]ll files" })

    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[s]earch [/] in Open Files" })

    vim.keymap.set("n", "<leader>sC", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[s]earch Neovim [C]onfig files" })
  end,
}
