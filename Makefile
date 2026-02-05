# Makefile pour le projet Image to Cluster

.PHONY: all install cluster build deploy clean

# 1. Tout installer et lancer (La commande magique)
all: install cluster build deploy

# 2. Installation des outils (si besoin)
install:
	@echo "Installation des dépendances..."
	sudo apt-get update || true
	sudo apt-get install packer ansible python3-kubernetes -y

# 3. Création du cluster K3d
cluster:
	@echo "Création du cluster K3d..."
	k3d cluster create lab --servers 1 --agents 2 || echo "Le cluster existe déjà"

# 4. Build de l'image Packer et import dans K3d
build:
	@echo "Construction de l'image Packer..."
	packer init template.pkr.hcl
	packer build template.pkr.hcl
	@echo "Import de l'image dans K3d..."
	k3d image import mon-nginx-custom:v1 -c lab

# 5. Déploiement Ansible
deploy:
	@echo "Déploiement via Ansible..."
	ansible-playbook deploy.yml

# 6. Nettoyage
clean:
	@echo "Suppression du cluster..."
	k3d cluster delete lab