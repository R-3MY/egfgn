# EGFGN - EpicGames Free Game Notifier 🎮

[![Docker Image](https://img.shields.io/badge/docker-ghcr.io-blue.svg)](https://github.com/R-3MY/EGFGN/pkgs/container/egfgn)
[![License](https://img.shields.io/badge/license-Custom-green.svg)](LICENSE.md)

Un outil simple et efficace pour ne plus jamais rater les jeux gratuits de l'Epic Games Store. Il envoie des notifications stylisées sur Discord pour les jeux **actuellement gratuits** et les jeux **prochainement disponibles**.

## ✨ Fonctionnalités

- 🚀 **Notifications en temps réel** : Distingue les jeux actifs et à venir.
- 🖼️ **Visuels riches** : Inclut les images des jeux dans les messages Discord.
- 💾 **Persistance** : Utilise un fichier local pour éviter les notifications en double.
- 🐳 **Docker Ready** : Image ultra-légère basée sur `scratch`.

## 🚀 Utilisation Rapide (Docker)

C'est la méthode recommandée. L'image est disponible sur GitHub Container Registry (GHCR).

1. **Préparation** :
   ```bash
   touch notified_games.json
   ```

2. **Lancement** :

   **PowerShell (Windows) :**
   ```powershell
   # Créez le fichier s'il n'existe pas
   if (!(Test-Path notified_games.json)) { New-Item notified_games.json }

   docker run -d `
     --name egfgn `
     --restart unless-stopped `
     --env-file .env `
     -v "notified_games.json:/notified_games.json" `
     ghcr.io/r-3my/egfgn:latest
   ```

   **Bash (Linux/Mac) :**
   ```bash
   touch notified_games.json
   docker run -d \
     --name egfgn \
     --restart unless-stopped \
     --env-file .env \
     -v notified_games.json:/notified_games.json \
     ghcr.io/r-3my/egfgn:latest
   ```

## 🛠️ Installation (Build from Source)

Si vous souhaitez modifier le code ou le lancer localement :

1. **Prérequis** :
   - [Dart SDK](https://dart.dev/get-dart)
   - [Docker](https://docs.docker.com/get-docker/) (optionnel, pour le build d'image)

2. **Clonage** :
   ```bash
   git clone https://github.com/R-3MY/EGFGN.git
   cd EGFGN
   ```

3. **Configuration** :

   **PowerShell (Windows) :**
   ```powershell
   Copy-Item .env.example .env
   # Éditez le fichier .env avec vos propres valeurs
   ```

   **Bash (Linux/Mac) :**
   ```bash
   cp .env.example .env
   # Éditez le fichier .env avec vos propres valeurs
   ```

4. **Installation des dépendances** :
   ```bash
   dart pub get
   ```

5. **Exécution locale** :
   ```bash
   # Le fichier .env est chargé automatiquement par le script
   dart bin/main.dart
   ```

6. **Build Docker local** :
   ```bash
   docker build -t egfgn .
   ```

7. **Lancement (Image locale)** :
   ```bash
   docker run -d --name egfgn --restart unless-stopped --env-file .env -v notified_games.json:/notified_games.json egfgn
   ```

## ⚙️ Configuration

| Variable | Description | Par défaut |
| :--- | :--- | :--- |
| `WEBHOOK_URL` | URL du Webhook Discord (Requis) | - |
| `COUNTRY_CODE` | Code pays pour les offres (ex: FR, US) | `FR` |
| `CHECK_INTERVAL` | Intervalle de vérification en heures | `24` |

## 📜 Licence

Voir le fichier [LICENSE.md](LICENSE.md) pour plus de détails.

## 🤝 Contribution

Les contributions sont les bienvenues ! Veuillez lire le fichier [CONTRIBUTING.md](CONTRIBUTING.md) pour savoir comment soumettre des changements.

---

## 📅 Roadmap / TODO

- [x] **CI/CD** : Tests automatisés et publication Docker via GitHub Actions.
- [ ] **Better Logging** : Passer de `print` au package `logging` pour plus de détails (timestamps, niveaux).
- [ ] **Webhook Regex Check** : Ajouter une validation robuste de l'URL du Webhook Discord au démarrage.
- [ ] **Multi-Channel** : Support pour envoyer les notifications sur plusieurs webhooks simultanément.
