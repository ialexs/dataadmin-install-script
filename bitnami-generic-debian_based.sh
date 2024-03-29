# /ialexs - 12 May 2021

# ----------------------------
# Set timezone to Asia/Jakarta
# ----------------------------
sudo timedatectl set-timezone Asia/Jakarta

echo "First install. Instance created at: $(date)\n" > /home/bitnami/z_first_install.txt

# ---------------------
# Other essential tools
# ---------------------
sudo apt update -y
sudo apt install dnsutils figlet htop jq mc multitail nmap rsync tmux tmux-plugin-manager tree -y

# ---------------------
# Set env TERM to xterm-256color and set locale to en_US.UTF-8
# ..or your terminal will act like a bytch
# ---------------------

echo "export TERM=xterm-256color" >> /home/bitnami/.bashrc
echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen ; sudo locale-gen

# -----------------
# Adding .tmux.conf
# -----------------
cat << EOF >> /home/bitnami/.tmux.conf

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
#run '~/.tmux/plugins/tpm/tpm'

run '/usr/share/tmux-plugin-manager/tpm' # tpm location install by 'sudo apt install tmux-plugin-manager'
EOF
# -- end tmux configuration

# ------------
# Adding .vimrc
# ------------
cat << EOF >> /home/bitnami/.vimrc
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

# -- end vim configuration

# ---------------------
# Additional personal reference aliases
# ---------------------
wget https://nrd.id/aliases -O /home/bitnami/.bash_aliases

chown bitnami.bitnami /home/bitnami/.bash_aliases /home/bitnami/.vimrc /home/bitnami/.tmux.conf

#-------------
# Remarks
#-------------
echo "Reconfiguration finised at: $(date)" >> /home/bitnami/z_first_install.txt
