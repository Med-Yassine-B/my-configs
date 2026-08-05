-- Session functions
local session_dir = vim.fn.stdpath("data") .. "/sessions"

-- Deleting old session (30 days old)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.loop.fs_stat(session_dir) then
            os.execute('find ' .. session_dir .. ' -type f -mtime +30 -delete')
        end
    end,
})

vim.api.nvim_create_user_command("ReloadConfig", function()
  -- Clear loaded config modules from cache
  for name, _ in pairs(package.loaded) do
    if name:match("^key_maps") or name:match("^cmd") or name:match("^settings") then
      package.loaded[name] = nil
    end
  end
  -- Re-require init
  dofile(vim.env.MYVIMRC)
  print("Config reloaded successfully!")
end, {
    bar=true
})

vim.api.nvim_create_user_command("Venv",function(opts)
    local venv= opts.fargs[1]
    local workspace=vim.fn.getcwd()
    local venv_path=workspace .. "/" .. venv

    local python_exe
    if venv_path[venv_path.len]=="/" then
        python_exe= venv_path .. "bin/python"
    else
        python_exe= venv_path .. "bin/python"
    end

    if vim.fn.executable(python_exe)~=1 then
        print("No venv found!")
        return
    end
        vim.g.python3_host_prog=python_exe
        vim.env.VIRTUAL_ENV=venv_path
        vim.env.PATH= venv_path .. "/bin:" .. vim.env.PATH
        print(python_exe .. " is set as host prog successfully!")
end,{
    nargs=1,
    complete="file"
})
