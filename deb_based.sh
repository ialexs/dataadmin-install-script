# v.002 - For Debian based
# *NOT for any of Bitnami's instance
# Assuming the instance using default user 'admin'

# Set timezone to Asia/Jakarta
$(sudo timedatectl set-timezone Asia/Jakarta)

echo "First install. Instance created at: $(date)\n" >/home/admin/z_first_install.txt
echo "... wait for configuration finished notification below this line" >>/home/admin/z_first_install.txt

# Update & upgrade Debian image fresh install on AWS
sudo apt update -y
sudo apt upgrade -y

# Other essential tools
sudo apt install dnsutils figlet htop jq mc multitail nmap rsync tmux tmux-plugin-manager tree wget -y

# Set env TERM to xterm-256color and set locale to en_US.UTF-8
# ..or your terminal will act like a bytch
echo -e "\nexport TERM=xterm-256color" >>/home/admin/.bashrc
echo -e "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen

# Additional personal reference aliases
wget https://nrd.id/aliases -O /home/admin/.bash_aliases
chown admin.admin /home/admin/.bash_aliases

# Adding .tmux.conf
cat <<EOF >>/home/admin/.tmux.conf

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
cat <<EOF >>/home/admin/.vimrc
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

# Remarks
echo "Reconfiguration finised at: $(date)" >>/home/admin/z_first_install.txt
