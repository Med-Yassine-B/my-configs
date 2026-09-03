# ~/.config/bash/aliases.bash

alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -A --color=auto'
alias lla='ls -lhA --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'

cpf() {
    if [ -e "$1" ]; then
        echo -n "file://$(realpath "$1")" | wl-copy -t text/uri-list
        echo "Copied $1 to clipboard!"
    else
        echo "Error: File '$1' not found."
    fi
}
n() {
  if [ -n "$NVIM" ]; then
    # We are INSIDE a Neovim terminal!
    local TARGET=""
    
    # if no path specified use the current dir
    if [ -e "$1" ]; then
        TARGET=$(realpath "$1")
    else
        TARGET=$(pwd)
    fi

    local TARGET_DIR=$(dirname "$TARGET")
    # if it's a directory only change the workspace to it and cd there
    # if it's a file set the set the workspace to the directory parent and edit the file
    if [ -d "$TARGET" ]; then
        nvim --server "$NVIM" --remote-send "<C-\><C-n>:lcd $TARGET<CR>"
        cd "$TARGET"
    else
        nvim --server "$NVIM" --remote-send "<C-\><C-n>:lcd $TARGET_DIR<CR>:edit $TARGET<CR>"
    fi
  else
    # We are in a normal terminal, open Neovim regularly
    nvim "$@"
  fi
}
#same as n but set's the workspace variable
nw() {
  if [ -n "$NVIM" ]; then
    # We are INSIDE a Neovim terminal!
    local TARGET=""
    
    # if no path specified use the current dir
    if [ -e "$1" ]; then
        TARGET=$(realpath "$1")
    else
        TARGET=$(pwd)
    fi

    local TARGET_DIR=$(dirname "$TARGET")
    # if it's a directory only change the workspace to it and cd there
    # if it's a file set the set the workspace to the directory parent and edit the file
    if [ -d "$TARGET" ]; then
        nvim --server "$NVIM" --remote-send "<C-\><C-n>:let \$WORKSPACE = '$TARGET' <CR>:lcd $TARGET<CR>"
        cd "$TARGET"
    else
        nvim --server "$NVIM" --remote-send "<C-\><C-n>:let \$WORKSPACE = '$TARGET_DIR' <CR>:lcd $TARGET_DIR<CR>:edit $TARGET<CR>"
    fi
  else
    # We are in a normal terminal, open Neovim regularly
    nvim "$@"
  fi
}
