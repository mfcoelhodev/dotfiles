### --- PATHs ---
export PATH="$HOME/.local/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source <(fzf --zsh)

### --- Theme (Powerlevel10k) ---
# Powerlevel10k instant prompt for fast startup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Load Powerlevel10k theme
[[ -d ~/powerlevel10k ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

### --- Custom Plugin Manager ---
# ==============================================================================
# Custom Zsh Plugin Manager
# ==============================================================================

ZPLUGINDIR=${ZDOTDIR:-~}/.zsh/plugins
mkdir -p "$ZPLUGINDIR"

plugin-load() {
  local plugin repo commitsha plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}

  for plugin in "$@"; do
    repo="$plugin"
    clone_args=(-q --depth 1 --recursive --shallow-submodules)

    if [[ "$plugin" == *@* ]]; then
      repo="${plugin%@*}"
      commitsha="${plugin#*@}"
      clone_args+=(--no-checkout)
    fi

    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh

    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone "${clone_args[@]}" https://github.com/$repo $plugdir
      if [[ -n "$commitsha" ]]; then
        git -C $plugdir fetch -q origin "$commitsha"
        git -C $plugdir checkout -q "$commitsha"
      fi
    fi

    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( ${#initfiles[@]} )) || { echo >&2 "No init file found for '$repo'." && continue }
      ln -sf "$initfiles[1]" "$initfile"
    fi

    fpath+=($plugdir)
    . "$initfile"
  done
}

plugin-update() {
  for d in $ZPLUGINDIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
  echo "Plugin updates complete."
}

plugin-compile() {
  local f
  autoload -Uz zrecompile
  for f in $ZPLUGINDIR/**/*.zsh; do
    [[ $f != */test-data/* ]] || continue
    zrecompile -pq "$f"
  done
  echo "Plugin compilation complete."
}

# --- Plugin list ---
github_plugins=(
  'zsh-users/zsh-completions'
  'zsh-users/zsh-autosuggestions'
  'zsh-users/zsh-syntax-highlighting'
  'zsh-users/zsh-history-substring-search'
  'MichaelAquilina/zsh-you-should-use'
  'jeffreytse/zsh-vi-mode'
)

omz_plugins=(
)

# Load plugins
plugin-load "${github_plugins[@]}"

for plugin in "${omz_plugins[@]}"; do
  local plugindir=$ZPLUGINDIR/$plugin
  local initfile=$plugindir/$plugin.plugin.zsh
  if [[ ! -d $plugindir ]]; then
    echo "Downloading Oh My Zsh plugin: $plugin..."
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/$plugin/$plugin.plugin.zsh \
      --create-dirs --silent --show-error \
      --output "$initfile"
  fi
  [[ -f "$initfile" ]] && source "$initfile"
done

unset github_plugins omz_plugins
# ==============================================================================

### --- Completion system ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

### --- Keybindings ---
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

### --- Aliases ---
alias lazydocker='sudo ~/.local/bin/lazydocker'
alias tl="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"
alias gcoi='git checkout $(git branch | fzf)'
alias e='exit'
alias sp='cd ~/devel/side-pj'
alias st='cd ~/devel/studies'
alias reload='exec zsh'

### --- Functions ---
fda() {
  local dir
  dir=$(find ~ -path '*/\.*' -prune -o -type d -print 2>/dev/null | fzf +m) && cd "$dir"
}
fdi() {
  DIR=$(find . -type d -print 2>/dev/null | fzf-tmux) && cd "$DIR"
}
foa() {
  IFS=$'\n' files=($(find ~ -type f 2>/dev/null | fzf --multi --preview="bat --color=always {}"))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}
fo() {
  IFS=$'\n' files=($(fzf-tmux --multi --select-1 --exit-0 --preview="bat --color=always {}"))
  [[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

### --- History ---
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups \
       hist_save_no_dups hist_ignore_dups hist_find_no_dups

### --- Extras ---
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

if ! pgrep -u "$USER" ssh-agent >/dev/null; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

eval "$(thefuck --alias)"

