#!/bin/bash

# Vérifie si CUDA est déjà installé
echo "Vérification de l'installation de CUDA..."
if command -v nvcc &> /dev/null; then
    CUDA_VERSION=$(nvcc --version | grep "release" | sed 's/.*release \([0-9.]*\).*/\1/')
    echo "CUDA $CUDA_VERSION est déjà installé"
    
    # Vérifie si c'est la version 12.9 ou compatible
    if [[ "$CUDA_VERSION" == 11.* ]] || [[ "$CUDA_VERSION" > "11.0" ]]; then
        echo "Version CUDA compatible détectée. Installation de CUDA ignorée."
        CUDA_ALREADY_INSTALLED=true
    else
        echo "Version CUDA $CUDA_VERSION détectée, mais version 12.9+ requise. Mise à jour..."
        CUDA_ALREADY_INSTALLED=false
    fi
else
    echo "CUDA non détecté. Installation en cours..."
    CUDA_ALREADY_INSTALLED=false
fi

# Installe CUDA seulement si nécessaire
if [ "$CUDA_ALREADY_INSTALLED" = false ]; then
    echo "Téléchargement et installation de CUDA 12.9..."
    wget https://developer.download.nvidia.com/compute/cuda/12.9.1/local_installers/cuda-repo-debian12-12-9-local_12.9.1-575.57.08-1_amd64.deb
    sudo dpkg -i cuda-repo-debian12-12-9-local_12.9.1-575.57.08-1_amd64.deb
    sudo cp /var/cuda-repo-debian12-12-9-local/cuda-*-keyring.gpg /usr/share/keyrings/
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-9
    
    # Nettoie le fichier .deb téléchargé
    rm -f cuda-repo-debian12-12-9-local_12.9.1-575.57.08-1_amd64.deb
    
    echo "Installation de CUDA terminée"
fi

# Installation de llama-cpp-python avec support CUDA
echo "Installation de llama-cpp-python avec support CUDA..."
CMAKE_ARGS='-DLLAMA_CUBLAS=on' poetry run pip install --force-reinstall --no-cache-dir llama-cpp-python numpy==1.26.0

echo "Configuration GPU terminée!"
