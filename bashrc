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

export EDITOR=vim

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

export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export GO111MODULE=on

# Alias and function definitions
# Alias for quickly navigating to a specific work directory
alias devwork="cd ~/osd_functional_work"
alias opswork="cd ~/osd_operation_work"
alias ghrepo="cd ~/osd_functional_work/github_repo"
alias glrepo="cd ~/osd_functional_work/gitlab_repo"

# Function for navigating using a tree view and fzf
ft() {
    local file
    file=$(tree -fai --noreport . | fzf) && [ -n "$file" ] && cd "$(dirname "$file")"
}


# Markdown settings
export PATH=$PATH:~/.npm-global/bin

## OSD/ROSA/Backplane settings
source /etc/profile.d/bash_completion.sh
source <(oc completion bash)

# backplane login settings
export OCM_TOKEN=""

ocm-stg () {
    # ocm login --token $OCM_TOKEN --url "https://api.stage.openshift.com"
    ocm logout
    ocm login --use-auth-code --url "https://api.stage.openshift.com"
    ln -f ~/.config/backplane/config.stg.json ~/.config/backplane/config.json
}

ocm-int () {
    # ocm login --token $OCM_TOKEN --url "https://api.integration.openshift.com"
    ocm logout
    ocm login --use-auth-code --url "https://api.integration.openshift.com"
    ln -f ~/.config/backplane/config.int.json ~/.config/backplane/config.json
}

ocm-prod () {
    ocm login --token $OCM_TOKEN --url "https://api.openshift.com"
    # ocm logout
    # ocm login --use-auth-code --url "https://api.openshift.com"
    ln -f ~/.config/backplane/config.prod.json ~/.config/backplane/config.json
}

# OCM Containers
alias occ-stg="OCM_URL=stg ocm-container"
alias occ-prod="OCM_URL=prod ocm-container"
alias occ-local='OCM_CONTAINER_LAUNCH_OPTS="-v ${PWD}:/root/local -w /root/local" ocm-container'

# OSD/ROSA cluster operations alias
BACKPLANE_DEFAULT_OPEN_BROWSER=true
alias olc='ocm list cluster --managed'
alias occ='osdctl cluster context -S'
alias odc='ocm describe cluster'
alias obs='ocm-backplane session -c'
alias obsm='ocm-backplane session --manager -c'
alias obl='ocm-backplane login'
alias console='ocm-backplane console'
alias cloud-console='ocm-backplane cloud console'
alias codown="oc get co | awk '{ if (\$5 == \"True\" || \$4 == \"True\" || NR==1) print \$0; }'"
alias verify-egress='osdctl network verify-egress --cluster-id'
alias sl='osdctl servicelog list'
alias dt='osdctl cluster dynatrace url'

alias od='oc describe'
alias og='oc get'
alias ocp='oc project'
alias ol='oc logs'
alias olt='oc logs --tail 50'
alias oes='oc get event --sort-by=.metadata.creationTimestamp'
alias oc-admin='oc --as=backplane-cluster-admin'
alias awsconsole='google-chrome "https://us-east-1.console.aws.amazon.com/console/home"'
alias ocmstg='ocm config set url https://api.stage.openshift.com'
alias ocmlogin='ocm login --use-auth-code'

# Function to extend OCM cluster expiration
cluster-extend() {
    local cluster_id=$1
    ocm edit cluster --expiration 168h0m0s $cluster_id
}

# Make the function available in the current shell
export -f cluster-extend
