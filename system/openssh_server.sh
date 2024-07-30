#!/bin/bash

echo "[CODEX][OPENSSH_SERVER]: Restarting..."
sed -i 's/#Port.*/Port 2222/g' /etc/ssh/sshd_config
systemctl restart sshd
echo "[CODEX][OPENSSH_SERVER]: SSH port changed to 2222. SSH service restarted."
