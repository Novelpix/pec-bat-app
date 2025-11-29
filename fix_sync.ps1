# Script PowerShell pour corriger le bug de synchronisation Supabase
# Ce script ajoute les instructions 'delete' manquantes dans index.html

Write-Host "🔧 Correction du bug de synchronisation Supabase..." -ForegroundColor Cyan

# Lire le fichier
$content = Get-Content "index.html" -Raw

# Vérifier que le fichier contient bien la ligne à remplacer
if ($content -notmatch "delete equipmentForDb\.croquis;  // Stocké localement comme les photos") {
    Write-Host "❌ ERREUR: La ligne cible n'a pas été trouvée dans index.html" -ForegroundColor Red
    Write-Host "Le fichier a peut-être déjà été modifié." -ForegroundColor Yellow
    exit 1
}

# Texte à remplacer
$ancienTexte = @"
        // Exclure les champs stockés localement uniquement (ne vont pas dans Supabase)
        delete equipmentForDb.croquis;  // Stocké localement comme les photos
"@

# Nouveau texte
$nouveauTexte = @"
        // 🔧 Exclure TOUS les champs de gestion locale (ne vont PAS dans Supabase)
        delete equipmentForDb.croquis;      // Stocké localement
        delete equipmentForDb.status;       // État de synchronisation (local seulement)
        delete equipmentForDb.synced;       // Flag de synchronisation (local seulement)
        delete equipmentForDb.local_id;     // ID local (local seulement)
        delete equipmentForDb.supabase_id;  // Géré séparément (local seulement)
        delete equipmentForDb.photos;       // Photos gérées séparément
        delete equipmentForDb.last_update;  // Timestamp de modification (local seulement)
        delete equipmentForDb.created_at;   // Timestamp de création (local seulement)
"@

# Faire la substitution
$content = $content.Replace($ancienTexte, $nouveauTexte)

# Sauvegarder
$content | Set-Content "index.html" -NoNewline

Write-Host "✅ Modification réussie !" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Prochaines étapes:" -ForegroundColor Yellow
Write-Host "  1. Rechargez l'application dans le navigateur (F5)"
Write-Host "  2. Cliquez sur 'Synchroniser avec Supabase'"
Write-Host "  3. Vous devriez avoir: 17 succès / 0 échecs !"
Write-Host ""
