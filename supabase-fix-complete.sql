-- ═══════════════════════════════════════════════════════════════════════
-- SCRIPT DE CORRECTION COMPLÈTE - Table equipements
-- ═══════════════════════════════════════════════════════════════════════
-- Date: 2025-11-29
-- Objet: 
--   1. Ajouter le champ manquant 'recommandations'
--   2. Nettoyer les doublons de colonnes
--   3. Optimiser la structure
--
-- ⚠️ ATTENTION: Faites une sauvegarde avant d'exécuter ce script !
-- ═══════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 1: AJOUTER LA COLONNE MANQUANTE 'recommandations'
-- ═══════════════════════════════════════════════════════════════════════

ALTER TABLE equipements
ADD COLUMN IF NOT EXISTS recommandations TEXT;

COMMENT ON COLUMN equipements.recommandations IS 'Recommandations techniques pour l''équipement';

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 2: MIGRATION DES DONNÉES DES DOUBLONS (si nécessaire)
-- ═══════════════════════════════════════════════════════════════════════

-- Migrer date_visite vers date
UPDATE equipements 
SET date = COALESCE(date, date_visite)
WHERE date IS NULL AND date_visite IS NOT NULL;

-- Migrer heure_fin vers heureFin
UPDATE equipements 
SET "heureFin" = COALESCE("heureFin", heure_fin)
WHERE "heureFin" IS NULL AND heure_fin IS NOT NULL;

-- Migrer watermetertype (minuscule) vers waterMeterType
UPDATE equipements 
SET "waterMeterType" = COALESCE("waterMeterType", watermetertype)
WHERE "waterMeterType" IS NULL AND watermetertype IS NOT NULL;

-- Migrer criticite vers crit
UPDATE equipements 
SET crit = COALESCE(crit, criticite)
WHERE crit IS NULL AND criticite IS NOT NULL;

-- Migrer remarques vers observations
UPDATE equipements 
SET observations = COALESCE(observations, remarques)
WHERE observations IS NULL AND remarques IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 3: SUPPRESSION DES COLONNES EN DOUBLON
-- ═══════════════════════════════════════════════════════════════════════

-- Supprimer les doublons
ALTER TABLE equipements DROP COLUMN IF EXISTS date_visite;
ALTER TABLE equipements DROP COLUMN IF EXISTS heure_fin;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermetertype;
ALTER TABLE equipements DROP COLUMN IF EXISTS criticite;
ALTER TABLE equipements DROP COLUMN IF EXISTS remarques;

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 4: AJOUTER UN INDEX SUR recommandations (pour recherche)
-- ═══════════════════════════════════════════════════════════════════════

CREATE INDEX IF NOT EXISTS idx_equipements_recommandations 
ON equipements USING gin (to_tsvector('french', recommandations));

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 5: VÉRIFICATION POST-MIGRATION
-- ═══════════════════════════════════════════════════════════════════════

-- Afficher la structure finale complète
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'equipements'
ORDER BY ordinal_position;

-- Compter les équipements
SELECT COUNT(*) as total_equipements FROM equipements;

-- Vérifier les colonnes importantes
SELECT 
    COUNT(*) as total,
    COUNT(lot) as avec_lot,
    COUNT(date) as avec_date,
    COUNT("heureFin") as avec_heureFin,
    COUNT(crit) as avec_crit,
    COUNT(recommandations) as avec_recommandations
FROM equipements;

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 6: CONFIGURATION CORS POUR LOCALHOST
-- ═══════════════════════════════════════════════════════════════════════

-- Note: La configuration CORS se fait dans les paramètres Supabase
-- Allez dans: Settings > API > CORS Origins
-- Ajoutez: http://localhost:5500 (ou votre port)
--          http://127.0.0.1:5500
--          file://

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 7: VÉRIFIER LES POLITIQUES RLS (Row Level Security)
-- ═══════════════════════════════════════════════════════════════════════

-- Vérifier que les politiques publiques sont actives (pour développement)
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies 
WHERE tablename IN ('equipements', 'photos');

-- ═══════════════════════════════════════════════════════════════════════
-- ÉTAPE 8 (OPTIONNEL): CRÉER UN BUCKET STORAGE POUR LES PHOTOS
-- ═══════════════════════════════════════════════════════════════════════

-- Note: Ceci doit être fait via l'interface Supabase Storage
-- 1. Allez dans Storage > Create bucket
-- 2. Nom: "pec-photos"
-- 3. Public: OUI
-- 4. Politiques: 
--    - SELECT: public
--    - INSERT: public (pour développement)
--    - DELETE: public (pour développement)

-- ═══════════════════════════════════════════════════════════════════════
-- FIN DU SCRIPT
-- ═══════════════════════════════════════════════════════════════════════

-- Afficher un message de confirmation
SELECT 
    '✅ Migration terminée avec succès !' as status,
    (SELECT COUNT(*) FROM equipements) as total_equipements,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'equipements') as total_colonnes;
