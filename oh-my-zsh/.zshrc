# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/qoomon/zsh-lazyload
plugins=(git docker docker-compose zsh-lazyload fzf helm zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# set less charset
export LESSCHARSET=utf-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
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

export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export FZF_DEFAULT_COMMAND="ag --hidden --skip-vcs-ignores --ignore=.git -g ''"

# composer
export COMPOSER_MEMORY_LIMIT=-1
export PATH="$HOME/.composer/vendor/bin:$PATH"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# use lazyload use nvm
# https://github.com/qoomon/zsh-lazyload
# lazyload nvm -- '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

# go
# Install https://www.opencli.com/linux/ubuntu-install-golang-compile-helloworld
lazyload go -- 'export GOROOT=/usr/local/go && export GOPATH=$HOME/go && export PATH=$GOPATH/bin:$GOROOT/bin:$PATH'

# python
source $HOME/.env/python/bin/activate

# rbenv
lazyload rbenv -- 'export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"'

# jenv
# https://www.jenv.be/
lazyload jenv -- 'export PATH="$HOME/.jenv/bin:$PATH" && eval "$(jenv init -)"'

# kubectl
# lazyload kubectl -- 'export PATH=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:$PATH'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ ! command -v brew &> /dev/null ]
then
  if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then . "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"; fi

  if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then . "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"; fi
fi

export PATH="/usr/local/sbin:$PATH"
