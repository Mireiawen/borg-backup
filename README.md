# BorgBackup
Docker Container for the [BorgBackup](https://www.borgbackup.org/) to be used as backup server

Dockerfile contains the following
- [Bitnami Minideb](https://hub.docker.com/r/bitnami/minideb/) based on [Debian Buster](https://www.debian.org/)
- BorgBackup
- OpenSSH server

## Running
Run this container with the following options to run container with specified SSH key

```
docker run \
	--detach \
	--env "SSH_KEY=<ssh public key>"
	--publish "22:22" \
	"mireiawen/borg-backup"
```

Run this container by using a volume mount of the local directory to store the backups on local disk,
the disk may already contain `.ssh` folder with keys and such
```
docker run \
	--detach \
	--publish "22:22" \
	--volume "/path/to/backups:/home/borgbackup"
	"mireiawen/borg-backup"
```
