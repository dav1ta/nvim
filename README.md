# My Neovim Setup
extended from [Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch)

## Some Setup commands to remember

## VISTA
run `Vista` to open tag where all nearby functions are located `Vista!` to close
## GO TO PREVIEW

```vim
nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
" Only set if you have telescope installed
nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
```
## VIM-EUNICH

-   `:Delete`: Delete a buffer and the file on disk simultaneously.
-   `:Unlink`: Like `:Delete`, but keeps the now empty buffer.
-   `:Move`: Rename a buffer and the file on disk simultaneously.
-   `:Rename`: Like `:Move`, but relative to the current file's containing directory.
-   `:Chmod`: Change the permissions of the current file.
-   `:Mkdir`: Create a directory, defaulting to the parent of the current file.
-   `:Cfind`: Run `find` and load the results into the quickfix list.
-   `:Clocate`: Run `locate` and load the results into the quickfix list.
-   `:Lfind`/`:Llocate`: Like above, but use the location list.
-   `:Wall`: Write every open window. Handy for kicking off tools like [guard](https://github.com/guard/guard).
-   `:SudoWrite`: Write a privileged file with `sudo`.
-   `:SudoEdit`: Edit a privileged file with `sudo`.
-   File type detection for `sudo -e` is based on original file name.
-   New files created with a shebang line are automatically made executable.


## LIGHT BULB 
no usage yet


##  Neogen

generate docstrings using :Neogen

## Diffview

### [](https://github.com/sindrets/diffview.nvim#diffviewopen-git-rev-args-----paths) 


`:DiffviewOpen [git rev] [args] [ -- {paths...}]`

Calling `:DiffviewOpen` with no args opens a new Diffview that compares against the current index. You can also provide any valid git rev to view only changes for that rev. Examples:

-   `:DiffviewOpen`
-   `:DiffviewOpen HEAD~2`
-   `:DiffviewOpen HEAD~4..HEAD~2`
-   `:DiffviewOpen d4a7b0d`
-   `:DiffviewOpen d4a7b0d..519b30e`
-   `:DiffviewOpen origin/main...HEAD`

# Neovim Session Manager

Use the command `:SessionManager[!]` with one of the following arguments:

Argument

Description

`load_session`

Select and load session.

`load_last_session`

Will remove all buffers and `:source` the last saved session.

`load_current_dir_session`


`save_current_session`

Works like `:mksession`, but saves/creates current directory as a session in `sessions_dir`.

`delete_session`

Select and delete session.

## Keybindings

### Better window navigation
```vim
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
```


### Navigate buffers
S - shift
```vim
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
```
### move text

```vim
-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<S-j>", ":m .+1<CR>==", opts)
keymap("v", "<S-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)


```



