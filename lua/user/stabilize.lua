
local status_ok, stabilize = pcall(require, "stabilize")
if not status_ok then
  print("stabilize not found")
	return
end
stabilize.setup()
