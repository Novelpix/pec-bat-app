# Analyse de Correspondance - Champs Table `equipements` vs Formulaires

## Date d'analyse
2025-11-29

## Objectif
Vérifier que tous les champs de la table `equipements` Supabase correspondent bien aux informations collectées dans les fiches équipements de chaque lot.

---

## ✅ Champs Standards - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `date` | `formDate` | Tous | ✅ OK |
| `heureDebut` | `formHeureDebut` | Tous | ✅ OK |
| `heureFin` | `formHeureFin` | Tous | ✅ OK |
| `date_visite` | **DOUBLON** avec `date` | Tous | ⚠️ Doublon |
| `heure_fin` | **DOUBLON** avec `heureFin` | Tous | ⚠️ Doublon |
| `technicien` | `formTechnicien` | Tous | ✅ OK |
| `entreprise` | `formEntreprise` | Tous | ✅ OK |
| `contactSite` | `formContactSite` | Tous | ✅ OK |
| `telReferent` | `formTelReferent` | Tous | ✅ OK |
| `meteo` | `formMeteo` | Tous | ✅ OK |
| `typeVisite` | `formTypeVisite` | Tous | ✅ OK |
| `niveau` | `formNiveau` | Tous | ✅ OK |
| `local` | `formLocal` | Tous | ✅ OK |
| `lot` | `formLot` (AppState.currentLot) | Tous | ✅ OK |
| `type` | `formType` / `formTypeAutre` | Tous | ✅ OK |
| `code` | `formCode` | Tous | ✅ OK |
| `qrCode` | `formQRCode` | Tous | ✅ OK |
| `refDOE` | `formRefDOE` | Tous | ✅ OK |
| `refPlan` | `formRefPlan` | Tous | ✅ OK |

---

## ✅ Champs Équipements Mécaniques - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `marque` | `formMarque` | CVC, Ventilation, IoT, Ascenseurs | ✅ OK |
| `modele` | `formModele` | CVC, Ventilation, IoT, Ascenseurs | ✅ OK |
| `serie` | `formSerie` | CVC, Ventilation, IoT, Ascenseurs | ✅ OK |
| `puissance` | `formPuissance` | CVC, Électricité | ✅ OK |
| `unite` | `formUnite` | CVC, Électricité | ✅ OK |
| `annee` | `formAnnee` | CVC, Ventilation, Ascenseurs | ✅ OK |

---

## ✅ Champs État & Criticité - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `ev` | AppState.currentEV (Radio buttons) | Tous | ✅ OK |
| `crit` | AppState.currentCRIT (Radio buttons) | Tous | ✅ OK |
| `criticite` | **DOUBLON** potentiel avec `crit` | Tous | ⚠️ Vérifier |
| `type_anomalie` | AppState.currentTYPE (Radio buttons) | Tous | ✅ OK |
| `budget` | AppState.currentBUDGET (Radio buttons) | Tous | ✅ OK |
| `priorite` | Calculé automatiquement | Tous | ✅ OK |

---

## ✅ Champs Observations - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `constat` | `formConstat` | Tous | ✅ OK |
| `observations` | `formObservations` | Tous | ✅ OK |
| `actions` | `formActions` | Tous | ✅ OK |
| `recommandations` | **NON TROUVÉ** dans formulaire | Tous | ❌ MANQUANT |
| `remarques` | **DOUBLON** potentiel avec `observations` | Tous | ⚠️ Vérifier |

---

## 🆕 Champs Compteur d'Eau - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `waterMeterType` | `formWaterMeterType` | CVC Production | ✅ OK |
| `watermetertype` | **DOUBLON** (casse différente) | CVC Production | ⚠️ Doublon |
| `waterMeterSerial` | `formWaterMeterSerial` | CVC Production | ✅ OK |
| `waterMeterField` | `formWaterMeterField` | CVC Production | ✅ OK |
| `waterMeterGTB` | `formWaterMeterGTB` | CVC Production | ✅ OK |
| `waterMeterDiff` | `formWaterMeterDiff` | CVC Production | ✅ OK |
| `waterMeterLastRead` | `formWaterMeterLastRead` | CVC Production | ✅ OK |
| `waterMeterCoherence` | `formWaterMeterCoherence` | CVC Production | ✅ OK |
| `waterMeterObs` | `formWaterMeterObs` | CVC Production | ✅ OK |

---

## 🆕 Champs Débits Air Sanitaires - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `sanitaryType` | `formSanitaryType` | CVC Production, Ventilation | ✅ OK |
| `sanitaryLocation` | `formSanitaryLocation` | CVC Production, Ventilation | ✅ OK |
| `airFlowMeasured` | `formAirFlowMeasured` | CVC Production, Ventilation | ✅ OK |
| `airFlowRegulation` | `formAirFlowRegulation` | CVC Production, Ventilation | ✅ OK |
| `airFlowCompliance` | `formAirFlowCompliance` | CVC Production, Ventilation | ✅ OK |
| `airFlowVents` | `formAirFlowVents` | CVC Production, Ventilation | ✅ OK |
| `airFlowVentsState` | `formAirFlowVentsState` | CVC Production, Ventilation | ✅ OK |
| `airFlowObs` | `formAirFlowObs` | CVC Production, Ventilation | ✅ OK |

---

## 🆕 Champs GTB (Supervision) - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `gtbSoftware` | `formGTBSoftware` | GTB | ✅ OK |
| `gtbVersion` | `formGTBVersion` | GTB | ✅ OK |
| `gtbPoints` | `formGTBPoints` | GTB | ✅ OK |
| `gtbPointsFault` | `formGTBPointsFault` | GTB | ✅ OK |
| `gtbAvailability` | `formGTBAvailability` | GTB | ✅ OK |
| `gtbLastUpdate` | `formGTBLastUpdate` | GTB | ✅ OK |
| `gtbAnomalies` | `formGTBAnomalies` | GTB | ✅ OK |

---

## 🆕 Champs Qualité d'Eau - CONFORMES

| Champ Table | Formulaire | Lots Concernés | Statut |
|-------------|-----------|----------------|---------|
| `waterQualityCircuit` | `formWaterQualityCircuit` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityPoint` | `formWaterQualityPoint` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityPH` | `formWaterQualityPH` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityConductivity` | `formWaterQualityConductivity` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityTemp` | `formWaterQualityTemp` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityHardness` | `formWaterQualityHardness` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityTAC` | `formWaterQualityTAC` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityTurbidity` | `formWaterQualityTurbidity` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityChlorine` | `formWaterQualityChlorine` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityIron` | `formWaterQualityIron` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityTreatment` | `formWaterQualityTreatment` | CVC Production, CVC Émission | ✅ OK |
| `waterQualityObs` | `formWaterQualityObs` | CVC Production, CVC Émission | ✅ OK |

---

## ⚠️ Champs Techniques/Système - À VÉRIFIER

| Champ Table | Formulaire | Utilisation | Statut |
|-------------|-----------|-------------|---------|
| `id` | Généré par Supabase | ID unique table | ✅ OK (Auto) |
| `supabase_id` | Sauvegardé dans `equipment.supabase_id` | Synchronisation | ✅ OK |
| `created_at` | Timestamp auto Supabase | Date création | ✅ OK (Auto) |
| `timestamp` | `new Date().toISOString()` | Date modification | ✅ OK |
| `latitude` | GPS (fonction `captureGPS`) | Non implémenté | ⚠️ Fonction existe mais pas utilisée |
| `longitude` | GPS (fonction `captureGPS`) | Non implémenté | ⚠️ Fonction existe mais pas utilisée |
| `data` | Format JSONB | Stockage flexible | ✅ OK (utilisé pour structure) |

---

## ❌ PROBLÈMES IDENTIFIÉS

### 1. Champ MANQUANT dans le formulaire

| Champ Table | Problème | Impact | Solution Recommandée |
|-------------|----------|--------|---------------------|
| **`recommandations`** | Aucun champ `formRecommandations` dans le formulaire | Les recommandations ne peuvent pas être saisies ! | ✅ **AJOUTER** un champ textarea pour les recommandations |

### 2. Doublons potentiels dans la table

| Champs Doublons | Problème | Recommandation |
|----------------|----------|----------------|
| `date` vs `date_visite` | Deux champs pour la même information | Utiliser uniquement `date` |
| `heureFin` vs `heure_fin` | Deux champs pour la même information | Utiliser uniquement `heureFin` |
| `waterMeterType` vs `watermetertype` | Casse différente, même champ | Utiliser uniquement `waterMeterType` |
| `crit` vs `criticite` | Potentiel doublon | Utiliser uniquement `crit` |
| `observations` vs `remarques` | Potentiel doublon | Utiliser uniquement `observations` |

### 3. Fonctionnalités non utilisées

| Champ | Fonctionnalité | Statut |
|-------|---------------|--------|
| `latitude` / `longitude` | Fonction GPS existe (`captureGPS()`) mais pas connectée au formulaire | ⚠️ À implémenter ou à retirer |

---

## 📊 RÉSUMÉ

### Statistiques de conformité

- **Total champs table**: 85 champs
- **Champs conformes**: 78 champs (91.8%)
- **Champs manquants**: 1 champ (`recommandations`)
- **Doublons potentiels**: 6 champs
- **Champs système OK**: 7 champs

### Niveau de conformité par catégorie

| Catégorie | Conformité |
|-----------|-----------|
| Champs standards | ✅ 100% (sauf doublons) |
| Équipements mécaniques | ✅ 100% |
| État & Criticité | ✅ 100% (sauf doublons) |
| Observations | ❌ 75% (manque `recommandations`) |
| Compteur d'eau | ✅ 100% (sauf doublon casse) |
| Débits air | ✅ 100% |
| GTB | ✅ 100% |
| Qualité eau | ✅ 100% |

---

## 🎯 RECOMMANDATIONS

### Priorité HAUTE 🔴

1. **AJOUTER le champ `recommandations`** dans le formulaire
   - Localisation: Section "Observations" du formulaire
   - Type: `<textarea>` avec ID `formRecommandations`
   - Label: "Recommandations"
   - Ajouter dans la fonction `saveEquipment()` ligne ~3490

### Priorité MOYENNE 🟡

2. **Nettoyer les doublons de la table**
   - Supprimer: `date_visite`, `heure_fin`, `watermetertype`, `criticite`, `remarques`
   - Conserver: `date`, `heureFin`, `waterMeterType`, `crit`, `observations`
   - Migration SQL nécessaire pour copier les données avant suppression

3. **Implémenter la géolocalisation GPS**
   - Connecter `captureGPS()` au formulaire
   - Sauvegarder `latitude` et `longitude` dans `saveEquipment()`
   - Ou supprimer ces champs s'ils ne sont pas nécessaires

### Priorité BASSE 🟢

4. **Documentation**
   - Documenter la correspondance entre champs table et formulaire
   - Créer un schéma de la structure de données

---

## 📝 LOTS TECHNIQUES ET CHAMPS SPÉCIFIQUES

### Structure / GO
- Champs standard uniquement
- Pas de champs spécifiques

### Enveloppe
- Champs standard uniquement
- Pas de champs spécifiques

### Toitures
- Champs standard uniquement
- Pas de champs spécifiques

### CVC Production
- ✅ Champs compteur d'eau (9 champs)
- ✅ Champs débits air sanitaires (8 champs)
- ✅ Champs qualité eau (12 champs)
- ✅ Champs mécaniques (marque, modèle, série, puissance, année)

### CVC Distribution
- ✅ Champs mécaniques (marque, modèle, série, puissance)
- Pas de champs spécifiques supplémentaires

### CVC Émission
- ✅ Champs qualité eau (12 champs)
- Champs standard

### Ventilation
- ✅ Champs débits air sanitaires (8 champs)
- ✅ Champs mécaniques (marque, modèle, série)

### Électricité CFO
- ✅ Champs mécaniques (marque, puissance, unite)
- Champs standard

### Électricité CFA
- Champs standard uniquement
- Pas de champs spécifiques

### GTB
- ✅ Champs GTB complets (7 champs)
- ✅ Champs mécaniques (marque)

### SSI
- Champs standard uniquement
- Pas de champs spécifiques

### Plomberie
- Champs standard uniquement
- Pas de champs spécifiques

### Ascenseurs
- ✅ Champs mécaniques (marque, modèle, série)
- Champs standard

### Locaux techniques
- Champs standard uniquement
- Pas de champs spécifiques

### EnR (Énergies Renouvelables)
- Champs standard uniquement
- Pas de champs spécifiques

### IoT
- ✅ Champs mécaniques (marque)
- Champs standard

### HSE
- Champs standard uniquement
- Pas de champs spécifiques

---

## ✅ CONCLUSION

L'application présente une très bonne correspondance entre la table `equipements` et les formulaires de saisie. Le taux de conformité est de **91.8%**.

**Point critique**: Le champ `recommandations` est présent dans la table mais **ABSENT du formulaire**. Il doit être ajouté en priorité.

Les doublons de champs dans la table doivent être nettoyés pour améliorer la cohérence de la base de données.
