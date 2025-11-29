# Script PowerShell pour corriger le bug de synchronisation Supabase

Write-Host "Correction en cours..." -ForegroundColor Cyan

$content = Get-Content "index.html" -Raw -Encoding UTF8

$ancien = "        // Exclure les champs stockés localement uniquement (ne vont pas dans Supabase)`r`n        delete equipmentForDb.croquis;  // Stocké localement comme les photos"

$nouveau = "        // Exclure TOUS les champs de gestion locale (ne vont PAS dans Supabase)`r`n        delete equipmentForDb.croquis;      // Stocké localement`r`n        delete equipmentForDb.status;       // État de synchronisation (local seulement)`r`n        delete equipmentForDb.synced;       // Flag de synchronisation (local seulement)`r`n        delete equipmentForDb.local_id;     // ID local (local seulement)`r`n        delete equipmentForDb.supabase_id;  // Géré séparément (local seulement)`r`n        delete equipmentForDb.photos;       // Photos gérées séparément`r`n        delete equipmentForDb.last_update;  // Timestamp de modification (local seulement)`r`n        delete equipmentForDb.created_at;   // Timestamp de création (local seulement)"

if ($content -match [regex]::Escape($ancien)) {
    $content = $content.Replace($ancien, $nouveau)
    $content | Set-Content "index.html" -NoNewline -Encoding UTF8
    Write-Host "OK - Modification terminee"  -ForegroundColor Green
    Write-Host "Rechargez votre application (F5) et resynchronisez"
} else {
    Write-Host "ERREUR - Texte introuvable" -ForegroundColor Red
}
