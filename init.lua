-- === PACKER SETUP ===
-- Auto-install packer if missing
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- === PLUGINS ===
require('packer').startup(function(use)
  -- Let packer manage itself
  use 'wbthomason/packer.nvim'

  -- Zettelkasten support
  use 'zk-org/zk-nvim'

  -- Typst preview
  use { 'chomosuke/typst-preview.nvim', tag = 'v1.*' }

  -- Telescope + dependency
  use 'nvim-lua/plenary.nvim'
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.8' }
  use 'nvim-tree/nvim-web-devicons'

  -- nyoom-engineering oxycarbon theme
  use {'nyoom-engineering/oxocarbon.nvim'}

  -- Lualine
  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- === PLUGIN CONFIG ===

-- Telescope setup
require('telescope').setup({})

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Zk setup
require('zk').setup({
	picker = "telescope",
	})

-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = '16color',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- typst-preview
require 'typst-preview'.setup {
  -- Setting this true will enable logging debug information to
  -- `vim.fn.stdpath 'data' .. '/typst-preview/log.txt'`
  debug = false,

  -- Custom format string to open the output link provided with %s
  -- Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
  open_cmd = nil,

  -- Custom port to open the preview server. Default is random.
  -- Example: port = 8000
  port = 0,

  -- Setting this to 'always' will invert black and white in the preview
  -- Setting this to 'auto' will invert depending if the browser has enable
  -- dark mode
  -- Setting this to '{"rest": "<option>","image": "<option>"}' will apply
  -- your choice of color inversion to images and everything else
  -- separately.
  invert_colors = 'never',

  -- Whether the preview will follow the cursor in the source file
  follow_cursor = true,

  -- Provide the path to binaries for dependencies.
  -- Setting this will skip the download of the binary by the plugin.
  -- Warning: Be aware that your version might be older than the one
  -- required.
  dependencies_bin = {
    ['tinymist'] = nil,
    ['websocat'] = nil
  },

  -- A list of extra arguments (or nil) to be passed to previewer.
  -- For example, extra_args = { "--input=ver=draft", "--ignore-system-fonts" }
  extra_args = nil,

  -- This function will be called to determine the root of the typst project
  get_root = function(path_of_main_file)
    local root = os.getenv 'TYPST_ROOT'
    if root then
      return root
    end
    return vim.fn.fnamemodify(path_of_main_file, ':p:h')
  end,

  -- This function will be called to determine the main file of the typst
  -- project.
  get_main_file = function(path_of_buffer)
    return path_of_buffer
  end,
}
-- :set settings
vim.opt.wrap = true
vim.opt.linebreak = true

-- customization
vim.cmd("colorscheme oxocarbon")
vim.opt.termguicolors = true








