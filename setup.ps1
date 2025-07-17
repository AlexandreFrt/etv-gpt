# Installe Python 3.11 via pyenv
pyenv install 3.11

# Définit Python 3.11 comme version locale
pyenv local 3.11

# Demande à l'utilisateur s'il souhaite saisir son token Hugging Face
$addHfToken = Read-Host "Voulez-vous ajouter votre token Hugging Face maintenant ? (o/N)"
if ($addHfToken -eq "o") {
    huggingface-cli login
    $hfToken = Read-Host "Entrez votre token Hugging Face"
    $env:HF_TOKEN = $hfToken
}

# Exécute le script de configuration du projet
poetry run python scripts/setup

# Installe les dépendances du projet avec les extras spécifiés
poetry install --extras "ui llms-llama-cpp embeddings-huggingface vector-stores-qdrant"