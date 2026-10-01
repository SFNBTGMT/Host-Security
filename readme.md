# Host Security - Virtualized Audit Infrastructure

##  Objectif et Contexte du Projet
Le but de ce projet est de sécuriser un actif critique (un site web statique/dashboard hébergé sur le serveur) en appliquant une stratégie de défense en profondeur et un modèle Zero Trust. L'objectif est de démontrer que l'hôte est "durci" (hardened) pour résister aux menaces modernes, comme le piratage de contenu ou l'indisponibilité, tout en permettant une administration distante sécurisée.

## L'enonce du projet

---

##  Architecture de l'Infrastructure
Le projet repose sur trois machines virtualisées via **Vagrant**, connectées sur le réseau privé **`172.28.128.0/24`** :

*   **`server-hardening` (`172.28.128.221`) :** La cible contenant l'actif (Nginx, PHP 8.1) où les piliers de sécurité sont appliqués.
*   **`client-admin` (`172.28.128.222`) :** Le poste de l'utilisateur autorisé, utilisant des clés cryptographiques **Ed25519** pour l'administration distante sécurisée et accédant au site via des contrôles contextuels.
*   **`pentest` (`172.28.128.223`) :** La plateforme d'attaque équipée de Nmap et Metasploit pour générer des requêtes invalides et tester la résilience des défenses.

---

##  Les 5 Piliers de Sécurisation Mis en Place
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
   git clone https://github.com
   cd Host-Security
   vagrant up
   ```
