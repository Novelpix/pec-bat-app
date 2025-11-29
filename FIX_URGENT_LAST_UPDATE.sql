-- ═══════════════════════════════════════════════════════════════════════
-- 🚨 CORRECTION URGENTE - Colonnes manquantes
-- ═══════════════════════════════════════════════════════════════════════
-- Problème: La colonne 'last_update' est absente
-- Solution: Ajouter cette colonne + vérifier toutes les autres
-- ═══════════════════════════════════════════════════════════════════════

-- ÉTAPE 1 : Ajouter la colonne last_update (PRIORITÉ URGENTE)
ALTER TABLE equipements
ADD COLUMN IF NOT EXISTS last_update TIMESTAMPTZ DEFAULT NOW();

-- ÉTAPE 2 : Ajouter la colonne recommandations (si pas encore fait)
ALTER TABLE equipements
ADD COLUMN IF NOT EXISTS recommandations TEXT;

-- ÉTAPE 3 : Ajouter toutes les colonnes potentiellement manquantes
ALTER TABLE equipements
ADD COLUMN IF NOT EXISTS supabase_id UUID;

-- ÉTAPE 4 : Rafraîchir le cache du schéma Supabase
-- Note: Cette commande force Supabase à recharger la structure de la table
NOTIFY pgrst, 'reload schema';

-- ÉTAPE 5 : Vérification immédiate
SELECT 
    'Vérification des colonnes critiques' as action,
    EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'equipements' AND column_name = 'last_update'
    ) as last_update_existe,
    EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'equipements' AND column_name = 'recommandations'
    ) as recommandations_existe,
    EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'equipements' AND column_name = 'supabase_id'
    ) as supabase_id_existe;

-- ÉTAPE 6 : Afficher TOUTES les colonnes de la table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'equipements'
ORDER BY ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════
-- MESSAGE DE CONFIRMATION
-- ═══════════════════════════════════════════════════════════════════════
SELECT 
    '✅ CORRECTIF APPLIQUÉ !' as status,
    'La colonne last_update a été ajoutée' as action,
    'Rechargez votre application (F5) et réessayez' as prochaine_etape;
