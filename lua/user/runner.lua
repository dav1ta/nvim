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
  if project_root == nil then
    vim.cmd("echo Error | echo 'Could not find project root' | echohl None")
    make_cmd = run_command_for_filetype(filetype)
  else
    print("ff"
    )
  local makefile_path = project_root .. '/Makefile'
  if vim.fn.filereadable(makefile_path) ~= 1 then
    makefile_path = project_root .. '/makefile'
  end
  local make_cmd
  if vim.fn.filereadable(makefile_path) == 1 then
    make_cmd = "make -f " .. makefile_path
    if args ~= nil and args ~= '' then
      make_cmd = make_cmd .. ' ' .. args
    end
  else
    make_cmd = run_command_for_filetype(filetype)
    if make_cmd == nil then
      vim.cmd("echohl Error | echo 'No command found for filetype: " .. filetype .. "' | echohl None")
      return
    end
  end 
  vim.cmd("VimuxInterruptRunner")
  vim.cmd("VimuxRunCommand '" .. make_cmd .. "'")
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
