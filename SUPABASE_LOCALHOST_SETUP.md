# 🔧 Configuration Supabase pour Localhost - Guide Complet

## 📋 État Actuel

✅ **Supabase est DÉJÀ configuré** dans votre application !

- **URL Supabase** : `https://zxioajnyvrrfgomamtpl.supabase.co`
- **Clé configurée** : ✅ Oui (ligne 2414 de `index.html`)
- **Client initialisé** : ✅ Oui (lignes 2416-2423)

---

## ⚠️ Problèmes Identifiés

### 1. Champ `recommandations` MANQUANT dans la base de données
Le champ existe dans les données de test mais pas dans la table Supabase.

### 2. Colonnes en doublon dans la table
- `date_visite` vs `date`
- `heure_fin` vs `heureFin`
- `watermetertype` vs `waterMeterType`
- `criticite` vs `crit`
- `remarques` vs `observations`

---

## 🚀 PROCÉDURE DE CORRECTION

### ÉTAPE 1 : Corriger la Base de Données Supabase

1. **Connectez-vous à Supabase** : https://supabase.com/dashboard
2. Allez dans votre projet `zxioajnyvrrfgomamtpl`
3. Cliquez sur **SQL Editor** (dans le menu de gauche)
4. Cliquez sur **New query**
5. **Copiez-collez** le contenu du fichier `supabase-fix-complete.sql`
6. Cliquez sur **Run** pour exécuter le script
7. ✅ Vérifiez que le message "Migration terminée avec succès !" s'affiche

---

### ÉTAPE 2 : Configurer CORS pour Localhost

Pour que votre application fonctionne depuis localhost, vous devez autoriser les requêtes CORS :

1. Dans Supabase, allez dans **Settings** (⚙️)
2. Cliquez sur **API**
3. Scrollez jusqu'à **"CORS Origins"**
4. Ajoutez les URLs suivantes (une par ligne) :

```
http://localhost:5500
http://127.0.0.1:5500
http://localhost:3000
http://127.0.0.1:3000
file://
```

5. Cliquez sur **Save**

> **Note** : Le port 5500 est celui utilisé par Live Server (VS Code). Ajustez selon votre serveur.

---

### ÉTAPE 3 : Vérifier le Bucket Storage Photos

1. Dans Supabase, allez dans **Storage**
2. Vérifiez que le bucket **`pec-photos`** existe
3. Si ce n'est pas le cas :
   - Cliquez sur **New bucket**
   - Nom : `pec-photos`
   - **Public bucket** : ✅ OUI (cochez la case)
   - Cliquez sur **Create bucket**

4. **Configurer les politiques du bucket** :
   - Cliquez sur le bucket `pec-photos`
   - Allez dans **Policies**
   - Créez les politiques suivantes (pour développement) :

**SELECT (lecture) :**
```sql
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING ( bucket_id = 'pec-photos' );
```

**INSERT (upload) :**
```sql
CREATE POLICY "Public Insert"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'pec-photos' );
```

**DELETE (suppression) :**
```sql
CREATE POLICY "Public Delete"
ON storage.objects FOR DELETE
USING ( bucket_id = 'pec-photos' );
```

---

### ÉTAPE 4 : Tester la Connexion depuis Localhost

1. **Ouvrez votre application** dans le navigateur (via Live Server ou autre)
2. Appuyez sur **F12** pour ouvrir la console
3. Tapez cette commande pour vérifier Supabase :

```javascript
console.log('Supabase:', supabaseClient ? '✅ Connecté' : '❌ Non connecté');
```

4. **Créer un équipement de test** :
   - Sélectionnez un lot
   - Ajoutez un nouvel équipement
   - Remplissez le formulaire
   - Enregistrez

5. **Vérifier dans Supabase** :
   - Retournez dans Supabase
   - Allez dans **Table Editor**
   - Cliquez sur la table `equipements`
   - ✅ Vous devriez voir votre équipement !

---

### ÉTAPE 5 : Importer les Données de Test (OPTIONNEL)

Pour importer le fichier `test_data.json` :

1. **Ouvrez l'application** dans le navigateur
2. Cliquez sur le **Menu** (☰)
3. Allez dans **Réglages** ou **Importation**
4. Sélectionnez **Importer JSON**
5. Choisissez le fichier `test_data.json`
6. ✅ Les 17 équipements seront importés et synchronisés avec Supabase

---

## 🔍 Vérifications de Diagnostic

### Vérifier que Supabase est connecté

Dans la console du navigateur (F12) :

```javascript
// Vérifier le client
console.log('Client Supabase:', supabaseClient);

// Test de connexion
async function testSupabase() {
  const { data, error } = await supabaseClient
    .from('equipements')
    .select('count');
  
  if (error) {
    console.error('❌ Erreur:', error);
  } else {
    console.log('✅ Connexion OK - Nombre d\'équipements:', data);
  }
}

testSupabase();
```

### Vérifier les erreurs CORS

Si vous voyez des erreurs comme :
```
Access to fetch at '...' from origin 'http://localhost:5500' has been blocked by CORS policy
```

➡️ Retournez à l'**ÉTAPE 2** et ajoutez votre URL dans les CORS Origins.

---

## 🐛 Dépannage

### Problème : "Client Supabase non initialisé"

**Solution** :
1. Vérifiez que la bibliothèque Supabase est chargée (ligne 16 de `index.html`)
2. Ouvrez la console et vérifiez : `typeof supabase`
3. Devrait afficher : `"object"`

### Problème : "Table 'equipements' does not exist"

**Solution** :
1. Exécutez d'abord `supabase_schema.sql`
2. Puis exécutez `supabase-migration.sql`
3. Enfin exécutez `supabase-fix-complete.sql`

### Problème : "RLS policy violation"

**Solution** :
1. Allez dans Supabase > **Authentication** > **Policies**
2. Vérifiez que les politiques publiques sont actives
3. Réexécutez les politiques du fichier `supabase_schema.sql` (lignes 38-47)

---

## ✅ Checklist de Vérification Finale

Après avoir suivi toutes les étapes, vérifiez :

- [ ] Le script `supabase-fix-complete.sql` a été exécuté sans erreur
- [ ] Le champ `recommandations` existe dans la table `equipements`
- [ ] Les doublons de colonnes ont été supprimés
- [ ] Les URLs CORS pour localhost sont configurées
- [ ] Le bucket `pec-photos` existe et est public
- [ ] Le client Supabase est initialisé dans la console
- [ ] Un équipement de test peut être créé et synchronisé
- [ ] Les données apparaissent dans Supabase Table Editor

---

## 📊 Commandes SQL Utiles

### Compter les équipements
```sql
SELECT COUNT(*) FROM equipements;
```

### Voir les derniers équipements ajoutés
```sql
SELECT lot, type, code, created_at 
FROM equipements 
ORDER BY created_at DESC 
LIMIT 10;
```

### Voir la structure de la table
```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'equipements'
ORDER BY ordinal_position;
```

### Supprimer tous les équipements (pour repartir à zéro)
```sql
-- ⚠️ ATTENTION : Ceci supprime TOUTES les données !
TRUNCATE equipements CASCADE;
```

---

## 🎯 Résumé

Votre configuration Supabase est **déjà en place** dans le code. Il ne reste plus qu'à :

1. ✅ Exécuter le script de correction SQL
2. ✅ Configurer CORS pour localhost
3. ✅ Vérifier le bucket photos
4. ✅ Tester la connexion

Après cela, votre application fonctionnera parfaitement depuis localhost avec synchronisation Supabase !

---

## 📞 Besoin d'Aide ?

Si vous rencontrez des problèmes :

1. Regardez la **console du navigateur** (F12) pour les erreurs
2. Vérifiez les **logs Supabase** (dans le dashboard > Logs)
3. Testez les connexions avec les commandes de diagnostic ci-dessus
