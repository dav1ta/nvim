
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
      useLibraryCodeForTypes = false, -- disable loading of library code stubs
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "off",
        useFastTaintingAnalysis = true, -- use faster tainting analysis
        logLevel = "warning", -- set log level to warning to reduce log-related overhead
        cacheSize = 512, -- limit the size of the in-memory cache for better performance
        memoryLimit = 1024, -- set a memory limit for the analysis process
      },
    },
  },
  single_file_support = true,
  flags = {
    debounce_text_changes = 100, -- debounce text changes for better performance
  },
}
