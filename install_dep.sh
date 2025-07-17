#!/bin/bash

# Installe les dépendances système nécessaires pour pyenv (Debian/Ubuntu)
echo "Installation des dépendances système pour pyenv..."
sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev git

# Télécharge et installe pyenv
echo "Installation de pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
else
    echo "pyenv est déjà installé"
fi

# Configure les variables d'environnement pour pyenv
echo "Configuration des variables d'environnement pour pyenv..."
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Ajoute pyenv au fichier de profil approprié
if [ -f "$HOME/.bashrc" ]; then
    PROFILE_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    PROFILE_FILE="$HOME/.zshrc"
elif [ -f "$HOME/.profile" ]; then
    PROFILE_FILE="$HOME/.profile"
else
    PROFILE_FILE="$HOME/.bashrc"
    touch "$PROFILE_FILE"
fi

# Vérifie si pyenv n'est pas déjà configuré dans le profil
if ! grep -q "PYENV_ROOT" "$PROFILE_FILE"; then
    echo "" >> "$PROFILE_FILE"
    echo "# Configuration pyenv" >> "$PROFILE_FILE"
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$PROFILE_FILE"
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> "$PROFILE_FILE"
    echo 'eval "$(pyenv init -)"' >> "$PROFILE_FILE"
    echo "Configuration pyenv ajoutée à $PROFILE_FILE"
fi

# Initialise pyenv pour la session actuelle
eval "$(pyenv init -)"

# Télécharge et installe Poetry
echo "Installation de Poetry..."
if ! command -v poetry &> /dev/null; then
    curl -sSL https://install.python-poetry.org | python3 -
    
    # Ajoute Poetry au PATH
    export PATH="$HOME/.local/bin:$PATH"
    
    # Ajoute Poetry au fichier de profil s'il n'y est pas déjà
    if ! grep -q "/.local/bin" "$PROFILE_FILE"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$PROFILE_FILE"
        echo "Poetry ajouté au PATH dans $PROFILE_FILE"
    fi
else
    echo "Poetry est déjà installé"
fi

# Met à jour Poetry vers la version 1.8.3
echo "Mise à jour de Poetry vers la version 1.8.3..."
poetry self update 1.8.3

# Installe Make si nécessaire
echo "Vérification de l'installation de Make..."
if ! command -v make &> /dev/null; then
    sudo apt-get install -y make
else
    echo "Make est déjà installé"
fi

# Installe l'outil de ligne de commande Hugging Face Hub
echo "Installation de l'outil CLI Hugging Face Hub..."
pip3 install -U "huggingface_hub[cli]"

echo ""
echo "Installation terminée!"
echo "Veuillez redémarrer votre terminal ou exécuter 'source $PROFILE_FILE' pour que les changements prennent effet."
