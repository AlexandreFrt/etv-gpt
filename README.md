# ETV-GPT

Ce projet est basé sur le repo [Private-GPT](https://github.com/zylon-ai/private-gpt).

La documentation complète de private-gpt est disponible sur ce [lien](https://docs.privategpt.dev/overview/welcome/introduction).

## Pré-requis

- **Windows 10/11 ou Debian** : Ce projet est conçu pour fonctionner sur Windows et Debian
- **Python 3.10+** : Assurez-vous d'avoir Python installé
- **Hugging Face Token** (optionnel) : Nécessaire uniquement si vous devez télécharger des modèles depuis Hugging Face. Si les modèles sont déjà téléchargés localement, ce token n'est pas requis. Vous pouvez en obtenir un [ici](https://huggingface.co/settings/tokens)
- **GPU (optionnel)** : Si vous souhaitez utiliser un GPU pour l'accélération, installez les pilotes CUDA et cuDNN appropriés

## Installation

### 1. Installation des dépendances

#### Sur Windows
Exécutez les scripts suivants dans cet ordre depuis PowerShell :

```powershell
# 1. Installer les dépendances système (pyenv, poetry, make, etc.)
.\install_dep.ps1

# 2. Configurer le projet (Python, HuggingFace, dépendances)
.\setup.ps1

# 3. (Optionnel) Activer le support GPU pour llama-cpp
.\setup_gpu.ps1
```

#### Sur Linux (Debian/Ubuntu)
Exécutez les scripts suivants dans cet ordre depuis le terminal :

```bash
# 1. Installer les dépendances système (pyenv, poetry, make, etc.)
chmod +x install_dep.sh
./install_dep.sh

# 2. Configurer le projet (Python, HuggingFace, dépendances)
chmod +x setup.sh
./setup.sh

# 3. (Optionnel) Activer le support GPU pour llama-cpp
chmod +x setup_gpu.sh
./setup_gpu.sh
```

### 2. Configuration initiale
Après l'installation, configurez votre token Hugging Face si nécessaire :

**Sur Windows :**
```bash
huggingface-cli login
```

## Configuration

La configuration du projet se trouve dans le fichier `settings.yaml`. Voici les principales options à personnaliser :

### Modèle de langage (LLM)
- `llm.mode` : Backend utilisé (`llamacpp`, `openai`, etc.)
- `llamacpp.llm_hf_repo_id` : Dépôt Hugging Face du modèle
- `llamacpp.llm_hf_model_file` : Fichier du modèle à utiliser
- `llm.prompt_style` : Style de prompt (`mistral`, `llama3`, etc.)
- `llm.max_new_tokens` / `llm.context_window` : Taille des réponses et fenêtre de contexte

### Embeddings
- `embedding.mode` : Backend d'embedding (`huggingface`, etc.)
- `huggingface.embedding_hf_model_name` : Modèle d'embedding Hugging Face (ex: `BAAI/bge-multilingual-gemma2`)
- `embedding.embed_dim` : Dimension des embeddings (ex: 1024)

### Base de données vectorielle
- `vectorstore.database` : Type de base (`qdrant`, `chroma`, etc.)
- `qdrant.path` / `chroma.path` : Chemin de stockage local

### RAG (Retrieval-Augmented Generation)
- `rag.similarity_top_k` : Nombre de documents contextuels à récupérer
- `rag.rerank.enabled` : Activer le reranking des documents

### Interface utilisateur
- `ui.enabled` : Activer/désactiver l'interface web
- `ui.default_mode` : Mode par défaut (`Basic`, `RAG`, etc.)

### Authentification
- `server.auth.enabled` : Activer l'authentification API
- `server.auth.secret` : Clé d'authentification

> [!IMPORTANT]
> À chaque modification du fichier `settings.yaml`, exécutez :
> 
> **Sur Windows :**
> ```batch
> poetry run python scripts\setup
> ```
> 
> **Sur Linux :**
> ```bash
> poetry run python scripts/setup
> ```

## Gestion des modèles

### Utiliser un modèle local existant
Si vous avez déjà un modèle téléchargé localement, mettez votre fichier .gguf dans le dossier `models/` et modifiez `settings.yaml` :

```yaml
llamacpp:
  llm_hf_repo_id: none
  llm_hf_model_file: NomModele.gguf  # Nom du fichier du modèle local
```

### Télécharger un nouveau modèle depuis Hugging Face
Si vous souhaitez télécharger un modèle depuis Hugging Face, suivez ces étapes :
1. Assurez-vous que votre token Hugging Face est configuré :
   ```batch
   huggingface-cli login
   ```

2. Modifiez `settings.yaml` :
   ```yaml
   llamacpp:
     llm_hf_repo_id: Utilisateur/NomDuModele  # Dépôt Hugging Face
     llm_hf_model_file: NomModele.gguf        # Nom du fichier
   ```

## Lancement du projet

Pour démarrer le projet :

**Sur Windows :**
```batch
.\start.bat
```

**Sur Linux :**
```bash
chmod +x start.sh
./start.sh
```

### Accès à l'interface
- **Interface web** : Disponible à [http://localhost:8001](http://localhost:8001) uniquement si `ui.enabled` est activé dans `settings.yaml`
- **API** : Accessible même si l'interface web est désactivée
- **Port** : Modifiable dans `settings.yaml` (8001 par défaut)

## Documentation supplémentaire

Pour plus d'informations détaillées, consultez la [documentation officielle de Private-GPT](https://docs.privategpt.dev/overview/welcome/introduction).

## Structure du projet

Voici les dossiers et fichiers principaux du projet :

- `private_gpt/` : Code principal
- `models/` : Modèles locaux (.gguf)
- `local_data/` : Données et index
- `scripts/` : Scripts utilitaires
- `settings.yaml` : Configuration principale

## Mise à jour du projet

**Mettre à jour les dépendances Python :**
```powershell
poetry install
```
```bash
poetry install
```

## Exemple d'utilisation de l'API

### Endpoints disponibles

#### 1. Vérification de l'état du service
- **Méthode** : GET `/health`
- **Paramètres** : Aucun
- **Réponse** :
  - `status` : indique l'état du service (`ok` si l'IA est opérationnelle)

Exemple de réponse :
```json
{
  "status": "ok"
}
```

#### 2. Envoi d'une requête à l'IA
- **Méthode** : POST `/v1/chat/completions`
- **Corps de la requête (JSON)** :
  - `context_filter` (object, optionnel) : filtre contextuel
    - `docs_ids` (array[string]) : liste d'identifiants de documents à utiliser comme contexte
  - `include_sources` (boolean, optionnel) : inclure les sources citées dans la réponse
  - `messages` (array[object], requis)
    - `role` (string) : rôle de l'expéditeur (`system`, `user`)
      - `system` : Définit le contexte ou les instructions pour l'IA (ex : "Vous êtes l'assistant ETV, un expert technique virtuel...").
      - `user` : Contient la question ou la demande de l'utilisateur (ex : "Comment démonter un ordinateur portable ?").
    - `content` (string) : contenu du message
  - `stream` (boolean, optionnel) : active le streaming de la réponse
  - `use_context` (boolean, optionnel) : utilise le contexte provenant des documents ingérés pour générer la réponse

Exemple de requête :
```json
{
  "context_filter": {
    "docs_ids": [
      "c202d5e6-7b69-4869-81cc-dd574ee8ee11"
    ]
  },
  "include_sources": true,
  "messages": [
    {
      "role": "system",
      "content": "Vous êtes l'assistant ETV, un expert technique virtuel..."
    },
    {
      "role": "user",
      "content": "Comment démonter un ordinateur portable ?"
    }
  ],
  "stream": false,
  "use_context": true
}
```

**Réponse attendue :**
- `choices` (array)
  - `message` (object)
    - `role` (string) : rôle de l'expéditeur (`assistant`)
    - `content` (string) : texte de la réponse générée
  - `sources` (array) : liste des sources citées dans la réponse

Exemple de réponse :
```json
{
  "id": "8d8e8423-de2e-4bbd-b0ee-e521afe2a9f4",
  "object": "completion",
  "created": 1751358113,
  "model": "private-gpt",
  "choices": [
    {
      "finish_reason": "stop",
      "delta": null,
      "message": {
        "role": "assistant",
        "content": "Pour démonter un ordinateur portable :\n\n1. Éteignez l'ordinateur et débranchez-le.\n2. Retirez la batterie si possible.\n3. Dévissez les vis du boîtier arrière.\n4. Utilisez un outil d'ouverture pour séparer le boîtier.\n5. Déconnectez les câbles internes avec précaution.\n6. Retirez les composants internes (disque dur, RAM, etc.) selon vos besoins."
      },
      "sources": [],
      "index": 0
    }
  ]
}
```

Pour interroger l'API localement sous Windows :

```powershell
curl -X POST http://localhost:8001/v1/chat/completions -H "Content-Type: application/json" -d "{""messages"": [{""role"": ""user"", ""content"": ""Bonjour, que peux-tu faire ?""}]}"
```

Sous Linux ou dans un terminal Bash :

```bash
curl -X POST http://localhost:8001/v1/chat/completions -H "Content-Type: application/json" -d '{"messages": [{"role": "user", "content": "Bonjour, que peux-tu faire ?"}]}'
```

## FAQ / Dépannage

**Q : J'ai une erreur lors de l'installation des dépendances.**  
A : Vérifiez la version de Python (`python --version`). Utilisez Python 3.10 ou 3.11. Installez les dépendances avec les scripts fournis.

**Q : Le GPU n'est pas détecté.**  
A : Vérifiez l'installation de CUDA/cuDNN et que votre carte est compatible. Consultez la documentation de llama.cpp.

**Q : Problème d'accès à l'API ou à l'interface web.**  
A : Vérifiez que le port 8001 n'est pas bloqué et que `ui.enabled` est activé dans `settings.yaml`.

## Contribution et support

Les contributions sont les bienvenues ! Pour proposer une amélioration ou signaler un bug, ouvrez une issue sur le dépôt GitHub ou contactez le mainteneur.