// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('ar'),
    Locale('tn'),
  ];

  String get appTitle => Intl.message('Tunisie Libertaire', name: 'appTitle');
  String get home => Intl.message('Accueil', name: 'home');
  String get favorites => Intl.message('Favoris', name: 'favorites');
  String get share => Intl.message('Partager', name: 'share');
  String get refresh => Intl.message('Actualiser', name: 'refresh');
  String get search => Intl.message('Rechercher', name: 'search');
  String get searchOnSite => Intl.message('Rechercher sur le site', name: 'searchOnSite');
  String get rssFeed => Intl.message('Flux RSS', name: 'rssFeed');
  String get zoomIn => Intl.message('Zoom +', name: 'zoomIn');
  String get zoomOut => Intl.message('Zoom -', name: 'zoomOut');
  String get darkMode => Intl.message('Mode sombre', name: 'darkMode');
  String get lightMode => Intl.message('Mode clair', name: 'lightMode');
  String get fullscreen => Intl.message('Plein écran', name: 'fullscreen');
  String get print => Intl.message('Imprimer', name: 'print');
  String get copyUrl => Intl.message('Copier URL', name: 'copyUrl');
  String get clearCache => Intl.message('Vider cache', name: 'clearCache');
  String get screenshot => Intl.message('Capture d\'écran', name: 'screenshot');
  String get translate => Intl.message('Traduire', name: 'translate');
  String get searchInPage => Intl.message('Rechercher dans la page', name: 'searchInPage');
  String get desktopVersion => Intl.message('Version bureau', name: 'desktopVersion');
  String get mobileVersion => Intl.message('Version mobile', name: 'mobileVersion');
  String get language => Intl.message('Langue', name: 'language');
  String get noFavorites => Intl.message('Aucun favori', name: 'noFavorites');
  String get favoriteAdded => Intl.message('Ajouté aux favoris', name: 'favoriteAdded');
  String get favoriteRemoved => Intl.message('Favori supprimé', name: 'favoriteRemoved');
  String get close => Intl.message('Fermer', name: 'close');
  String get cancel => Intl.message('Annuler', name: 'cancel');
  String get connectionProblem => Intl.message('Problème de connexion', name: 'connectionProblem');
  String get connectionProblemMessage => Intl.message('Il semble y avoir un problème de connexion. Voulez-vous recharger la page ?', name: 'connectionProblemMessage');
  String get ignore => Intl.message('Ignorer', name: 'ignore');
  String get reload => Intl.message('Recharger', name: 'reload');
  String get cacheCleared => Intl.message('Cache vidé', name: 'cacheCleared');
  String get screenshotTaken => Intl.message('Capture d\'écran prise', name: 'screenshotTaken');
  String get searchPlaceholder => Intl.message('Tapez votre recherche...', name: 'searchPlaceholder');
  String get pageLoaded => Intl.message('Page chargée', name: 'pageLoaded');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool isSupported(Locale locale) => ['fr', 'ar', 'tn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}