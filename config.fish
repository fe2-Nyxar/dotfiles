if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting ""
    fastfetch
end


alias nixosconfig='cd /etc/nixos; sudo nvim . ; cd -'
alias nvimconfig='cd ~/.config/nvim;nvim . ; cd -'
alias ls="eza --icons=always --color=always -l --no-filesize"
alias tree="eza --tree --icons=always --color=always -l --no-filesize"
# default man is neovim
set -gx MANPAGER 'nvim +Man!'
# default code editor
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

# DANGER: -- keybinds --

#function toggleViMode
#    if test "$fish_key_bindings" = "fish_vi_key_bindings"
#        fish_vi_key_bindings 
#    else
#        fish_default_key_bindings 
#    end
#    
#end
#
#bind \ck toggleViMode


function aj
    cd (autojump $argv)
end


function sudo
    if test "$argv[1]" = "nvim"
        command sudo -Es $argv
    else
        command sudo $argv
    end
end

function wttr
    if test $argv = ""
        curl "wttr.in/fes"
    else
        curl "wttr.in/$argv"
    end
end
set -e FZF_DEFAULT_OPTS
#eval "$(fzf --fish)"

# --- setup fzf theme ---
set purple "#B388FF"
set dimmed_purple "#6D4DC1"
set green "#b1f2a7"
set yellow "#ebde76"

set -x FZF_DEFAULT_OPTS "--color=hl:$dimmed_purple,hl+:$dimmed_purple,info:$green,prompt:$yellow,pointer:$yellow,marker:$yellow,spinner:$yellow,header:$yellow,fg+:$green"

set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
#NOTE: use ctrl + t for file search and alt + c for directory search
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
#NOTE: this for fzf and the selected file will be used in neovim
alias fzfnvim="fd --hidden --strip-cwd-prefix --exclude .git | fzf | xargs -r nvim"

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
