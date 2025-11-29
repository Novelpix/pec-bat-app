-- ═══════════════════════════════════════════════════════════════════════
-- 🚀 SCRIPT DE CORRECTION COMPLÈTE - À EXÉCUTER MAINTENANT
-- ═══════════════════════════════════════════════════════════════════════
-- Ce script corrige TOUS les problèmes en une seule fois
-- Date: 2025-11-29
-- ═══════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════
-- ✅ ÉTAPE 1: AJOUTER LA COLONNE RECOMMANDATIONS (PROBLÈME PRINCIPAL)
-- ═══════════════════════════════════════════════════════════════════════

ALTER TABLE equipements
ADD COLUMN IF NOT EXISTS recommandations TEXT;

COMMENT ON COLUMN equipements.recommandations IS 'Recommandations techniques pour l''équipement';

-- ═══════════════════════════════════════════════════════════════════════
-- ✅ ÉTAPE 2: AJOUTER TOUTES LES COLONNES MANQUANTES (au cas où)
-- ═══════════════════════════════════════════════════════════════════════

ALTER TABLE equipements
ADD COLUMN IF NOT EXISTS supabase_id UUID;

-- ═══════════════════════════════════════════════════════════════════════
-- 🧹 ÉTAPE 3: MIGRATION DES DOUBLONS AVANT SUPPRESSION
-- ═══════════════════════════════════════════════════════════════════════

-- Migrer date_visite vers date
UPDATE equipements 
SET date = COALESCE(date, date_visite)
WHERE date IS NULL AND date_visite IS NOT NULL;

-- Migrer heure_fin vers heureFin
UPDATE equipements 
SET "heureFin" = COALESCE("heureFin", heure_fin)
WHERE "heureFin" IS NULL AND heure_fin IS NOT NULL;

-- Migrer watermetertype vers waterMeterType
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
-- 🗑️ ÉTAPE 4: SUPPRIMER LES COLONNES EN DOUBLON
-- ═══════════════════════════════════════════════════════════════════════

ALTER TABLE equipements DROP COLUMN IF EXISTS date_visite;
ALTER TABLE equipements DROP COLUMN IF EXISTS heure_fin;
ALTER TABLE equipements DROP COLUMN IF EXISTS watermetertype;
ALTER TABLE equipements DROP COLUMN IF EXISTS criticite;
ALTER TABLE equipements DROP COLUMN IF EXISTS remarques;

-- ═══════════════════════════════════════════════════════════════════════
-- 📊 ÉTAPE 5: CRÉER DES INDEX POUR OPTIMISER LES PERFORMANCES
-- ═══════════════════════════════════════════════════════════════════════

CREATE INDEX IF NOT EXISTS idx_equipements_lot ON equipements(lot);
CREATE INDEX IF NOT EXISTS idx_equipements_code ON equipements(code);
CREATE INDEX IF NOT EXISTS idx_equipements_timestamp ON equipements(timestamp);
CREATE INDEX IF NOT EXISTS idx_equipements_supabase_id ON equipements(supabase_id);

-- Index pour recherche full-text sur recommandations
CREATE INDEX IF NOT EXISTS idx_equipements_recommandations_search 
ON equipements USING gin (to_tsvector('french', COALESCE(recommandations, '')));

-- ═══════════════════════════════════════════════════════════════════════
-- 🔒 ÉTAPE 6: VÉRIFIER ET RECRÉER LES POLITIQUES RLS
-- ═══════════════════════════════════════════════════════════════════════

-- Supprimer les anciennes politiques si elles existent
DROP POLICY IF EXISTS "public select" ON equipements;
DROP POLICY IF EXISTS "public insert" ON equipements;
DROP POLICY IF EXISTS "public update" ON equipements;
DROP POLICY IF EXISTS "public delete" ON equipements;

-- Recréer les politiques (mode développement - accès public)
CREATE POLICY "public select" ON equipements 
FOR SELECT USING (true);

CREATE POLICY "public insert" ON equipements 
FOR INSERT WITH CHECK (true);

CREATE POLICY "public update" ON equipements 
FOR UPDATE USING (true);

CREATE POLICY "public delete" ON equipements 
FOR DELETE USING (true);

-- ═══════════════════════════════════════════════════════════════════════
-- ✅ ÉTAPE 7: VÉRIFICATIONS FINALES
-- ═══════════════════════════════════════════════════════════════════════

-- Vérifier la présence de la colonne recommandations
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'equipements' 
      AND column_name = 'recommandations'
  ) THEN
    RAISE NOTICE '✅ Colonne "recommandations" présente';
  ELSE
    RAISE EXCEPTION '❌ ERREUR: Colonne "recommandations" absente !';
  END IF;
END $$;

-- Afficher la structure complète de la table
SELECT 
    '📋 STRUCTURE DE LA TABLE' as info,
    COUNT(*) as nombre_colonnes
FROM information_schema.columns 
WHERE table_name = 'equipements';

-- Afficher les statistiques
SELECT 
    '📊 STATISTIQUES' as info,
    COUNT(*) as total_equipements,
    COUNT(recommandations) as avec_recommandations,
    COUNT(date) as avec_date,
    COUNT(lot) as avec_lot
FROM equipements;

-- Afficher un message de succès
SELECT 
    '✅ MIGRATION TERMINÉE AVEC SUCCÈS !' as status,
    current_timestamp as date_execution,
    (SELECT COUNT(*) FROM equipements) as total_equipements,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'equipements') as total_colonnes;

-- ═══════════════════════════════════════════════════════════════════════
-- 📝 LISTE DES COLONNES (pour vérification)
-- ═══════════════════════════════════════════════════════════════════════

SELECT 
    column_name,
    data_type,
    is_nullable,
    CASE 
        WHEN column_name = 'recommandations' THEN '⭐ NOUVELLE'
        WHEN column_name IN ('date_visite', 'heure_fin', 'watermetertype', 'criticite', 'remarques') THEN '❌ SUPPRIMÉE'
        ELSE ''
    END as statut
FROM information_schema.columns 
WHERE table_name = 'equipements'
ORDER BY ordinal_position;
