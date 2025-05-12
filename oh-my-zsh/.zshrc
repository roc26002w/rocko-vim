# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose zsh-lazyload fzf helm zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export LESSCHARSET=utf-8

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export FZF_DEFAULT_COMMAND="ag --hidden --skip-vcs-ignores --ignore=.git -g ''"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"

# composer
export COMPOSER_MEMORY_LIMIT=-1
export PATH="$HOME/.composer/vendor/bin:$PATH"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export NVM_DIR="$HOME/.nvm"
export FZF_DEFAULT_COMMAND="ag --hidden --skip-vcs-ignores --ignore=.git -g ''"

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# go
# Install https://www.opencli.com/linux/ubuntu-install-golang-compile-helloworld
lazyload go -- 'export GOROOT=/usr/local/go && export GOPATH=$HOME/go && export PATH=$GOPATH/bin:$GOROOT/bin:$PATH'

# python
# source $HOME/.env/python/bin/activate

# rbenv
lazyload rbenv -- 'export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"'

# jenv
# https://www.jenv.be/
lazyload jenv -- 'export PATH="$HOME/.jenv/bin:$PATH" && eval "$(jenv init -)"'

# lazyload block end #

# Google Cloud SDK
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# The next line updates PATH for the Google Cloud SDK.
if [ ! command -v brew &> /dev/null ]
then
  if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then . "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"; fi

  if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then . "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"; fi
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
alias nv="nvim"
alias rspec="rspec --fail-fast"
alias zshconfig="nv ~/.zshrc"
alias nvconfig="nv ~/.config/nvim/init.vim"
alias phpunit="./vendor/bin/phpunit"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias ideavimconfig='nv ~/.ideavimrc'
alias git='LC_ALL=en_US git'
alias gd='git icdiff'
alias docker-compose='docker compose'
#alias kubectl='microk8s kubectl'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

typeset -U path
