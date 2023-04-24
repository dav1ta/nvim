local function run_python_command()
  local file_path = vim.fn.expand('%:p')
  local cmd = "python " .. file_path
  return cmd
end

local function run_bash_command()
  local file_path = vim.fn.expand('%:p')
  local cmd = "bash " .. file_path
  return cmd
end

local function run_typescript_command()
  local file_path = vim.fn.expand('%:p')
  local cmd = "ts-node " .. file_path
  return cmd
end

local function run_command_for_filetype(filetype)
  if filetype == "python" then
    return run_python_command()
  elseif filetype == "sh" then
    return run_bash_command()
  elseif filetype == "typescript" then
    return run_typescript_command()
  else
    return nil
  end
end



function run_makefile(args)
  local Project = require('project_nvim.project')
  local project_root = Project.get_project_root(vim.fn.expand('%:p'))
  local filetype = vim.bo.filetype
  local make_cmd

  if project_root ~= nil then
    local makefile_path = project_root .. '/Makefile'
    if vim.fn.filereadable(makefile_path) ~= 1 then
      makefile_path = project_root .. '/makefile'
    end
    if vim.fn.filereadable(makefile_path) == 1 then
      make_cmd = "make -f " .. makefile_path
      if args ~= nil and args ~= '' then
        make_cmd = make_cmd .. ' ' .. args
      end
    end
  end

  if make_cmd == nil then
    make_cmd = run_command_for_filetype(filetype)
    if make_cmd == nil then
      vim.cmd("echohl Error | echo 'No command found for filetype: " .. filetype .. "' | echohl None")
      return
    end
  end


  vim.cmd("VimuxInterruptRunner")
  vim.cmd("VimuxRunCommand '" .. make_cmd .. "'")
end


vim.cmd("command! -nargs=* RunMakefile lua run_makefile(<q-args>)")

local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

 function tmux_run(cmd_name, cmd)
  -- Check if the window with the given cmd_name already exists
  local window_id = trim(vim.fn.system(string.format("tmux list-windows -F \"#{window_name} #{window_id}\" | grep \"^%s \" | awk '{print $2}'", cmd_name)))

  if window_id == "" then
    -- If the window doesn't exist, create a new window and run the command
    vim.fn.system(string.format("tmux new-window -n \"%s\" \"%s\"", cmd_name, cmd))
  else
    -- If the window exists, select it
    vim.fn.system(string.format("tmux select-window -t \"%s\"", window_id))
  end
end

vim.cmd("command! TmuxHtop lua _G.tmux_run('htop', 'htop')")
vim.cmd("command! LazyGit lua _G.tmux_run('lazygit', 'lazygit')")
vim.cmd("command! LazyDocker lua _G.tmux_run('lazydocker', 'lazydocker')")
