# 🐳 Atelier DevOps — From Image to Cluster

![Packer](https://img.shields.io/badge/Packer-Build-blue?style=flat\&logo=packer)
![Kubernetes](https://img.shields.io/badge/K3d-Cluster-326ce5?style=flat\&logo=kubernetes)
![Ansible](https://img.shields.io/badge/Ansible-Deploy-EE0000?style=flat\&logo=ansible)
![Status](https://img.shields.io/badge/Status-Success-success)

---

## 📝 Description du projet

Cet atelier a pour objectif d’**industrialiser le cycle de vie d’une application web Nginx** en adoptant une approche **Infrastructure as Code (IaC)**.

L’ambition n’est pas simplement de lancer un conteneur, mais de **maîtriser toute la chaîne de production**, de la construction de l’image jusqu’au déploiement sur un cluster Kubernetes.

Le projet couvre les étapes suivantes :

1. **Construction** d’une image immuable personnalisée
2. **Provisioning** d’un environnement d’exécution (cluster Kubernetes)
3. **Déploiement** automatisé de l’application

L’ensemble est exécuté dans un environnement **100 % reproductible** grâce à **GitHub Codespaces**.

---

## 🏗️ Architecture et workflow

Le projet suit un pipeline DevOps strict, illustré ci-dessous :

```mermaid
graph LR
    A[📄 Code source<br/>index.html]
    -->|Packer|
    B[📦 Image Docker<br/>mon-nginx-custom:v1]

    B -->|Import|
    C[☸️ Cluster K3d<br/>1 Server + 2 Agents]

    D[📜 Ansible<br/>deploy.yml]
    -->|Orchestration|
    C

    C -->|Service NodePort|
    E[🌍 Navigateur Web]
```

---

## 🧰 Outils utilisés

### 🔹 Packer (HashiCorp)

Utilisé pour créer une **Golden Image**. Contrairement à un simple `docker build`, Packer permet de standardiser la création d’artefacts. Ici, il génère une image Docker contenant notre page HTML personnalisée.

### 🔹 K3d (K3s in Docker)

Distribution Kubernetes légère fonctionnant dans des conteneurs Docker. Elle permet de simuler un cluster réel avec **1 nœud maître et 2 agents**.

### 🔹 Ansible

Outil de gestion de configuration et d’orchestration. Il dialogue avec l’API Kubernetes pour déployer les ressources (**Deployment**, **Service**) de manière **idempotente**.

### 🔹 Makefile

Le **chef d’orchestre** du projet. Il automatise l’enchaînement des commandes pour offrir une expérience *One-Button Deployment*.

---

## 🚀 Démarrage rapide — One‑Button Deployment

Pour répondre aux exigences d’automatisation maximale, un **Makefile** pilote l’ensemble du projet.

### ✅ Prérequis

* Être dans l’environnement **GitHub Codespaces** du projet

### ▶️ Lancement en une seule commande

```bash
make all
```

### 🔍 Que fait cette commande ?

Elle exécute séquentiellement toutes les étapes **sans intervention humaine** :

* ✅ **Install** : installation des dépendances (Packer, Ansible, librairies Python)
* ✅ **Cluster** : création du cluster K3d `lab`
* ✅ **Build** : construction de l’image Docker avec Packer et import dans K3d
* ✅ **Deploy** : déploiement de l’application via Ansible

---

## 🧠 Détails des étapes (mode pédagogique)

### 🧱 Étape 1 — Construction de l’image (Packer)

Packer démarre un conteneur temporaire, y copie le fichier `index.html`, puis sauvegarde le résultat sous le tag `mon-nginx-custom:v1`.

```bash
packer init template.pkr.hcl
packer build template.pkr.hcl
```

---

### 📦 Étape 2 — Import de l’image dans Kubernetes

K3d s’exécute dans des conteneurs isolés et ne voit pas automatiquement les images Docker de l’hôte. L’image doit donc être injectée manuellement :

```bash
k3d image import mon-nginx-custom:v1 -c lab
```

---

### ⚙️ Étape 3 — Déploiement avec Ansible

Ansible applique les manifestes Kubernetes définis dans `deploy.yml` :

* **Deployment** : garantit qu’un pod Nginx tourne en permanence
* **Service (NodePort)** : expose l’application à l’extérieur du cluster

```bash
ansible-playbook deploy.yml
```

---

## 🌐 Vérification et accès à l’application

Une fois le déploiement terminé (`make all`), l’application est exposée dans le cluster.

Pour y accéder depuis GitHub Codespaces, lancez la redirection de port suivante :

```bash
kubectl port-forward svc/nginx-service 8081:80
```

➡️ Une notification *"Open in Browser"* apparaît.

🎉 Vous devriez voir la page de succès affichant : **MISSION RÉUSSIE**.

---

## 📂 Structure du projet

```plaintext
.
├── Makefile            # 🤖 Script d’automatisation (le bouton magique)
├── README.md           # 📘 Documentation du projet
├── deploy.yml          # ⚙️ Playbook Ansible (déploiement Kubernetes)
├── index.html          # 📄 Page web statique personnalisée
└── template.pkr.hcl    # 📦 Configuration Packer (image builder)
```

---

## 🧹 Nettoyage

Pour supprimer le cluster et nettoyer l’environnement :

```bash
make clean
```

---

✨ **Atelier DevOps — Build once, deploy everywhere.**
