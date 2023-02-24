local lspconfig = require('lspconfig')
local python_root_files = {
  'WORKSPACE', -- added for Bazel; items below are from default config
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
}

return {
    root_dir = lspconfig.util.root_pattern(unpack(python_root_files)),
  settings = {

    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "off",
      },
    },
  },
  single_file_support = true,
}
