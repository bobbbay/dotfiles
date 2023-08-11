{pkgs, lib, ...}: let
  # TODO: Use this as flake input, or find another proper way to lock this.
  fromGitHub = ref: repo: rev: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.wo.relativenumber = true

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require('gitsigns').setup()

      require('mini.map').setup()
      MiniMap.toggle()

      vim.keymap.set('n', '<Leader>mc', MiniMap.close, { desc = "Close MiniMap" })
      vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus, { desc = "Toggle focus of MiniMap" })
      vim.keymap.set('n', '<Leader>mo', MiniMap.open, { desc = "Open MiniMap" })
      vim.keymap.set('n', '<Leader>mr', MiniMap.refresh, { desc = "Refresh MiniMap" })
      vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side, { desc = "Toggle side of MiniMap" })
      vim.keymap.set('n', '<Leader>mt', MiniMap.toggle, { desc = "Toggle MiniMap" })

      vim.o.timeout = true
      vim.o.timeoutlen = 300
      
      local wk = require("which-key")

      wk.setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }

      vim.notify = require("notify")

      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colors = require("catppuccin.palettes").get_palette "mocha"

      require("heirline").load_colors(colors)

local Align = { provider = "%=" }
local Space = { provider = " " }

-- A small twist on the cookbook tablineoffset.
local TabLineOffset = {
    condition = function(self)
        local win = vim.api.nvim_tabpage_list_wins(0)[1]
        local bufnr = vim.api.nvim_win_get_buf(win)
        self.winid = win

        if vim.api.nvim_get_current_win() == self.winid then
            if vim.bo[bufnr].filetype == "NvimTree" then
                self.title = "Files"
                return true
	    end
        end
    end,

    provider = function(self)
        local title = self.title
        local width = vim.api.nvim_win_get_width(self.winid)
        local pad = math.ceil((width - #title) / 2)
        return string.rep(" ", pad) .. title .. string.rep(" ", pad)
    end,

    hl = "TabLineSel",
}

local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = "red" ,
            i = "green",
            v = "cyan",
            V =  "cyan",
            ["\22"] =  "cyan",
            c =  "orange",
            s =  "purple",
            S =  "purple",
            ["\19"] =  "purple",
            R =  "orange",
            r =  "orange",
            ["!"] =  "red",
            t =  "red",
        }
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantViModeiated.
    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 2
    -- characters long. Plus a nice Icon.
    provider = function(self)
        return " %2("..self.mode_names[self.mode].."%)"
    end,
    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true, }
    end,
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

ViMode = utils.surround({ "", "" }, "surface0", { ViMode })

local FileNameBlock = {
    -- let's first set up some attributes needed by this component and it's children
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}
-- We can now define some children separately and add them later

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
    },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
    hl = function()
        if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "sky", bold = true, force=true }
        end
    end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local WorkDir = {
    provider = function()
        local icon = " "
        local cwd = vim.fn.getcwd(0)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#cwd, 0.25) then
            cwd = vim.fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == '/' and ''\'' or "/"
        return icon .. cwd  .. trail
    end,
    hl = { fg = "overlay0", bold = true },
}

local FileEncoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= ''\'' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc ~= 'utf-8' and enc:upper()
    end
}

local FileSize = {
    provider = function()
        -- stackoverflow, compute human readable file size
        local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
        local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
        fsize = (fsize < 0 and 0) or fsize
        if fsize < 1024 then
            return fsize..suffix[1]
        end
        local i = math.floor((math.log(fsize) / math.log(1024)))
        return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
    end
}

-- We're getting minimalists here!
local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%7(%l/%3L%):%2c %P",
}

local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    hl = { fg = "blue" },

    utils.surround({ "  ", "" }, "surface0", {
    {   -- git branch name
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { bold = true }
    },
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = "("
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
        end,
        hl = { fg = "green" },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,
        hl = { fg = "red" },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        hl = { fg = "yellow" },
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    }})
}

local StatusLine = {
    TabLineOffset,
    ViMode,
    Space,
    WorkDir,
    FileNameBlock,
    Align,
    FileFlags,
    FileEncoding,
    Space,
    FileSize,
    Space,
    Ruler,
    Git,
}

require("heirline").setup({
    statusline = StatusLine,
})

require("telescope").load_extension('zoxide')

require("workspaces").setup({
    hooks = {
        open = { "NvimTreeOpen", "Telescope find_files" },
    }
})

require("telescope").load_extension('workspaces')

wk.register({
  w = {
    name = "workspace",
    w = {"<cmd>WorkspacesOpen<cr>", "Open workspace"},
    a = {"<cmd>WorkspacesAdd<cr>", "Add workspace"},
  },
  f = {
    name = "file",
    f = {"<cmd>Telescope fd<cr>", "Find file"},
    r = {"<cmd>Telescope oldfiles<cr>", "Open recent file"},
    n = {"<cmd>enew<cr>", "Create new file"},
  },
}, { prefix = "<leader>" })

require("nvim-tree").setup()

vim.g.startify_custom_header = {
"",
"",
'                                       ██            ',
'                                      ░░             ',
'    ███████   █████   ██████  ██    ██ ██ ██████████ ',
'   ░░██░░░██ ██░░░██ ██░░░░██░██   ░██░██░░██░░██░░██',
'    ░██  ░██░███████░██   ░██░░██ ░██ ░██ ░██ ░██ ░██',
'    ░██  ░██░██░░░░ ░██   ░██ ░░████  ░██ ░██ ░██ ░██',
'    ███  ░██░░██████░░██████   ░░██   ░██ ███ ░██ ░██',
'   ░░░   ░░  ░░░░░░  ░░░░░░     ░░    ░░ ░░░  ░░  ░░ ',
"",
"",
"Use <Leader>ww to open a workspace.",
}
vim.g.webdevicons_enable_startify = 1
vim.g.startify_enable_special = 0
vim.g.startify_session_autoload = 1
vim.g.startify_session_delete_buffers = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_persistence = 1
    '';

    plugins = with pkgs.vimPlugins; [ dressing-nvim
                                      { plugin = catppuccin-nvim;
                                        config = "colorscheme catppuccin-mocha";
                                      }
                                      nvim-notify
				      heirline-nvim
				      nvim-web-devicons
				      gitsigns-nvim
				      mini-nvim
				      which-key-nvim
				      popup-nvim
				      plenary-nvim
				      telescope-nvim
				      telescope-zoxide
				      (fromGitHub "HEAD" "natecraddock/workspaces.nvim" "c8bd98990d322b107e58ff5373038b753a8ef66d")
				      nvim-tree-lua
				      vim-startify
                                    ];
  };
}
