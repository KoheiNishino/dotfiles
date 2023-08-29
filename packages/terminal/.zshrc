export PATH="/usr/local/sbin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# -----------------------------
# Aliases
# -----------------------------

alias c="code ."
alias g='cd "$(ghq list --full-path | awk -F "/" '\''{print $(NF-1) "/" $NF "\t" $0}'\'' | fzf --with-nth=1 | awk '\''{print $2}'\'')"'
alias o="open ."
alias p="pnpm"
alias nui="npx npm-check --update"
alias yui="yarn upgrade-interactive --latest"
alias pui="pnpm upgrade -i --latest"

alias cat="bat"
alias du="dust"
alias ls="exa"
alias ll="ls -ahl --git"
alias lt="ll -TL 3 --ignore-glob=.git"
alias ps="procs"

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'

# -----------------------------
# Shorthand Aliases
# -----------------------------

alias relogin="exec $SHELL -l"
alias sz='source ~/.zshrc'
alias vsc='vim ~/.ssh/config'
alias vz='vim ~/.zshrc'

# -----------------------------
# Global Aliases
# -----------------------------

alias -g L='| less'
alias -g H='| head'
alias -g G='| grep --color=auto'
alias -g GI='| grep -ir --color=auto'

# -----------------------------
# eval
# -----------------------------

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# -----------------------------
# Other
# -----------------------------

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# -----------------------------
# History
# -----------------------------

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

# -----------------------------
# Options
# -----------------------------

# cd なしでディレクトリ移動可
setopt auto_cd

# cd [TAB] で以前移動したディレクトリを表示
setopt auto_pushd

# コマンドミスを修正
setopt correct

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# 直前と同じコマンドの場合はヒストリに追加しない
setopt hist_ignore_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 同時に起動した zsh の間でヒストリを共有する
setopt share_history

# ビープ音を鳴らさない
setopt no_beep

# ディレクトリ移動時にpushd
setopt auto_pushd

# 即座に履歴を保存
setopt inc_append_history
