#!/bin/bash
set -e

# Check for the SSH key
if [ -n "${SSH_KEY}" ]
then
	echo "Setting up the user SSH key..."
	mkdir --parents "/home/borgbackup/.ssh"
	chmod "u=rwx,go=" "/home/borgbackup/.ssh"
	chown "borgbackup:" "/home/borgbackup/.ssh"
	echo -e "${SSH_KEY}" >"/home/borgbackup/.ssh/authorized_keys"
	chown "borgbackup:" "/home/borgbackup/.ssh/authorized_keys"
	echo "User SSH key is set."
else
	echo "No user SSH key is given, unless the volume is mounted and contains working SSH configuration, no access is allowed!"
fi

# Launch the SSHD daemon
/usr/sbin/sshd -D
