# Configuration Supabase - PEC Tech App

## 🎯 Objectif

Ce document explique comment configurer correctement la base de données Supabase pour l'application PEC Tech.

---

## ⚠️ Problème résolu

La table `equipements` contenait des **incohérences de noms de colonnes** :
- Doublons : `watermetertype` (lowercase) ET `waterMeterType` (camelCase)
- Noms incorrects : colonnes converties en lowercase par PostgreSQL
- Anciennes colonnes : snake_case (`heure_debut`) au lieu de camelCase (`heureDebut`)

**Conséquence** : Erreurs lors de la synchronisation (`column not found`)

---

## ✅ Solution : Script de nettoyage (VERSION 2 - RENFORCÉE)

### Fichier : `supabase-schema-cleanup-v2.sql` ⭐ **UTILISER CELUI-CI**

Ce script effectue un **nettoyage AGRESSIF** du schéma :

1. **Supprime** TOUS les doublons (lowercase + snake_case + casse mixte)
   - `heure_debut` + `heureDebut` → garde uniquement `"heureDebut"`
   - `watermetertype` + `waterMeterType` → garde uniquement `"waterMeterType"`

2. **Supprime** les colonnes obsolètes
   - `criticite` → remplacée par `crit`
   - `remarques` → remplacée par `observations`
   - `recommandations` → remplacée par `actions`
   - `date_visite` → remplacée par `date`

3. **Supprime** les colonnes inutilisées
   - `data` (JSONB) → architecture refondée
   - `supabase_id` (UUID) → doublon avec `id`

4. **Crée** uniquement les colonnes camelCase (avec quotes)
5. **Inclut** latitude/longitude pour géolocalisation
6. **Crée** les index pour optimiser les performances
7. **Documente** les colonnes avec des commentaires

---

### ⚠️ Pourquoi VERSION 2 ?

La v1 (`supabase-schema-cleanup.sql`) n'était pas assez agressive et laissait des doublons si les colonnes existaient déjà. La **v2 DROP d'abord**, puis crée proprement.

---

## 🚀 Instructions d'exécution

### Étape 1 : Sauvegarder les données (optionnel)

Si vous avez des données importantes dans la table `equipements`, exportez-les d'abord :

```sql
-- Dans l'éditeur SQL Supabase
SELECT * FROM equipements;
```

Puis **Export to CSV** dans l'interface Supabase.

---

### Étape 2 : Exécuter le script de nettoyage V2

1. Ouvrez **Supabase Dashboard** → **SQL Editor**
2. Créez une **nouvelle requête**
3. Copiez-collez le contenu complet de `supabase-schema-cleanup-v2.sql` ⭐
4. Cliquez sur **Run** (Exécuter)

Le script s'exécute en 4 étapes :
- ✅ **DROP agressif** : Suppression de TOUS les doublons et colonnes obsolètes
- ✅ **Création propre** : Colonnes camelCase uniquement (avec quotes)
- ✅ **Index** : Création des index pour performances
- ✅ **Documentation** : Ajout des commentaires explicatifs

---

### Étape 3 : Vérifier le résultat

```sql
-- Vérifier les colonnes créées
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'equipements'
ORDER BY column_name;
```

Vous devriez voir **UNIQUEMENT** les colonnes en camelCase (avec quotes) :
- `airFlowCompliance`, `contactSite`, `heureDebut`, `waterMeterType`, etc.
- **Exception** : `type_anomalie` en snake_case (comme dans le code)

**Colonnes qui doivent avoir DISPARU** :
- ❌ `heure_debut`, `heure_fin` (doublons snake_case)
- ❌ `watermetertype` (doublon lowercase)
- ❌ `date_visite` (obsolète, remplacée par `date`)
- ❌ `criticite` (obsolète, remplacée par `crit`)
- ❌ `remarques` (obsolète, remplacée par `observations`)
- ❌ `recommandations` (obsolète, remplacée par `actions`)
- ❌ `data` (JSONB, inutilisée)
- ❌ `supabase_id` (UUID, doublon avec `id`)

Si ces colonnes apparaissent encore, le script v2 n'a pas été exécuté.

---

## 🔍 Doublons détectés dans votre schéma

Voici les **doublons trouvés** dans votre table `equipements` actuelle :

| Colonne camelCase (✅ garder) | Doublons à supprimer (❌) |
|------------------------------|--------------------------|
| `heureDebut` | `heure_debut` |
| `heureFin` | `heure_fin` |
| `waterMeterType` | `watermetertype` |
| `date` | `date_visite` |
| `crit` | `criticite` |
| `observations` | `remarques` |
| `actions` | `recommandations` |

**Total : 83 colonnes dans votre schéma** → **devrait être ~70 colonnes** après nettoyage

---

## 📋 Liste des colonnes créées

### Informations générales
- `lot`, `date`, `heureDebut`, `heureFin`
- `technicien`, `entreprise`, `contactSite`, `telReferent`
- `meteo`, `typeVisite`, `niveau`, `local`
- `latitude`, `longitude` (géolocalisation GPS)

### Identification équipement
- `type`, `code`, `qrCode`, `refDOE`, `refPlan`
- `marque`, `modele`, `serie`, `puissance`, `unite`, `annee`

### Compteur d'eau (8 champs)
- `waterMeterType`, `waterMeterSerial`, `waterMeterField`, `waterMeterGTB`
- `waterMeterDiff`, `waterMeterLastRead`, `waterMeterCoherence`, `waterMeterObs`

### Débits air sanitaires (8 champs)
- `sanitaryType`, `sanitaryLocation`
- `airFlowMeasured`, `airFlowRegulation`, `airFlowCompliance`
- `airFlowVents`, `airFlowVentsState`, `airFlowObs`

### GTB (7 champs)
- `gtbSoftware`, `gtbVersion`, `gtbPoints`, `gtbPointsFault`
- `gtbAvailability`, `gtbLastUpdate`, `gtbAnomalies`

### Qualité eau (12 champs)
- `waterQualityCircuit`, `waterQualityPoint`, `waterQualityPH`
- `waterQualityConductivity`, `waterQualityTemp`, `waterQualityHardness`
- `waterQualityTAC`, `waterQualityTurbidity`, `waterQualityChlorine`
- `waterQualityIron`, `waterQualityTreatment`, `waterQualityObs`

### Évaluation et anomalies
- `ev` (INTEGER), `crit`, `type_anomalie` ⚠️ (snake_case)
- `budget`, `priorite`, `constat`, `observations`, `actions`

### Métadonnées
- `timestamp` (TIMESTAMPTZ)

---

## 🔍 Vérification de la synchronisation

Après exécution du script, testez la synchronisation :

### Test 1 : Création + Sync (INSERT)
1. Créez un nouvel équipement dans l'app
2. Vérifiez dans la console : `➕ INSERT d'un nouvel équipement`
3. Vérifiez dans Supabase : l'équipement doit apparaître

### Test 2 : Édition + Sync (UPDATE)
1. Modifiez l'équipement créé
2. Vérifiez dans la console : `🔄 UPDATE de l'équipement`
3. Vérifiez dans Supabase : **1 seul équipement** (pas de doublon)

### Test 3 : Suppression
1. Supprimez l'équipement
2. Vérifiez dans Supabase : l'équipement doit disparaître

---

## ❓ Dépannage

### Erreur : "column not found"
→ Le script n'a pas été exécuté ou une colonne est manquante
→ Réexécutez `supabase-schema-cleanup.sql`

### Erreur : "permission denied"
→ Vérifiez que vous avez les droits admin sur Supabase
→ Vérifiez les RLS (Row Level Security) policies

### Doublons après UPDATE
→ Vérifiez que `supabase_id` est bien préservé lors de l'édition
→ Vérifiez les logs : doit afficher `UPDATE` et non `INSERT`

---

## 📚 Fichiers de référence

- `supabase-schema-cleanup.sql` : Script de nettoyage complet (à exécuter)
- `supabase-migration.sql` : Ancien script (remplacé par cleanup)
- `CHANGELOG.md` : Documentation des versions et changements

---

## ✨ Résultat attendu

Après exécution du script :
- ✅ **0 erreur** de synchronisation
- ✅ **0 doublon** après édition
- ✅ Synchronisation INSERT/UPDATE intelligente
- ✅ Suppression complète (local + Supabase)
- ✅ Workflow terrain robuste (offline-first)

---

**Version** : 1.1.0
**Date** : 2025-11-28
**Auteur** : Claude (Architecture sync refactor)
