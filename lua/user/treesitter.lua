local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = {"python", "lua", "typescript","javascript","bash","regex","solidity"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable =true, -- false will disable the whole extension
    disable = function(lang, bufnr) -- Disable in large C++ buffers
        return  vim.api.nvim_buf_line_count(bufnr) > 5000
    end, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml","python" } },
  autotag = {
		enable = true,
		disable = { "xml" },
	},
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
