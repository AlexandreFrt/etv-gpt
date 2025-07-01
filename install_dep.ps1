# Télécharge le script d'installation de pyenv-win depuis le dépôt GitHub
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"

# Supprime le script téléchargé après l'installation
Remove-Item -Force ./install-pyenv-win.ps1

# Configure les variables d'environnement pour pyenv-win
$env:PATH="$env:USERPROFILE\.pyenv\pyenv-win\bin;$env:USERPROFILE\.pyenv\pyenv-win\shims;$env:USERPROFILE\.pyenv\pyenv-win\libexec;$env:PATH"

# Enregistre les variables d'environnement pour pyenv-win de manière permanente
setx PATH "$env:USERPROFILE\.pyenv\pyenv-win\bin;$env:USERPROFILE\.pyenv-win\shims;$env:USERPROFILE\.pyenv-win\libexec;$env:PATH"

# Installe Python 3.11 via pyenv
pyenv install 3.11

# Définit Python 3.11 comme version locale
pyenv local 3.11

# Télécharge et installe Poetry, un gestionnaire de dépendances pour Python
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Ajoute le chemin de Poetry aux variables d'environnement
$env:PATH="$env:PATH;$env:APPDATA\Python\Scripts"

# Enregistre le chemin de Poetry de manière permanente
setx PATH "$env:PATH;$env:APPDATA\Python\Scripts\"

# Met à jour Poetry vers la version 1.8.3
poetry self update 1.8.3

# Configure la politique d'exécution pour permettre l'exécution de scripts
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Installe l'outil Make via Chocolatey
choco install make

# Installe les dépendances du projet avec les extras spécifiés
poetry install --extras "ui llms-llama-cpp embeddings-huggingface vector-stores-qdrant"

# Installe l'outil de ligne de commande Hugging Face Hub
pip install -U "huggingface_hub[cli]"

# Initialise le clé huggingface pour l'API
huggingface-cli login

# Demande à l'utilisateur de saisir son token Hugging Face
$hfToken = Read-Host "Entrez votre token Hugging Face"
$env:HF_TOKEN = $hfToken

poetry run python scripts/setup