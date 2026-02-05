.PHONY: all run install cluster build deploy clean

# Si tu tapes "make run", ça lance "make all"
run: all

# La commande magique qui fait tout
all: install cluster build deploy

# 1. INSTALLATION (Packer, Ansible, K3d, Libs Python)
install:
	@echo "🛠️  Installation des outils..."
	# On vire le fichier qui bloque les mises à jour (Yarn)
	sudo rm -f /etc/apt/sources.list.d/yarn.list
	# On s'assure d'avoir curl et les outils de base
	sudo apt-get update || true
	sudo apt-get install -y curl software-properties-common
	# AJOUT DU DÉPÔT HASHICORP (POUR PACKER)
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $$(lsb_release -cs) main" -y
	# Mise à jour après ajout du dépôt
	sudo apt-get update || true
	# Installation finale
	sudo apt-get install packer ansible python3-kubernetes -y
	# Installation du module Ansible pour K8s
	ansible-galaxy collection install kubernetes.core
	# Installation de K3d (si pas présent)
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# 2. CRÉATION DU CLUSTER
cluster:
	@echo "☸️  Création du cluster K3d..."
	k3d cluster create lab --servers 1 --agents 2 || echo "Le cluster existe déjà, on continue..."

# 3. BUILD PACKER & IMPORT
build:
	@echo "📦 Construction de l'image Packer..."
	packer init template.pkr.hcl
	packer build template.pkr.hcl
	@echo "📥 Import de l'image dans le cluster..."
	k3d image import mon-nginx-custom:v1 -c lab

# 4. DÉPLOIEMENT ANSIBLE
deploy:
	@echo "🚀 Déploiement via Ansible..."
	ansible-playbook deploy.yml

# NETTOYAGE
clean:
	@echo "🧹 Suppression du cluster..."
	k3d cluster delete lab