# v.002 - For Debian based
# *NOT for any of Bitnami's instance

# ----------------------
# Set timezone to Asia/Jakarta
# ----------------------
`sudo timedatectl set-timezone Asia/Jakarta`

echo "First install. Instance created at: $(date)\n" > /home/admin/z_first_install.txt
echo "... wait for configuration finished notification below this line" >> /home/admin/z_first_install.txt

# ----------------------
# Update & upgrade Debian image fresh install on AWS
# ----------------------
sudo apt update -y ;  sudo apt upgrade -y

# ---------------------
# Other essential tools
# ---------------------
sudo apt install dnsutils figlet htop jq mc multitail nmap rsync tmux tmux-plugin-manager tree -y

# ---------------------
# Set env TERM to xterm-256color and set locale to en_US.UTF-8
# ..or your terminal will act like a bytch
# ---------------------
echo -e "\nexport TERM=xterm-256color" >> /home/admin/.bashrc
echo -e "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen ; sudo locale-gen

# ----------------------
# -- dockering start ---
# ----------------------

# Dockering? Install Docker. If no, just keep these closed.
# ----------------------
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Install Docker Compose
# ----------------------
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add the default user 'admin' to 'docker' group
# ----------------------
sudo usermod -aG docker admin

# ---------------------
# -- dockering end ----
# ---------------------

# ---------------------
# Additional personal reference aliases
# ---------------------
wget https://nrd.id/bash_profile -O /home/admin/.bash_aliases
chown admin.admin /home/admin/.bash_aliases

# Adding things to .bash_aliases
cat << EOF >> /home/admin/.bash_aliases

# Aliases Ritual de lo habitual

alias mc='mc -b'
alias whatip='curl -s ipinfo.io/json | jq'

# Dockering
alias dde='echo "docker die exited"; docker rm $(docker ps -a -q -f status=exited)'
alias docker-die-exited='docker rm $(docker ps -a -q -f status=exited)'
alias docker-die-network='docker network ls ; docker network prune -f ; echo -e "mampuss..done. \n\nSisa default: "; docker network ls'
alias docker-die-stop-kill-all='docker stop $(docker ps -q); docker volume prune ; docker-die-exited ; docker-die-network'
alias docui='docker run --rm -itv /var/run/docker.sock:/var/run/docker.sock skanehira/docui'
alias dpsa='docker ps -a'
EOF

# Adding .tmux.conf
cat << EOF >> /home/admin/.tmux.conf

# Reload the conf with <prefix> 'r'
bind r source-file ~/.tmux.conf

# Enable mouse mode (tmux 2.1 and above)
set -g mouse on

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Ressurect and Continuum /ialexs Wed Nov  7 10:53:58 WIB 2018
# https://medium.com/doomhammers-toolbox/tmux-real-estate-agent-for-your-computer-257444d4ac34

set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

run '/usr/share/tmux-plugin-manager/tpm' # tpm location install by 'sudo apt install tmux-plugin-manager'
EOF

# Adding .vimrc
cat << EOF >> /home/admin/.vimrc
"minimalist vim

:set cursorcolumn cursorline    "set cursor column
colorscheme elflord             "my eyes

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END"
EOF


# -------------
# Need caddy? (for reverse proxy with SSL)
# -- Update: NO, we use install Caddy by docker-compose. Not by OS install.
# -------------
# sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
# curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/gpg/gpg.155B6D79CA56EA34.key' | sudo apt-key add -
# curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/setup/config.deb.txt?distro=debian&version=any-version' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
# sudo apt update
# sudo apt install caddy

#-------------
# Remarks
#-------------
echo "Reconfiguration finised at: $(date)" >> /home/admin/z_first_install.txt
