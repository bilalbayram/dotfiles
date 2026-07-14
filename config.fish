# Path
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path $HOME/.local/bin $HOME/.cargo/bin

for dir in /opt/homebrew/opt/libpq/bin $HOME/.orbstack/bin $HOME/.bun/bin $HOME/.grok/bin
    test -d $dir; and fish_add_path $dir
end

# Editor
set -gx EDITOR codium

# fzf settings
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# Ghostty shell integration
if test -d /Applications/Ghostty.app
    set -gx GHOSTTY_SHELL_INTEGRATION_XDG_DIR /Applications/Ghostty.app/Contents/Resources/ghostty/shell-integration
end

# Git prompt settings
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_dirtystate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_conflictedstate "+"
set -g __fish_git_prompt_color_dirtystate yellow
set -g __fish_git_prompt_color_cleanstate green --bold
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_branch cyan --dim

# try-cli
if type -q try
    eval (try init | string collect)
end

# Disable greeting
set -g fish_greeting

# Disable command description on macOS (performance)
function __fish_describe_command
end

# Aliases
if type -q eza
    alias ls="eza"
    alias ll="eza -l"
    alias la="eza -la"
end

if type -q bat
    alias cat="bat"
end

# Private config (API keys, work stuff, etc.)
test -f ~/.private.fish; and source ~/.private.fish
