ARG borgbackup_version="1.1.11"

# Download the binary
FROM "bitnami/minideb:buster" AS downloader
ARG borgbackup_version
RUN install_packages \
	"curl" \
	"ca-certificates"

RUN curl --silent --show-error --location \
	--output "/usr/bin/borg" \
	"https://github.com/borgbackup/borg/releases/download/${borgbackup_version}/borg-linux64"

RUN chmod "+x" "/usr/bin/borg"

# Create the actual container
FROM "bitnami/minideb:buster"
ARG borgbackup_version

# Add the labels for the image
LABEL name="borg-backup"
LABEL summary="Docker Container for the BorgBackup to be used as backup server"
LABEL maintainer="Mira 'Mireiawen' Manninen"
LABEL version="${borgbackup_version}"


# Set up the backup user
RUN useradd \
	--create-home \
	--user-group \
	--shell "/bin/bash" \
	--comment "Backup User" \
	"borgbackup"

RUN ln --symbolic \
	"/home/borgbackup" \
	"/backups"

# Install the SSH server
RUN install_packages \
	"openssh-server"

RUN mkdir "/run/sshd"

# Install the actual backup
COPY --from=downloader \
	"/usr/bin/borg" \
	"/usr/bin/borg"

# Define the directory volumes
VOLUME [ "/home/borgbackup" ]

# Expose the SSH port
EXPOSE 22

# Set the entry point
COPY "start.sh" "/start.sh"
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/start.sh" ]
