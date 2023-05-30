#!/bin/bash

# Vérification de l'installation de curl
if ! command -v curl &> /dev/null; then
    echo "Installation de curl..."
    sudo apt-get update
    sudo apt-get install -y curl
    echo "curl installé avec succès !"
fi

# Installation de Node.js
echo "Installation de Node.js..."
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "Node.js installé avec succès !"

# Installation des modules nécessaires
echo "Installation des modules Node.js..."
cd "$(dirname "$0")"  # Se déplacer dans le répertoire du script actuel
npm install
echo "Modules installés avec succès !"

# Récupération du nom d'utilisateur de l'utilisateur courant
CURRENT_USER=$(whoami)

# Création du service systemd
SERVICE_FILE="/etc/systemd/system/node-code.service"

sudo tee $SERVICE_FILE > /dev/null << EOF
[Unit]
Description=My Node.js Service
After=network.target

[Service]
WorkingDirectory=$(pwd)
ExecStart=$(which node) index.js
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=node-code
User=$CURRENT_USER

[Install]
WantedBy=multi-user.target
EOF

# Rechargement des services systemd
sudo systemctl daemon-reload

# Activation du service
sudo systemctl enable node-code

# Démarrage du service
sudo systemctl start node-code

# Vérification de l'état du service
echo "Le service est configuré et en cours d'exécution."
sudo systemctl status node-code
