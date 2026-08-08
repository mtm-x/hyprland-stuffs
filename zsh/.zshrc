# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added a config file for you to customize HyDE before loading zshrc
# Edit $ZDOTDIR/.user.zsh to customize HyDE before loading zshrc

#  Plugins 
# oh-my-zsh plugins are loaded  in $ZDOTDIR/.user.zsh file, see the file for more information

#  Aliases 
# Override aliases here in '$ZDOTDIR/.zshrc' (already set in .zshenv)

# # Helpful aliases
# alias c='clear'                                                        # clear terminal
# alias l='eza -lh --icons=auto'                                         # long list
# alias ls='eza -1 --icons=auto'                                         # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias lt='eza --icons=auto --tree'                                     # list folder as tree
# alias un='$aurhelper -Rns'                                             # uninstall package
# alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
# alias po='$aurhelper -Qtdq | $aurhelper -Rns -'                        # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
# alias vc='code'                                                        # gui code editor
alias fastfetch='fastfetch --logo-type kitty'

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
# alias mkdir='mkdir -p'

# Add your configurations here
export EDITOR=vim
export CSCOPE_EDITOR=vim
export DOCKER_CLI_EXPERIMENTAL=enabled
alias dock=~/.config/personal_scripts/docker.sh
# Monitor Swap Aliases
alias desk="~/.config/personal_scripts/monitor.sh --desk"
alias tv="~/.config/personal_scripts/monitor.sh --tv"

alias d1="docker exec -it training-test /bin/bash"
alias cscope='EDITOR=vim cscope'
alias lx="cd ~/Linux/linux_mainline/"

# Zephyr exports
export ZEPHYR_SDK_INSTALL_DIR=/opt/sdk/zephyr-sdk-1.0.0
alias zep="cd ~/zep/zephyr/ && source ~/zep/.venv/bin/activate"
alias rf="rm -rf build/"
alias wb="west build -p -b nucleo_f411re"
alias wf="west flash --runner openocd"

# Dual monitor walls
alias dualwall="~/.config/personal_scripts/dual_wall.sh --source"
alias dualwallapp="~/.config/personal_scripts/dual_wall.sh --apply-only"
alias TAS_DIR="/home/mtm/aurix/das/TAS_V1_1_0/bin/"
