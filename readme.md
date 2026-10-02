# Host Security - Virtualized & Infrastructure

##  Contexte du Projet
L'entreprise est conçue comme un hébergeur de services où la sécurité n'est pas seulement 
appliquée de manière "invisible", mais devient accessible pour les administrateurs. 

## L'énonce du projet
[travail-hs.pdf](https://github.com/user-attachments/files/32908897/travail-hs.pdf)

## illustration du projet
<img width="1257" height="821" alt="Image" src="https://github.com/user-attachments/assets/bad2b9b3-21f5-4aca-9342-f7614041807c" />

---

##  Architecture de l'Infrastructure
Le projet repose sur trois machines virtualisées via **Vagrant**, connectées sur le réseau privé **`172.28.128.0/24`** :

*   **`server-hardening` (`172.28.128.221`) :** La cible contenant l'actif (Nginx, PHP 8.1) où les piliers de sécurité sont appliqués.
*   **`client-admin` (`172.28.128.222`) :** Le poste de l'utilisateur autorisé, utilisant des clés cryptographiques **Ed25519** pour l'administration distante sécurisée et accédant au site via des contrôles contextuels.
*   **`pentest` (`172.28.128.223`) :** La plateforme d'attaque équipée de Nmap et Metasploit pour générer des requêtes invalides et tester la résilience des défenses.

---

##  Les 5 Piliers de Sécurisation Mis en Place :
Conformément aux critères de l'UE 478, les contrôles suivants sont implémentés :

*   **Identité & Accès (SSH Hardening) :** Désactivation de l'authentification par mot de passe au profit de clés robustes **Ed25519**.
*   **Centralisation SSO :** Utilisation de **LemonLDAP:NG** comme plan de contrôle (*Policy Enforcement Point*) pour placer l'identité au centre de chaque flux d'accès.
*   **Sauvegardes Décentralisées :** Automatisation des tâches de sauvegarde via **BorgBackup** vers la machine `client-admin` avec rétention et chiffrement des données.
*   **Analyse des Logs :** Déploiement et configuration de **Logwatch** pour centraliser et auditer quotidiennement les comportements suspects sur le réseau.
*   **Durcissement Système & Web :** Configuration sécurisée du serveur web **Nginx** (suppression des en-têtes bavards, restriction des méthodes HTTP) et isolation des processus **PHP 8.1 FPM**.

---

##  Langages & Technologies
- **Orchestration :** Vagrant & VirtualBox
- **Services Web :** Nginx, PHP 8.1, LemonLDAP:NG
- **Sécurité et Scripting :** Bash, BorgBackup, Logwatch

---

##  Déploiement Rapide
Pour instancier l'infrastructure complète sur votre machine locale :

1. Assurez-vous d'avoir installé **Vagrant** et **VirtualBox**.
2. Clonez le dépôt et démarrez l'ensemble des environnements :
   ```sh
   vagrant up
   ```
