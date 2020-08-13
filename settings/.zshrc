


#========================
# 環境変数
#========================
export LANG=ja_JP.UTF-8


#========================
# ヒストリの設定
#========================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000


#========================
# 直前のコマンドの重複を削除
#========================
setopt hist_ignore_dups


#========================
# 同じコマンドをヒストリに残さない
#========================
setopt hist_ignore_all_dups


#========================
# 同時に起動したzshの間でヒストリを共有
#========================
setopt share_history


#========================
# 補完機能を有効にする
#========================
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi


#========================
# 補完で小文字でも大文字にマッチさせる
#========================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


#========================
# 補完候補を詰めて表示
#========================
setopt list_packed


#========================
# 補完候補一覧をカラー表示
#========================
autoload colors
zstyle ':completion:*' list-colors ''


#========================
# コマンドのスペルを訂正
#========================
setopt correct


#========================
# ビープ音を鳴らさない
#========================
setopt no_beep


#========================
# ディレクトリスタック
#========================
DIRSTACKSIZE=100
setopt AUTO_PUSHD


#========================
# git
#========================
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }


#========================
# zsh-syntax-highlighting
#========================
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


#========================
# プロンプトカスタマイズ
#========================
PROMPT='
[%B%F{red}%n@%m%f%b:%F{green}%~%f]%F{cyan}$vcs_info_msg_0_%f
%F{yellow}$%f '

# ========================
# .zfunc
# ========================
fpath+=~/.zfunc

# ========================
# julia
# ========================

alias julia1.3="/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia"
alias julia1.5="/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia"
export JULIA_CMDSTAN_HOME=/usr/local/bin/cmdstan
launchctl setenv JULIA_CMDSTAN_HOME /usr/local/bin/cmdstan
export JULIA_NUM_THREADS=4

# ===============================
# pyenv
# ===============================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# ===============================
# CmdStan
# ===============================
export CMDSTAN_HOME=/usr/local/bin/cmdstan
launchctl setenv CMDSTAN_HOME /usr/local/bin/cmdstann 
