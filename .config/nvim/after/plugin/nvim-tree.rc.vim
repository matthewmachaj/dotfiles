lua <<EOF
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
  ignore_ft_on_setup  = {},
  open_on_tab         = true,
  hijack_cursor       = false,

  -- 1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
  create_in_closed_folder = true,

  -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
  respect_buf_cwd     = true,

  update_cwd          = false,
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  actions = {
    use_system_clipboard = true,
    open_file = {
      -- 0 by default, closes the tree when you open a file
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",

        -- Dictionary of buffer option names mapped to a list of option values that
        -- indicates to the window picker that the buffer's window should not be
        -- selectable.
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  renderer = {
    -- 0 by default, append a trailing slash to folder names
    add_trailing = true,
  -- 0 by default, compact folders that only contain a single folder into one node in the file tree
    group_empty = true,
    highlight_git = false,
    full_name = false,

    -- 0 by default, will enable folder and file icon highlight for opened files/directories.
    -- Value can be `"none"`, `"icon"`, `"name"` or `"all"`.
    highlight_opened_files = "icon",

    -- This is the default. See :help filename-modifiers for more options
    root_folder_modifier = ":~",

    indent_width = 2,
    indent_markers = {
      -- 0 by default, this option shows indent markers when folders are open
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",

      -- one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
      padding = " ",

      -- ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
      symlink_arrow = " ➛ ",

      -- If 0, do not show the icons for one of 'git' 'folder' and 'files'
      -- 1 by default, notice that if 'files' is 1, it will only display
      -- if nvim-web-devicons is installed and on your runtimepath.
      -- if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
      -- but this will not work when you set indent_markers (because of UI conflict)
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      -- default will show icon by default if no icon is provided
      -- default shows no icon by default
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },

    --  List of filenames that gets highlighted with NvimTreeSpecialFile
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "TODO", "TODO.md" },
    symlink_destination = true,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}
EOF

" this variable must be enabled for colors to be applied properly
"
" To get this setting to work w/ Alacritty, I had to set TERM=alacritty in
" alacritty.yml; see:
"
"   - https://www.reddit.com/r/vim/comments/kennw5/termguicolors_disabling_all_text_colors_in/
set termguicolors

" a list of groups can be found at `:help nvim_tree_highlight`
" highlight NvimTreeSymlink guifg=blue gui=bold,underline
