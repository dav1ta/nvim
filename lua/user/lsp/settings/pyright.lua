return {
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
