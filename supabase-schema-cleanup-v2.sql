-- ═══════════════════════════════════════════════════════════════════════════════
-- NETTOYAGE COMPLET SUPABASE - VERSION 2 (RENFORCÉE)
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- Ce script nettoie AGRESSIVEMENT toutes les incohérences :
-- - Supprime TOUS les doublons (camelCase + snake_case + lowercase)
-- - Supprime les colonnes obsolètes (criticite, remarques, etc.)
-- - Crée uniquement les colonnes camelCase utilisées par le code
--
-- ⚠️ ATTENTION : Exécutez ce script dans l'éditeur SQL de Supabase
-- ⚠️ Sauvegardez vos données avant si nécessaire
--
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 1 : SUPPRESSION AGRESSIVE DE TOUTES LES COLONNES PROBLÉMATIQUES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Doublons heure (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS heure_debut;
ALTER TABLE equipements DROP COLUMN IF EXISTS heure_fin;

-- Doublons date (garder "date")
ALTER TABLE equipements DROP COLUMN IF EXISTS date_visite;

-- Colonnes obsolètes (remplacées)
ALTER TABLE equipements DROP COLUMN IF EXISTS criticite;  -- remplacée par "crit"
ALTER TABLE equipements DROP COLUMN IF EXISTS remarques;  -- remplacée par "observations"
ALTER TABLE equipements DROP COLUMN IF EXISTS recommandations;  -- remplacée par "actions"

-- Doublons watermeter (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS watermetertype;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermeterserial;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermeterfield;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermetergtb;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermeterdiff;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermeterlastread;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterMetercoherence;  -- casse mixte
ALTER TABLE equipements DROP COLUMN IF EXISTS watermeterobs;

-- Doublons airflow (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS airflowmeasured;
ALTER TABLE equipements DROP COLUMN IF EXISTS airflowregulation;
ALTER TABLE equipements DROP COLUMN IF EXISTS airflowcompliance;
ALTER TABLE equipements DROP COLUMN IF EXISTS airflowvents;
ALTER TABLE equipements DROP COLUMN IF EXISTS airflowventsstate;
ALTER TABLE equipements DROP COLUMN IF EXISTS airflowobs;

-- Doublons sanitary (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS sanitarytype;
ALTER TABLE equipements DROP COLUMN IF EXISTS sanitarylocation;

-- Doublons GTB (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS gtbsoftware;
ALTER TABLE equipements DROP COLUMN IF EXISTS gtbversion;
ALTER TABLE equipements DROP COLUMN IF EXISTS gtbpoints;
ALTER TABLE equipements DROP COLUMN IF EXISTS gtbpointsfault;
ALTER TABLE equipements DROP COLUMN IF EXISTS gtbavailability;
ALTER TABLE equipements DROP COLUMN IF EXISTS gtblastupdate;
ALTER TABLE equipements DROP COLUMN IF EXISTS gtbanomalies;

-- Doublons water quality (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualitycircuit;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualitypoint;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualityph;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualityconductivity;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualitytemp;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualityhardness;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualitytac;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualityturbidity;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualitychlorine;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualityiron;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualitytreatment;
ALTER TABLE equipements DROP COLUMN IF EXISTS waterqualityobs;

-- Doublons généraux (garder camelCase)
ALTER TABLE equipements DROP COLUMN IF EXISTS contactsite;
ALTER TABLE equipements DROP COLUMN IF EXISTS telreferent;
ALTER TABLE equipements DROP COLUMN IF EXISTS typevisite;
ALTER TABLE equipements DROP COLUMN IF EXISTS refdoe;
ALTER TABLE equipements DROP COLUMN IF EXISTS refplan;
ALTER TABLE equipements DROP COLUMN IF EXISTS qrcode;

-- Colonne data (JSONB) - probablement obsolète avec nouvelle architecture
ALTER TABLE equipements DROP COLUMN IF EXISTS data;

-- Colonne supabase_id (doublon avec id)
ALTER TABLE equipements DROP COLUMN IF EXISTS supabase_id;

-- ═══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 2 : CRÉATION DES COLONNES CAMELCASE (AVEC QUOTES)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Colonnes de base (déjà présentes normalement, mais on s'assure)
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS id UUID PRIMARY KEY DEFAULT gen_random_uuid();
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- Informations générales
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS lot TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS date TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "heureDebut" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "heureFin" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS technicien TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS entreprise TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "contactSite" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "telReferent" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS meteo TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "typeVisite" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS niveau TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS local TEXT;

-- Géolocalisation
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS latitude TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS longitude TEXT;

-- Identification équipement
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS type TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS code TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "qrCode" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "refDOE" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "refPlan" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS marque TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS modele TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS serie TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS puissance TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS unite TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS annee TEXT;

-- Compteur d'eau (8 champs)
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterType" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterSerial" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterField" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterGTB" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterDiff" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterLastRead" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterCoherence" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterMeterObs" TEXT;

-- Débits air sanitaires (8 champs)
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "sanitaryType" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "sanitaryLocation" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "airFlowMeasured" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "airFlowRegulation" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "airFlowCompliance" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "airFlowVents" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "airFlowVentsState" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "airFlowObs" TEXT;

-- GTB (7 champs)
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbSoftware" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbVersion" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbPoints" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbPointsFault" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbAvailability" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbLastUpdate" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "gtbAnomalies" TEXT;

-- Qualité eau (12 champs)
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityCircuit" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityPoint" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityPH" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityConductivity" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityTemp" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityHardness" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityTAC" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityTurbidity" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityChlorine" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityIron" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityTreatment" TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS "waterQualityObs" TEXT;

-- Évaluation et anomalies
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS ev INTEGER;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS crit TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS type_anomalie TEXT;  -- ⚠️ snake_case (comme dans le code)
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS budget TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS priorite TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS constat TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS observations TEXT;
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS actions TEXT;

-- Métadonnées
ALTER TABLE equipements ADD COLUMN IF NOT EXISTS timestamp TIMESTAMPTZ;

-- ═══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 3 : RECRÉATION DES INDEX
-- ═══════════════════════════════════════════════════════════════════════════════

DROP INDEX IF EXISTS idx_equipements_lot;
DROP INDEX IF EXISTS idx_equipements_code;
DROP INDEX IF EXISTS idx_equipements_timestamp;
DROP INDEX IF EXISTS idx_equipements_lot_code_timestamp;

CREATE INDEX idx_equipements_lot ON equipements(lot);
CREATE INDEX idx_equipements_code ON equipements(code);
CREATE INDEX idx_equipements_timestamp ON equipements(timestamp);
CREATE INDEX idx_equipements_lot_code_timestamp ON equipements(lot, code, timestamp);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ÉTAPE 4 : COMMENTAIRES
-- ═══════════════════════════════════════════════════════════════════════════════

COMMENT ON COLUMN equipements.id IS 'UUID Supabase (primary key)';
COMMENT ON COLUMN equipements.lot IS 'Lot technique (Structure, CVC, etc.)';
COMMENT ON COLUMN equipements.code IS 'Code unique de l''équipement';
COMMENT ON COLUMN equipements.ev IS 'État visuel (0-4)';
COMMENT ON COLUMN equipements.crit IS 'Criticité (U/I/A/S)';
COMMENT ON COLUMN equipements.type_anomalie IS 'Type d''anomalie';
COMMENT ON COLUMN equipements.timestamp IS 'Date et heure de création';
COMMENT ON COLUMN equipements.latitude IS 'Latitude GPS';
COMMENT ON COLUMN equipements.longitude IS 'Longitude GPS';

-- ═══════════════════════════════════════════════════════════════════════════════
-- ✅ SCRIPT TERMINÉ
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- Colonnes supprimées :
-- - Tous les doublons (lowercase, snake_case)
-- - Colonnes obsolètes (criticite, remarques, recommandations)
-- - Colonnes inutilisées (data JSONB, supabase_id UUID)
--
-- Colonnes conservées :
-- - Toutes les colonnes en camelCase (avec quotes)
-- - Sauf type_anomalie (snake_case comme dans le code)
-- - + latitude, longitude pour géolocalisation
--
-- ═══════════════════════════════════════════════════════════════════════════════
