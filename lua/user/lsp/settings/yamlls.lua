local status_ok, schemastore = pcall(require, "schemastore")
if not status_ok then
  return
end

return {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = schemastore.yaml.schemas(),
    },
  },
}
