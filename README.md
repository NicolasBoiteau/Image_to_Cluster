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

    ## 🚀 Démarrage Rapide (Automatisation)

Pour simplifier l'évaluation et l'utilisation, un fichier `Makefile` a été mis en place. Il permet de lancer l'intégralité du projet en **une seule commande**.

### Installation et Lancement
Ouvrez un terminal et exécutez :

```bash
make all