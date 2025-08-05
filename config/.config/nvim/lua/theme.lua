--[[
Neovim Color Theme Configuration
Based on Ghostty terminal colors for consistency
--]]

-- Use true colors but mimic terminal color scheme
vim.o.termguicolors = true

-- Define Ghostty terminal colors
local colors = {
    -- Background/Foreground
    bg = '#1a1b26',
    fg = '#c0caf5',

    -- Standard palette (0-15)
    black = '#15161e',   -- palette 0
    red = '#f7768e',     -- palette 1
    green = '#9ece6a',   -- palette 2
    yellow = '#e0af68',  -- palette 3
    blue = '#7aa2f7',    -- palette 4
    magenta = '#bb9af7', -- palette 5
    cyan = '#7dcfff',    -- palette 6
    white = '#a9b1d6',   -- palette 7

    -- Bright colors (8-15)
    bright_black = '#414868',   -- palette 8
    bright_red = '#f7768e',     -- palette 9
    bright_green = '#9ece6a',   -- palette 10
    bright_yellow = '#e0af68',  -- palette 11
    bright_blue = '#7aa2f7',    -- palette 12
    bright_magenta = '#bb9af7', -- palette 13
    bright_cyan = '#7dcfff',    -- palette 14
    bright_white = '#c0caf5',   -- palette 15 (foreground)

    -- Special colors
    cursor = '#c0caf5',
    selection_bg = '#33467c',
    selection_fg = '#c0caf5',
}

-- Function to apply all highlight groups
local function apply_theme()
    -- Basic UI
    vim.api.nvim_set_hl(0, 'Normal', { fg = colors.bright_white, bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { fg = colors.bright_white, bg = colors.black })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = colors.bright_black, bg = 'NONE' })

    -- Line numbers
    vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.bright_black })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.yellow, bold = true })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'NONE' })

    -- Comments and non-text
    vim.api.nvim_set_hl(0, 'Comment', { fg = colors.bright_black, italic = true })
    vim.api.nvim_set_hl(0, 'NonText', { fg = colors.bright_black })
    vim.api.nvim_set_hl(0, 'SpecialKey', { fg = colors.bright_black })

    -- Search and selection
    vim.api.nvim_set_hl(0, 'Search', { fg = colors.selection_fg, bg = colors.selection_bg })
    vim.api.nvim_set_hl(0, 'IncSearch', { fg = colors.black, bg = colors.yellow })
    vim.api.nvim_set_hl(0, 'Visual', { fg = colors.selection_fg, bg = colors.selection_bg })

    -- Cursor
    vim.api.nvim_set_hl(0, 'Cursor', { fg = colors.black, bg = colors.cursor })

    -- Status line
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.bright_white, bg = colors.bright_black })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = colors.white, bg = colors.black })

    -- Syntax highlighting using terminal palette
    vim.api.nvim_set_hl(0, 'String', { fg = colors.green })
    vim.api.nvim_set_hl(0, 'Number', { fg = colors.yellow })
    vim.api.nvim_set_hl(0, 'Boolean', { fg = colors.yellow })
    vim.api.nvim_set_hl(0, 'Function', { fg = colors.blue })
    vim.api.nvim_set_hl(0, 'Keyword', { fg = colors.magenta })
    vim.api.nvim_set_hl(0, 'Conditional', { fg = colors.magenta })
    vim.api.nvim_set_hl(0, 'Repeat', { fg = colors.magenta })
    vim.api.nvim_set_hl(0, 'Type', { fg = colors.cyan })
    vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.bright_white })
    vim.api.nvim_set_hl(0, 'Constant', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'PreProc', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'Special', { fg = colors.cyan })

    -- Shell/command specific syntax (for .zshrc, .bashrc, etc.)
    vim.api.nvim_set_hl(0, 'Statement', { fg = colors.magenta })   -- export, alias, etc.
    vim.api.nvim_set_hl(0, 'shStatement', { fg = colors.magenta }) -- shell statements
    vim.api.nvim_set_hl(0, 'shCommandSub', { fg = colors.cyan })   -- command substitution
    vim.api.nvim_set_hl(0, 'shDerefVar', { fg = colors.blue })     -- $variables
    vim.api.nvim_set_hl(0, 'shVariable', { fg = colors.blue })     -- variables
    vim.api.nvim_set_hl(0, 'shOption', { fg = colors.yellow })     -- command options
    vim.api.nvim_set_hl(0, 'shQuote', { fg = colors.green })       -- quotes
    vim.api.nvim_set_hl(0, 'shOperator', { fg = colors.red })      -- operators like =, &&, ||

    -- General syntax that might be showing as default white
    vim.api.nvim_set_hl(0, 'Title', { fg = colors.blue, bold = true })
    vim.api.nvim_set_hl(0, 'Delimiter', { fg = colors.white })
    vim.api.nvim_set_hl(0, 'Operator', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'Error', { fg = colors.red, bold = true })
    vim.api.nvim_set_hl(0, 'Todo', { fg = colors.yellow, bold = true })

    -- Diagnostics
    vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = colors.yellow })
    vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = colors.blue })
    vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.cyan })
end

-- Apply theme when colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Apply Ghostty terminal colors',
    group = vim.api.nvim_create_augroup('ghostty-colors', { clear = true }),
    callback = apply_theme,
})

-- Apply theme immediately
apply_theme()

-- Export colors table for potential use in other modules
return {
    colors = colors,
    apply = apply_theme,
}
