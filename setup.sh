#!/bin/bash

# Installe Python 3.11 via pyenv
pyenv install 3.11

# Définit Python 3.11 comme version locale
pyenv local 3.11

# Demande à l'utilisateur s'il souhaite saisir son token Hugging Face
read -p "Voulez-vous ajouter votre token Hugging Face maintenant ? (o/N): " add_hf_token
if [[ "$add_hf_token" == "o" || "$add_hf_token" == "O" ]]; then
    huggingface-cli login
    read -p "Entrez votre token Hugging Face: " hf_token
    export HF_TOKEN="$hf_token"
fi

# Exécute le script de configuration du projet
poetry run python scripts/setup

# Installe les dépendances du projet avec les extras spécifiés
poetry install --extras "ui llms-llama-cpp embeddings-huggingface vector-stores-qdrant"
