clear
#
ansible-inventory -y --list
#
#ansible-playbook -v --limit gh-windows_users run-windows.yml # works
ansible-playbook -v --limit gh-windows_users run-windows-winrm.yml # works
#
#
# things that have to be setup on windows pcs for this to work

# https://winscp.net/eng/docs/guide_windows_openssh_server

# https://adamtheautomator.com/openssh-windows/
