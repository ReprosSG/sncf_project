# Pipeline Data SNCF : Architecture Medallion sur Azure

## Objectif du Projet
Ce projet personnel a pour but de concevoir et d'orchestrer un pipeline de données complet pour traiter et analyser les données de la SNCF. Le flux de données repose sur les meilleures pratiques de l'**Architecture Medallion** (Bronze, Silver, Gold) et est entièrement structuré sur le cloud Microsoft Azure.

## Stack Technique
* **Orchestration :** Azure Data Factory (ADF)
* **Stockage :** Azure Data Lake Storage Gen2 (ADLS)
* **Calcul & Transformation :** Azure Databricks
* **Langage :** Python / PySpark
* **Infrastructure as Code (IaC) :** Terraform
* **CI/CD & Qualité :** GitHub Actions, Flake8, nbqa

---

## Architecture et Pipeline

Le flux de données est automatisé via Azure Data Factory et structuré en trois couches :
1. **Bronze (Raw) :** Réception des données brutes (fichiers CSV SNCF).
2. **Silver (Cleansed) :** Nettoyage, typage et standardisation des données avec PySpark.
3. **Gold (Curated) :** Agrégation et préparation des données pour l'analyse.

### 1. L'Orchestration Globale (ADF)
Le pipeline est conçu pour être robuste. Il intègre une logique de contrôle en amont pour éviter de démarrer des ressources de calcul inutilement.
![Architecture du Pipeline](images/01-adf-pipeline-orchestration.png)

### 2. Sécurité & Contrôle Qualité (Le Garde-fou)
L'activité de validation s'assure que le dossier source contient bien les données attendues avant de déclencher l'orchestration des Notebooks.
![Garde-fou Validation](images/02-adf-validation-activity.png)

### 3. Stockage Data Lake (Couche Bronze)
Les données brutes atterrissent de manière sécurisée dans le premier conteneur du Data Lake.
![Data Lake Bronze](images/03-datalake-bronze-raw.png)

### 4. Transformation des Données (PySpark)
Le cœur du traitement de la donnée : nettoyage et structuration via Databricks.
![Code PySpark Databricks](images/04-databricks-pyspark-transform.png)

---

## DevOps & Déploiement

Pour garantir les standards de production, ce projet intègre une approche DevOps complète afin d'automatiser les tests et la gestion de l'infrastructure :

### Infrastructure as Code (Terraform)
L'ensemble des ressources Azure (Data Lake, dossiers Medallion, Data Factory, Databricks, Key Vault) est codifié via **Terraform**. 
Le dossier `/infrastructure` contient le "Blueprint" du projet. Cette approche garantit de pouvoir déployer et détruire l'environnement à la demande, assurant une reproductibilité parfaite tout en maîtrisant les coûts cloud.

### Intégration Continue (GitHub Actions)
Un pipeline CI est configuré (`.github/workflows/ci.yml`) pour agir comme une "Quality Gate" à chaque push sur le dépôt GitHub :
* **Validation Terraform :** Vérification automatique de la syntaxe et de la logique de l'infrastructure (`terraform validate`).
* **Linting PySpark :** Analyse statique du code des Notebooks (`.ipynb`) via **nbqa** et **flake8** pour garantir un code propre, standardisé et sans variables non définies avant toute mise en production.

---

## Note sur l'état du déploiement (Limites d'infrastructure)

> L'architecture globale, la logique d'orchestration (ADF) et les scripts de transformation PySpark sont **100 % finalisés et validés**. 
> 
> Cependant, en raison des restrictions strictes de quotas de calcul imposées par l'abonnement *Azure for Students* (limite globale fixée à 6 vCPUs ou littéralement 0 vCPU selon les régions), l'exécution complète du pipeline est impossible. 
>
> C'est pourquoi le pipeline est présenté ici dans une configuration de **"Dry Run"**.
> 
> *Cette contrainte technique m'a permis de gérer les quotas Cloud, l'optimisation des coûts de calcul et le troubleshooting d'infrastructure. C'est donc cette contrainte budgétaire qui a motivé le passage d'une configuration manuelle (ClickOps) à une architecture "Blueprint" entièrement scriptée (Terraform) et sécurisée (CI).*