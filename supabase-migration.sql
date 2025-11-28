-- Migration pour ajouter toutes les colonnes manquantes à la table equipements
-- Exécutez ce script dans l'éditeur SQL de Supabase

-- Table principale des équipements
ALTER TABLE equipements

-- Informations générales
ADD COLUMN IF NOT EXISTS lot TEXT,
ADD COLUMN IF NOT EXISTS date TEXT,
ADD COLUMN IF NOT EXISTS heureDebut TEXT,
ADD COLUMN IF NOT EXISTS heureFin TEXT,
ADD COLUMN IF NOT EXISTS technicien TEXT,
ADD COLUMN IF NOT EXISTS entreprise TEXT,
ADD COLUMN IF NOT EXISTS contactSite TEXT,
ADD COLUMN IF NOT EXISTS telReferent TEXT,
ADD COLUMN IF NOT EXISTS meteo TEXT,
ADD COLUMN IF NOT EXISTS typeVisite TEXT,
ADD COLUMN IF NOT EXISTS niveau TEXT,
ADD COLUMN IF NOT EXISTS local TEXT,

-- Identification équipement
ADD COLUMN IF NOT EXISTS type TEXT,
ADD COLUMN IF NOT EXISTS code TEXT,
ADD COLUMN IF NOT EXISTS qrCode TEXT,
ADD COLUMN IF NOT EXISTS refDOE TEXT,
ADD COLUMN IF NOT EXISTS refPlan TEXT,
ADD COLUMN IF NOT EXISTS marque TEXT,
ADD COLUMN IF NOT EXISTS modele TEXT,
ADD COLUMN IF NOT EXISTS serie TEXT,
ADD COLUMN IF NOT EXISTS puissance TEXT,
ADD COLUMN IF NOT EXISTS unite TEXT,
ADD COLUMN IF NOT EXISTS annee TEXT,

-- Compteur d'eau
ADD COLUMN IF NOT EXISTS waterMeterType TEXT,
ADD COLUMN IF NOT EXISTS waterMeterSerial TEXT,
ADD COLUMN IF NOT EXISTS waterMeterField TEXT,
ADD COLUMN IF NOT EXISTS waterMeterGTB TEXT,
ADD COLUMN IF NOT EXISTS waterMeterDiff TEXT,
ADD COLUMN IF NOT EXISTS waterMeterLastRead TEXT,
ADD COLUMN IF NOT EXISTS waterMeterCoherence TEXT,
ADD COLUMN IF NOT EXISTS waterMeterObs TEXT,

-- Débits air sanitaires
ADD COLUMN IF NOT EXISTS sanitaryType TEXT,
ADD COLUMN IF NOT EXISTS sanitaryLocation TEXT,
ADD COLUMN IF NOT EXISTS airFlowMeasured TEXT,
ADD COLUMN IF NOT EXISTS airFlowRegulation TEXT,
ADD COLUMN IF NOT EXISTS airFlowCompliance TEXT,
ADD COLUMN IF NOT EXISTS airFlowVents TEXT,
ADD COLUMN IF NOT EXISTS airFlowVentsState TEXT,
ADD COLUMN IF NOT EXISTS airFlowObs TEXT,

-- GTB
ADD COLUMN IF NOT EXISTS gtbSoftware TEXT,
ADD COLUMN IF NOT EXISTS gtbVersion TEXT,
ADD COLUMN IF NOT EXISTS gtbPoints TEXT,
ADD COLUMN IF NOT EXISTS gtbPointsFault TEXT,
ADD COLUMN IF NOT EXISTS gtbAvailability TEXT,
ADD COLUMN IF NOT EXISTS gtbLastUpdate TEXT,
ADD COLUMN IF NOT EXISTS gtbAnomalies TEXT,

-- Qualité eau
ADD COLUMN IF NOT EXISTS waterQualityCircuit TEXT,
ADD COLUMN IF NOT EXISTS waterQualityPoint TEXT,
ADD COLUMN IF NOT EXISTS waterQualityPH TEXT,
ADD COLUMN IF NOT EXISTS waterQualityConductivity TEXT,
ADD COLUMN IF NOT EXISTS waterQualityTemp TEXT,
ADD COLUMN IF NOT EXISTS waterQualityHardness TEXT,
ADD COLUMN IF NOT EXISTS waterQualityTAC TEXT,
ADD COLUMN IF NOT EXISTS waterQualityTurbidity TEXT,
ADD COLUMN IF NOT EXISTS waterQualityChlorine TEXT,
ADD COLUMN IF NOT EXISTS waterQualityIron TEXT,
ADD COLUMN IF NOT EXISTS waterQualityTreatment TEXT,
ADD COLUMN IF NOT EXISTS waterQualityObs TEXT,

-- Évaluation et anomalies
ADD COLUMN IF NOT EXISTS ev INTEGER,
ADD COLUMN IF NOT EXISTS crit TEXT,
ADD COLUMN IF NOT EXISTS type_anomalie TEXT,
ADD COLUMN IF NOT EXISTS budget TEXT,
ADD COLUMN IF NOT EXISTS priorite TEXT,
ADD COLUMN IF NOT EXISTS constat TEXT,
ADD COLUMN IF NOT EXISTS observations TEXT,
ADD COLUMN IF NOT EXISTS actions TEXT,

-- Métadonnées
ADD COLUMN IF NOT EXISTS timestamp TIMESTAMPTZ;

-- Créer des index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_equipements_lot ON equipements(lot);
CREATE INDEX IF NOT EXISTS idx_equipements_code ON equipements(code);
CREATE INDEX IF NOT EXISTS idx_equipements_timestamp ON equipements(timestamp);
CREATE INDEX IF NOT EXISTS idx_equipements_lot_code_timestamp ON equipements(lot, code, timestamp);

-- Commentaires pour documentation
COMMENT ON COLUMN equipements.lot IS 'Lot technique (Structure, CVC, etc.)';
COMMENT ON COLUMN equipements.code IS 'Code unique de l''équipement';
COMMENT ON COLUMN equipements.ev IS 'État visuel (0-4)';
COMMENT ON COLUMN equipements.crit IS 'Criticité (U/I/A/S)';
COMMENT ON COLUMN equipements.timestamp IS 'Date et heure de création';
