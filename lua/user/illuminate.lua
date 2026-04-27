-- Illuminate quick cues:
-- 1. `]]` → jump to the next reference of the symbol under cursor.
-- 2. `[[` → move back to the previous highlighted reference.
-- 3. `:IlluminatePause` → suspend highlighting for a distraction-free moment.
-- 4. `:IlluminateResume` → resume automatic highlights afterwards.
-- 5. `:IlluminatePauseBuf` → pause highlights just for the current buffer.
-- 6. `:IlluminateToggle` → quickly flip the feature on/off if diagnostics clash.
-- 7. Adjust `delay` here when highlights feel too eager or too slow.

function setup()

    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        print("illuminate not found")
        return
    end
    illuminate.configure({
        providers = {
            'lsp',
            'treesitter',
            'regex',
        },
        delay = 250, -- reduce delay to improve responsiveness
        filetype_overrides = {},
        filetypes_denylist = {
            'dirvish',
            'fugitive',
            "alpha",
            "NvimTree",
            "packer",
            "neogitstatus",
            "Trouble",
            "lir",
            "Outline",
            "spectre_panel",
            "DressingSelect",
            "TelescopePrompt",
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist= {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = 1000, -- set a cutoff for large files to prevent slowdowns
        large_file_overrides = nil,
        min_count_to_highlight = 1,
    })

    -- Update highlight groups for background highlighting

end
return {setup=setup}
