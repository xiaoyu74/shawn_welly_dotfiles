# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Set up user-specific environment
# Prepend $HOME/.local/bin and $HOME/bin to PATH if they're not already included
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment to disable systemctl's auto-paging feature
# export SYSTEMD_PAGER=

# Load user-specific aliases and functions from .bashrc.d directory
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc  # Clean up

# Fcitx Input Method
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

# Configure Powerline if it's installed
if [ -f "$(which powerline-daemon)" ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

# Set up user-specific environment
# Prepend $HOME/.local/bin and $HOME/bin to PATH if they're not already included
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Append Go bin directory to PATH if not already included
if ! [[ ":$PATH:" == *":/home/sbai/go/bin:"* ]]; then
    PATH="$PATH:/home/sbai/go/bin"
fi
export PATH

# Alias and function definitions
# Alias for quickly navigating to a specific work directory
alias devwork="cd ~/osd_functional_work"

# Function for navigating using a tree view and fzf
ft() {
    local file
    file=$(tree -fai --noreport . | fzf) && [ -n "$file" ] && cd "$(dirname "$file")"
}


# Markdown settings
export PATH=$PATH:~/.npm-global/bin

## OSD/ROSA/Backplane settings

# backplane login settings
export OCM_TOKEN=""

ocm-stg () {
    ocm login --token $OCM_TOKEN --url "https://api.stage.openshift.com"
    ln -f ~/.config/backplane/config.stg.json ~/.config/backplane/config.json
}

ocm-int () {
    ocm login --token $OCM_TOKEN --url "https://api.integration.openshift.com"
    ln -f ~/.config/backplane/config.int.json ~/.config/backplane/config.json
}

ocm-prod () {
    ocm login --token $OCM_TOKEN --url "https://api.openshift.com"
    ln -f ~/.config/backplane/config.prod.json ~/.config/backplane/config.json
}

# OCM Containers
alias occ-stg="OCM_URL=stg ocm-container"
alias occ-prod="OCM_URL=prod ocm-container"
alias occ-local='OCM_CONTAINER_LAUNCH_OPTS="-v ${PWD}:/root/local -w /root/local" ocm-container'

# OSD/ROSA cluster operations alias
BACKPLANE_DEFAULT_OPEN_BROWSER=true
alias occ='osdctl cluster context -S'
alias codown="oc get co | awk '{ if (\$5 == \"True\" || \$4 == \"True\" || NR==1) print \$0; }'"
alias od='oc describe'
alias og='oc get'
alias ocp='oc project'
alias fileusage='df -h'
alias random_line='shuf -n 1'
alias ol='oc logs'
alias olt='oc logs --tail 50'
alias oes='oc get event --sort-by=.metadata.creationTimestamp'

# ## PS1 Setup for OSD/ROSA cluster access
# source /home/sbai/osd_functional_work/kube-ps1.sh
# function cluster_function {
#   info="$(ocm backplane status 2> /dev/null)"
#   if [ $? -ne 0 ]; then return; fi
#   clustername=$(grep "Cluster Name" <<< $info | awk '{print $3}')
#   baseid=$(grep "Cluster Basedomain" <<< $info | awk '{print $3}' | cut -d'.' -f1,2)
#   echo $clustername.$baseid
# }
# KUBE_PS1_BINARY=oc
# export KUBE_PS1_CLUSTER_FUNCTION=cluster_function
# PS1='[\u@\h \W $(kube_ps1)]\$ '

# # Define ocm-backplane login Functions for easy login and logout
# obl() {
#   source /home/sbai/osd_functional_work/kube-ps1.sh
#   function cluster_function {
#     info="$(ocm backplane status 2> /dev/null)"
#     if [ $? -ne 0 ]; then return; fi
#     clustername=$(grep "Cluster Name" <<< $info | awk '{print $3}')
#     baseid=$(grep "Cluster Basedomain" <<< $info | awk '{print $3}' | cut -d'.' -f1,2)
#     echo $clustername.$baseid
#   }
#   KUBE_PS1_BINARY=oc
#   export KUBE_PS1_CLUSTER_FUNCTION=cluster_function
#   PS1='[\u@\h \W $(kube_ps1)]\$ '

#   ocm backplane login $1
# }

# obl_mc() {
#   exec "$SHELL" -l
#   source /home/sbai/osd_functional_work/kube-ps1.sh
#   function cluster_function {
#     info="$(ocm backplane status 2> /dev/null)"
#     if [ $? -ne 0 ]; then return; fi
#     clustername=$(grep "Cluster Name" <<< $info | awk '{print $3}')
#     baseid=$(grep "Cluster Basedomain" <<< $info | awk '{print $3}' | cut -d'.' -f1,2)
#     echo $clustername.$baseid
#   }
#   KUBE_PS1_BINARY=oc
#   export KUBE_PS1_CLUSTER_FUNCTION=cluster_function
#   PS1='[\u@\h \W $(kube_ps1)]\$ '

#   ocm backplane login --manager $1
# }

# oblout() {
#   ocm backplane logout
#   if [ -f "$(which powerline-daemon)" ]; then
#     powerline-daemon -q
#     POWERLINE_BASH_CONTINUATION=1
#     POWERLINE_BASH_SELECT=1
#     . /usr/share/powerline/bash/powerline.sh
#   fi
# }
