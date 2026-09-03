#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


### ─── Environment Variables ─────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export PATH="$PATH:/opt/android-sdk/platform-tools:/home/yassin/.local/bin"
export ANDROID_NDK=/opt/android-ndk/
export ANDROID_HOME=/opt/android-sdk/

### ─── Prompt (PS1) ──────────────────────────────────────────
parse_git_branch() {
    git branch 2>/dev/null | sed -n '/\* /s///p'
}
PS1='\[\e[1;32m\][\u@\h \[\e[1;34m\]\W\[\e[0;33m\] $(parse_git_branch)\[\e[1;32m\]]\$\[\e[0m\] '

### ─── External Configurations ───────────────────────────────
if command -v dircolors >/dev/null 2>&1; then eval "$(dircolors)"; fi
if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi

# Load your clean modular aliases/functions
if [ -f ~/.config/bash/aliases.bash ]; then
    source ~/.config/bash/aliases.bash
fi

if [ -n "$VIRTUAL_ENV" ]; then
    if [ -f "$VIRTUAL_ENV/bin/activate" ]; then
        source "$VIRTUAL_ENV/bin/activate"
    fi
# 2. Fallback: If not set, check if a local .venv exists in the current directory
elif [ -f "./.venv/bin/activate" ]; then
    source "./.venv/bin/activate"
fi

#open nvim as a terminal manager
if [ -z "$NVIM" ]; then
    exec nvim -c terminal -c startinsert
fi
