
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
    python = {
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "off",
        useFastTaintingAnalysis = true, -- use faster tainting analysis
      },
    },
  },
  single_file_support = true,
  }
