-- save as repro.lu-- save as repro.lua
-- run with nvim -u repro.lua
-- DO NOT change the paths
local root = vim.fn.fnamemodify("./.repro", ":p")

-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "runtime", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- install plugins
local plugins = {
  { "AstroNvim/AstroNvim", import = "astronvim.plugins" },
  -- add any other plugins/customizations here
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete" },
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["q"] = { "<cmd>w!|Bdelete!<cr>", noremap = false, desc = "Delete buffer" },
          },
        },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        auto_close_fugitive = {
          {
            event = "FileType",
            desc = "Close fugitiveblame",
            pattern = { "fugitiveblame" },
            callback = function()
              vim.keymap.set("n", "q", "<cmd>quit<CR>", { expr = false, noremap = true, desc = "Close" })
            end,
          },
        },
      },
    },
  },
}
require("lazy").setup(plugins, {
  root = root .. "/plugins",
})
