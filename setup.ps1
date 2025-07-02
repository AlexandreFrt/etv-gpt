# Installe Python 3.11 via pyenv
pyenv install 3.11

# Définit Python 3.11 comme version locale
pyenv local 3.11

# Initialise le clé huggingface pour l'API
huggingface-cli login

# Demande à l'utilisateur de saisir son token Hugging Face
$hfToken = Read-Host "Entrez votre token Hugging Face"
$env:HF_TOKEN = $hfToken

# Exécute le script de configuration du projet
poetry run python scripts/setup

# Installe les dépendances du projet avec les extras spécifiés
poetry install --extras "ui llms-llama-cpp embeddings-huggingface vector-stores-qdrant"