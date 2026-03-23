# Tunisie Libertaire - Application Mobile

Application mobile officielle du blog **Tunisie Libertaire**, développée avec Flutter.

## 🌍 Support Multilingue

L'application supporte **3 langues** avec changement instantané :

## 📱 Fonctionnalités Principales

### 🌐 Navigation Web
- **WebView optimisée** du site tunisielibertaire.wordpress.com
- **Navigation fluide** : Précédent/Suivant, Accueil
- **Gestion d'erreurs intelligente** : Plus de rechargements intempestifs
- **Connexion stable** avec détection automatique des problèmes réseau

### ⭐ Gestion des Favoris
- **Sauvegarde persistante** des pages favorites
- **Interface intuitive** pour ajouter/supprimer
- **Accès rapide** depuis le menu principal

### 🔧 Outils Avancés
- **Sélecteur de langue** avec sauvegarde automatique
- **Partage natif** via les applications Android
- **Recherche** : Dans la page et sur le site
- **Zoom** : Ajustement de la taille du texte
- **Modes d'affichage** : Sombre/Clair, Plein écran
- **Utilitaires** : Impression, Copie URL, Capture d'écran
- **Cache** : Nettoyage et optimisation
- **User-Agent** : Basculement version bureau/mobile
- **Traduction** : Intégration Google Translate

### 🛡️ Stabilité & Performance
- **Gestion d'erreurs robuste** : Compteur d'erreurs critiques
- **Rechargement intelligent** : Confirmation utilisateur uniquement
- **Interface responsive** : Adaptation automatique RTL pour l'arabe

## 📥 Téléchargement

### Version Multilingue (Recommandée)
[**Télécharger l'APK v2.0**](https://github.com/AnARCHIS12/tunsilibertaire-app/releases/latest) 

**Nouveautés v2.0 :**
- ✅ Support 3 langues (FR/AR/TN)
- ✅ Interface stabilisée (plus de rechargements)
- ✅ Gestion d'erreurs intelligente
- ✅ Traductions authentiques en dialecte tunisien

### Version Précédente
[**APK v1.0**](https://github.com/AnARCHIS12/tunsilibertaire-app/releases/download/1.00/TunisieLibertaire.apk) (46.5 MB)

## 🛠️ Installation

1. **Téléchargez** le fichier APK depuis les releases
2. **Activez** "Sources inconnues" dans Paramètres → Sécurité
3. **Installez** l'APK en tapant dessus
4. **Choisissez** votre langue préférée au premier lancement

## 🔧 Développement

### Prérequis
- Flutter SDK (≥3.9.0)
- Android SDK
- Dart

### Installation
```bash
# Cloner le projet
git clone https://github.com/AnARCHIS12/tunsilibertaire-app.git
cd tunsilibertaire-app/blog_app

# Installer les dépendances
flutter pub get

# Générer les traductions (si modifiées)
flutter gen-l10n

# Build debug
flutter build apk --debug

# Build release
flutter build apk --release
```

### Structure du Projet
```
blog_app/
├── lib/
│   ├── main.dart              # Application principale
│   ├── generated/             # Fichiers de localisation générés
│   │   ├── l10n.dart         # Classe AppLocalizations
│   │   └── intl/             # Messages par langue
│   └── l10n/                 # Fichiers de traduction source
│       ├── app_fr.arb        # Français
│       ├── app_ar.arb        # Arabe
│       └── app_tn.arb        # Tunisien
├── pubspec.yaml              # Dépendances
└── l10n.yaml                 # Configuration i18n
```

## 🌐 Utilisation

### Changement de Langue
1. Ouvrez le **menu** (⋮ en haut à droite)
2. Sélectionnez **"Langue"** / **"اللغة"**
3. Choisissez votre langue préférée
4. L'interface se met à jour instantanément

### Gestion des Favoris
- **Ajouter** : Cliquez sur ❤️ dans la barre d'outils
- **Voir** : Menu → Favoris
- **Supprimer** : Cliquez sur 🗑️ dans la liste des favoris

### Fonctionnalités Avancées
- **Recherche dans la page** : Menu → Rechercher dans la page
- **Mode sombre** : Menu → Mode sombre
- **Zoom** : Menu → Zoom +/-
- **Partage** : Cliquez sur ❤️ puis partagez

## 🔄 Changelog

### v2.0 (Actuelle)
- ✅ Support multilingue (FR/AR/TN)
- ✅ Traductions authentiques en dialecte tunisien
- ✅ Gestion d'erreurs intelligente
- ✅ Interface stabilisée
- ✅ Sauvegarde automatique de la langue

### v1.0
- ✅ WebView de base
- ✅ Navigation et favoris
- ✅ Menu d'options

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour ajouter une langue ou améliorer les traductions :

1. **Fork** le projet
2. **Créez** un fichier `app_XX.arb` dans `lib/l10n/`
3. **Ajoutez** la locale dans `main.dart`
4. **Créez** le fichier de messages correspondant
5. **Soumettez** une Pull Request

## 📄 Licence

MIT License - Voir [LICENSE](LICENSE)

## 🌐 Liens

- **Site Web** : [tunisielibertaire.wordpress.com](https://tunisielibertaire.wordpress.com)
- **Flux RSS** : [tunisielibertaire.wordpress.com/feed](https://tunisielibertaire.wordpress.com/feed/)
- **Releases** : [GitHub Releases](https://github.com/AnARCHIS12/tunsilibertaire-app/releases)

---

**Développé avec ❤️ pour la communauté tunisienne**
