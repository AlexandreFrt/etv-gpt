# ETV-GPT

Ce projet est basé sur le repo [Private-GPT](https://github.com/zylon-ai/private-gpt).

La documentation complète de private-gpt est disponible sur ce [lien](https://docs.privategpt.dev/overview/welcome/introduction).

## Pré-requis
- **Windows 10/11** : Ce projet est conçu pour fonctionner sur Windows.
- **Python 3.10+** : Assurez-vous d'avoir Python installé.
- **Hugging Face Token** : Un token Hugging Face est nécessaire pour télécharger les modèles. Vous pouvez en obtenir un [ici](https://huggingface.co/settings/tokens).

## 🚀 Installation rapide

Pour installer les dépendances, configurer le projet et activer le support GPU, exécutez les scripts suivants dans cet ordre depuis PowerShell :

```powershell
# 1. Installer les dépendances (pyenv, poetry, make, etc.)
.\install_dep.ps1

# 2. Configurer le projet (Python, HuggingFace, dépendances)
.\setup.ps1

# 3. (Optionnel) Activer le support GPU pour llama-cpp
.\setup_gpu.ps1
```

## ⚙️ Configuration
La configuration du projet se trouve dans le fichier `settings.yaml`. Vous pouvez modifier les paramètres selon vos besoins, notamment les modèles de langage, les chemins d'accès aux données et les options de RAG (Retrieval-Augmented Generation).

### Principales options de configuration (`settings.yaml`)

- **Modèle de langage (LLM)**
  - `llm.mode` : backend utilisé (`llamacpp`, `openai`, etc.)
  - `llamacpp.llm_hf_repo_id` : dépôt Hugging Face du modèle (ex: `MaziyarPanahi/Mistral-Small-Instruct-2409-GGUF`)
  - `llamacpp.llm_hf_model_file` : fichier du modèle à utiliser (ex: `Mistral-Small-Instruct-2409.Q8_0.gguf`)
  - `llm.prompt_style` : style de prompt (`mistral`, `llama3`, etc.)
  - `llm.max_new_tokens` / `llm.context_window` : taille des réponses et fenêtre de contexte

- **Embeddings**
  - `embedding.mode` : backend d'embedding (`huggingface`, etc.)
  - `huggingface.embedding_hf_model_name` : modèle d'embedding Hugging Face (ex: `BAAI/bge-multilingual-gemma2`)
  - `embedding.embed_dim` : dimension des embeddings (ex: 1024)

- **Base de données vectorielle**
  - `vectorstore.database` : type de base (`qdrant`, `chroma`, etc.)
  - `qdrant.path` / `chroma.path` : chemin de stockage local

- **RAG (Retrieval-Augmented Generation)**
  - `rag.similarity_top_k` : nombre de documents contextuels à récupérer
  - `rag.rerank.enabled` : activer le reranking des documents

- **UI**
  - `ui.enabled` : activer/désactiver l'interface web
  - `ui.default_mode` : mode par défaut (`Basic`, `RAG`, etc.)

- **Authentification**
  - `server.auth.enabled` : activer l'authentification API
  - `server.auth.secret` : clé d'authentification

Adaptez ces paramètres selon vos besoins pour personnaliser le comportement du projet.

À chaque modification du fichier `settings.yaml`, il est recommandé d'exécuter la commande :
```batch
poetry run python scripts\setup
```

## 💡 Exécution du projet
Pour exécuter le projet, utilisez le script suivant :

```batch
poetry run python scripts\setup
make run
```

Une fois le projet lancé, vous pouvez accéder à l'interface web si elle est activée, à l'adresse suivante : [http://localhost:8001](http://localhost:8001).
8001 étant le port par défaut, vous pouvez le modifier dans `settings.yaml` si nécessaire.