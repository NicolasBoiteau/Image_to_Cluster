# 🐳 Atelier DevOps : From Image to Cluster

![Packer](https://img.shields.io/badge/Packer-Build-blue?style=flat&logo=packer)
![Kubernetes](https://img.shields.io/badge/K3d-Cluster-326ce5?style=flat&logo=kubernetes)
![Ansible](https://img.shields.io/badge/Ansible-Deploy-EE0000?style=flat&logo=ansible)
![Status](https://img.shields.io/badge/Status-Success-success)

## 📝 Description du projet

Cet atelier a pour objectif d'industrialiser le cycle de vie d'une application web (Nginx) en utilisant une approche **Infrastructure as Code (IaC)**.

L'idée n'est pas seulement de lancer un conteneur, mais de maîtriser toute la chaîne de production :
1.  **Construction** d'une image immuable personnalisée.
2.  **Provisionning** d'un environnement d'exécution (Cluster K8s).
3.  **Déploiement** automatisé de l'application.

Le tout est exécuté dans un environnement reproductible : **GitHub Codespaces**.

---

## 🏗️ Architecture et Workflow

Le projet suit un pipeline DevOps strict illustré ci-dessous :

```mermaid
graph LR
    A[📄 Code Source<br>index.html] -->|Packer| B(📦 Image Docker<br>mon-nginx-custom:v1)
    B -->|Import| C{☸️ Cluster K3d<br>Server + 2 Agents}
    D[📜 Ansible<br>deploy.yml] -->|Orchestration| C
    C -->|Service NodePort| E[🌍 Navigateur Web]
Les outils utilisés :
Packer (HashiCorp) : Utilisé pour créer une "Golden Image". Contrairement à un simple docker build, Packer permet de standardiser la création d'artefacts. Ici, il génère une image Docker contenant notre page HTML.

K3d (K3s in Docker) : Une distribution Kubernetes légère qui tourne dans des conteneurs Docker. Elle simule un cluster réel avec 1 Maître et 2 Agents.

Ansible : Outil de gestion de configuration. Il dialogue avec l'API Kubernetes pour déployer nos objets (Deployments, Services) de manière idempotente.

Makefile : Le chef d'orchestre qui automatise l'enchaînement des commandes.

🚀 Démarrage Rapide (Automatisation)
Pour répondre aux exigences d'automatisation maximale ("One-Button Deployment"), un fichier Makefile pilote l'ensemble du projet.

Prérequis
Être dans l'environnement GitHub Codespaces du projet.

Lancement en une commande
Ouvrez un terminal et exécutez simplement :

Bash
make all
Que fait cette commande ? Elle exécute séquentiellement toutes les étapes sans intervention humaine :

✅ Install : Installe les dépendances (Packer, Ansible, librairies Python).

✅ Cluster : Initialise le cluster K3d lab.

✅ Build : Lance Packer pour créer l'image et l'importe dans le registre interne de K3d.

✅ Deploy : Lance le playbook Ansible pour déployer l'application.

🔍 Détails des étapes (Pour comprendre)
Si vous souhaitez exécuter les étapes manuellement pour analyser le processus :

Étape 1 : Construction de l'image (Packer)
Packer démarre un conteneur temporaire, y copie le fichier index.html, et sauvegarde le résultat sous le tag mon-nginx-custom:v1.

Bash
packer init template.pkr.hcl
packer build template.pkr.hcl
Étape 2 : Import dans Kubernetes
K3d tourne dans des conteneurs isolés. Il ne voit pas les images Docker de l'hôte par défaut. Nous devons injecter l'image manuellement :

Bash
k3d image import mon-nginx-custom:v1 -c lab
Étape 3 : Déploiement (Ansible)
Ansible applique les manifestes définis dans deploy.yml.

Deployment : Assure qu'une réplique du pod tourne en permanence.

Service (NodePort) : Ouvre un port pour rendre l'application accessible.

Bash
ansible-playbook deploy.yml
🌐 Vérification et Accès
Une fois le déploiement terminé (via make all), l'application tourne sur le port 30080 à l'intérieur du cluster. Pour y accéder depuis le navigateur de Codespaces :

Lancez la commande de redirection :

Bash
kubectl port-forward svc/nginx-service 8081:80
Une notification apparaît en bas à droite ("Open in Browser").

Vous devriez voir la page de succès "MISSION RÉUSSIE".

📂 Structure du Répertoire
Plaintext
.
├── Makefile            # 🤖 Script d'automatisation (Le "Bouton magique")
├── README.md           # 📘 Documentation du projet
├── deploy.yml          # ⚙️ Playbook Ansible (Déploiement K8s)
├── index.html          # 📄 Site web statique personnalisé
└── template.pkr.hcl    # 📦 Configuration Packer (Image builder)
🧹 Nettoyage
Pour supprimer le cluster et nettoyer l'environnement :

Bash
make clean