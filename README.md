# ETV-GPT

Ce projet est basé sur le repo [Private-GPT](https://github.com/zylon-ai/private-gpt).

La documentation complète de private-gpt est disponible sur ce [lien](https://docs.privategpt.dev/overview/welcome/introduction).

## Pré-requis

- **Windows 10/11** : Ce projet est conçu pour fonctionner sur Windows
- **Python 3.10+** : Assurez-vous d'avoir Python installé
- **Hugging Face Token** (optionnel) : Nécessaire uniquement si vous devez télécharger des modèles depuis Hugging Face. Si les modèles sont déjà téléchargés localement, ce token n'est pas requis. Vous pouvez en obtenir un [ici](https://huggingface.co/settings/tokens)

## Installation

### 1. Installation des dépendances
Exécutez les scripts suivants dans cet ordre depuis PowerShell :

```powershell
# 1. Installer les dépendances système (pyenv, poetry, make, etc.)
.\install_dep.ps1

# 2. Configurer le projet (Python, HuggingFace, dépendances)
.\setup.ps1

# 3. (Optionnel) Activer le support GPU pour llama-cpp
.\setup_gpu.ps1
```

### 2. Configuration initiale
Après l'installation, configurez votre token Hugging Face si nécessaire :

```batch
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
> ```batch
> poetry run python scripts\setup
> ```

## 🔧 Gestion des modèles

### Utiliser un modèle local existant
Si vous avez déjà un modèle téléchargé localement, modifiez `settings.yaml` :

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

```batch
.\start.bat
```

### Accès à l'interface
- **Interface web** : Disponible à [http://localhost:8001](http://localhost:8001) uniquement si `ui.enabled` est activé dans `settings.yaml`
- **API** : Accessible même si l'interface web est désactivée
- **Port** : Modifiable dans `settings.yaml` (8001 par défaut)

## Documentation supplémentaire

Pour plus d'informations détaillées, consultez la [documentation officielle de Private-GPT](https://docs.privategpt.dev/overview/welcome/introduction).