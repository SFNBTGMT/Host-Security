sudo tee /usr/local/bin/pull_backup.sh <<'EOF' > /dev/null
#!/bin/bash
export BORG_PASSPHRASE="MaPassphraseTresSecrete123"
SRC_TEMP="/tmp/backup_source"
REPO_LOCAL="/var/backups/borg-repo-local"

# 1. Nettoyage et préparation du répertoire temporaire
rm -rf "$SRC_TEMP"
mkdir -p "$SRC_TEMP"

# 2. Rapatriement sécurisé des données (PULL) depuis server-hardening
rsync -avz --delete --rsync-path="sudo rsync" \
  -e 'ssh -i /home/vagrant/.ssh/id_ed25519' \
  vagrant@172.28.128.221:/var/www/monapp/ \
  vagrant@172.28.128.221:/etc/nginx/ \
  vagrant@172.28.128.221:/etc/lemonldap-ng/ \
  "$SRC_TEMP/"

# 3. Archivage local chiffré dans Borg
borg create --stats "$REPO_LOCAL"::"backup-$(date +%Y-%m-%d_%H-%M)" "$SRC_TEMP/"

# 4. Rétention des archives (Pruning : 7 jours, 4 semaines)
borg prune -v --keep-daily=7 --keep-weekly=4 "$REPO_LOCAL"

# 5. Nettoyage final des fichiers temporaires en clair
rm -rf "$SRC_TEMP"
EOF

# sudo chmod +x /usr/local/bin/pull_backup.sh
