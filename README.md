# GEI1084_Projet_ARM

Processeur ARM Monocycle VHDL & Extensions

**Auteur :** Sébastien Cabana (CABS72030202), Yohan Lefebvre(), Ralph Futa(FUTR5080200), Robin Marques (MARR80110000) 
**Cours :** GEI1084 - Architecture des ordinateurs et calcul accéléré
**Établissement :** Université du Québec à Trois-Rivières (UQTR)
**Semestre :** Automne 2025

---
## 1. Description du Projet

Ce dépôt contient l'implémentation VHDL d'un processeur ARM monocycle 32 bits. Ce projet constitue l'aboutissement de nos travaux pratiques de laboratoires et intègre les extensions fonctionnelles définies dans le cadre du Mini-Projet 1. L'objectif est de concevoir, simuler et valider une microarchitecture capable d'exécuter un sous-ensemble du jeu d'instructions ARM, incluant la gestion complète du chemin de contrôle et des données.

## 2. Architecture du Système

L'architecture est divisée en deux entités principales interagissant de manière synchrone : le chemin de données (Datapath) et l'unité de contrôle (Control Unit).

### 2.1 Unité de Contrôle (Control Unit)
L'unité de contrôle gère le séquencement des instructions via trois sous-modules :
* **Main Decoder :** Décode les bits d'instruction (`Op`, `Funct`) pour piloter les signaux `MemtoReg`, `MemW`, `RegW`.
* **ALU Decoder :** Génère les signaux `ALUControl` (ADD, SUB, AND, ORR) en fonction du `ALUOp` et du champ `Funct`.
* **Logique Conditionnelle (Conditional Logic) :** Implémente la vérification des conditions d'exécution par rapport aux drapeaux (Flags N, Z, C, V) pour valider l'écriture (`CondEx`).

### 2.2 Chemin de Données (Datapath)
Le Datapath intègre les éléments suivants, connectés selon la logique :
* **ALU :** Unité arithmétique et logique supportant les opérations étendues.
* **Register File :** Banc de registres à double port de lecture et simple port d'écriture.
* **Gestion du PC :** Compteur de programme avec logique de calcul d'adresse (PC+4, PC+8).
* **Mémoire d'Instruction :** ROM synchrone contenant le programme binaire.

### 2.3 Extensions (Mini-Projet 1)
Conformément au cahier des charges, l'architecture de base a été étendue pour supporter :

1.  **Instruction CMP :**
    * Comparaison de registres mettant à jour les flags (N, Z, C, V) sans modifier les registres de destination.

2.  **Registre à Décalage (Barrel Shifter) :**
    * Intégration du module `shifter.vhd` en amont de l'entrée B de l'ALU.
    * **Entrées :** Utilise le champ `shamt5` (bits 11:7) pour le montant du décalage et `sh` (bits 6:5) pour le type.
    * **Opérations supportées :**
        * `00` : LSL (Logical Shift Left)
        * `01` : LSR (Logical Shift Right)
        * `10` : ASR (Arithmetic Shift Right)
        * `11` : ROR (Rotate Right)

## 3. Simulation et Validation

La validation s'appuie sur un banc de test (`testbench`) simulant l'exécution séquentielle d'instructions.

* **Méthodologie :** Le testbench génère une horloge de 10 ns et une séquence de réinitialisation.

## 4. Licence et Droits d'Utilisation

**Licence :** MIT License

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files...

Source complète en fin de document.

**Justification :**
Le choix de la licence MIT est motivé par sa permissivité qui favorise l'adoption et la réutilisation du code dans des contextes académiques et industriels ouverts. Contrairement à la GPL, elle n'impose pas que les travaux dérivés soient open source, ce qui offre une flexibilité maximale pour l'intégration de ces modules VHDL dans des projets plus vastes.

## 5. Responsabilité de Version (Release Policy)

Ce code est fourni dans un but éducatif et expérimental.
* **Responsabilité :** Les auteurs déclinent toutes responsabilités quant aux dysfonctionnements potentiels dans un environnement de production critique. L'utilisateur assume l'entière responsabilité de la synthèse et de l'implémentation matérielle.
* **Maintenance et Bug Fixes :** Ce projet étant réalisé dans un cadre strictement pédagogique, il est fourni à titre d'archive finale. Par conséquent, aucun suivi, aucune maintenance active ni aucune mise à jour de la documentation ne seront effectués après la fin du cours.

## 6. Sécurité et Analyse de Coûts

### 6.1 Sécurité Matérielle sur FPGA
Pour une implémentation commerciale sécurisée :
* **Chiffrement du Bitstream :** Utilisation de l'algorithme AES-256 (supporté par les FPGA Artix-7) pour chiffrer le fichier de configuration stocké dans la mémoire Flash externe.
* **Secure Boot (Démarrage Sécurisé) :** Implémentation d'une chaîne de confiance (Root of Trust) matérielle pour authentifier le bitstream et le logiciel embarqué avant l'exécution.

### 6.2 Analyse Économique (Artix-7 pour IoT)
**Contexte :** Production de 1000 unités/an avec un coût cible < 30 $USD.
**Analyse :**
* **Coût du FPGA :** Un FPGA Artix-7 représente à lui seul un coût unitaire souvent supérieur à 15-20 $USD en faible volume.
* **Faisabilité :** L'utilisation d'un Artix-7 rend l'objectif de 30 $USD (incluant PCB, mémoire et assemblage) difficilement atteignable.
* **Recommandation :** Migration vers des familles FPGA optimisées pour le coût (ex: Xilinx Spartan-7 ou Lattice iCE40) pour respecter les contraintes budgétaires IoT.

---
**Références :**
[1] D. M. Harris and S.L. Harris, *Digital Design and Computer Architecture: ARM Edition*, Morgan Kaufmann, 2015.
[2] J. Poupart et M. Ahmed Ouameur, *Mini-project No. 1*, GEI1084, UQTR, Automne 2025.
[3] Open Source Initiative, "The MIT License", [En ligne]. Disponible : [https://opensource.org/license/mit](https://opensource.org/license/mit)
[4] DigiKey Electronics, "AMD Artix-7 FPGA Product Highlight", [En ligne]. Disponible : [https://www.digikey.ca/en/product-highlight/x/xilinx/artix-7-fpga](https://www.digikey.ca/en/product-highlight/x/xilinx/artix-7-fpga)
