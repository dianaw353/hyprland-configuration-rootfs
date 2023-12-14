source ~/.zsh_aliases

# History settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Key bindings
bindkey -e

# Completion settings
autoload -Uz compinit
compinit

eval "$(zoxide init zsh)"
# Starship prompt
eval "$(starship init zsh)"

# Zinit plugin manager
ZINIT_HOME="${ZINIT_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zinit}"
if [[ ! -f ${ZINIT_HOME}/zinit.git/zinit.zsh ]]; then
    command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
    command git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}/zinit.git"
fi
source "${ZINIT_HOME}/zinit.git/zinit.zsh"

# Zinit plugins
zinit ice wait'0' blockf atpull'zinit creinstall -q .' silent
zinit light zsh-users/zsh-completions

zinit ice wait'0' lucid silent
zinit light-mode for \
  hlissner/zsh-autopair \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use \
  zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab

zinit ice wait'0' lucid silent
zinit light zsh-users/zsh-history-substring-search

zinit ice wait'0' lucid silent
zinit light zdharma-continuum/history-search-multi-word

# FZF
zinit ice wait'0' from"gh-r" as"command" silent
zinit light junegunn/fzf-bin

# EXA
zinit ice wait'0' lucid from"gh-r" as"program" mv"bin/exa* -> exa" silent
zinit light ogham/exa

# BAT
zinit ice wait'0' lucid from"gh-r" as"program" mv"*/bat -> bat" atload"export BAT_THEME='Nord'" silent
zinit light sharkdp/bat

# vim:ft=zsh
if pgrep -x "Hyprland" > /dev/null; then
    pfetch
else
    echo "Hyprland is not running."
fi
export PATH=$PATH:/home/diana/.cargo/bin
