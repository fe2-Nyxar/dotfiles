if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting ""
    fastfetch
end


alias nixosconfig='nvim /etc/nixos/'
alias nvimconfig='nvim ~/.config/nvim'
alias ls= "eza --icons=always --color=always --long --no-filesize"

# default code editor
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

function sudo
    if test "$argv[1]" = "nvim"
        command sudo -Es $argv
    else
        command sudo $argv
    end
end

function wttr
    curl "wttr.in/$argv"
end
set -e FZF_DEFAULT_OPTS
#eval "$(fzf --fish)"

# --- setup fzf theme ---
# --- setup fzf theme ---
set purple "#B388FF"
set dimmed_purple "#6D4DC1"
set green "#b1f2a7"
set yellow "#ebde76"

set -x FZF_DEFAULT_OPTS "--color=hl:$dimmed_purple,hl+:$dimmed_purple,info:$green,prompt:$yellow,pointer:$yellow,marker:$yellow,spinner:$yellow,header:$yellow,fg+:$green"

set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
function _fzf_compgen_path
  fd --hidden --exclude .git . "$argv"
end

# Use fd to generate the list for directory completion
function _fzf_compgen_dir
  fd --type=d --hidden --exclude .git . "$argv"
end

set -x BAT_THEME "base16"


# ------ Eza ------
set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
function _fzf_comprun
  set command $argv[1]
  set argv $argv[2..-1]

  switch $command
    case 'cd'
      fzf --preview 'eza --tree --color=always {} | head -200' $argv
    case 'export' 'unset'
      fzf --preview "eval 'echo \$'{}" $argv
    case 'ssh'
      fzf --preview 'dig {}' $argv
    case '*'
      fzf --preview "bat -n --color=always --line-range :500 {}" $argv
  end
end

starship init fish | source
