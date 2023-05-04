
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
            "toggleterm",
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
return {config=config}
