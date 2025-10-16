import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
    Locale('tn'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tunisie Libertaire'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// No description provided for @favorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favorites;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @searchOnSite.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher sur le site'**
  String get searchOnSite;

  /// No description provided for @rssFeed.
  ///
  /// In fr, this message translates to:
  /// **'Flux RSS'**
  String get rssFeed;

  /// No description provided for @zoomIn.
  ///
  /// In fr, this message translates to:
  /// **'Zoom +'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In fr, this message translates to:
  /// **'Zoom -'**
  String get zoomOut;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode clair'**
  String get lightMode;

  /// No description provided for @fullscreen.
  ///
  /// In fr, this message translates to:
  /// **'Plein écran'**
  String get fullscreen;

  /// No description provided for @print.
  ///
  /// In fr, this message translates to:
  /// **'Imprimer'**
  String get print;

  /// No description provided for @copyUrl.
  ///
  /// In fr, this message translates to:
  /// **'Copier URL'**
  String get copyUrl;

  /// No description provided for @clearCache.
  ///
  /// In fr, this message translates to:
  /// **'Vider cache'**
  String get clearCache;

  /// No description provided for @screenshot.
  ///
  /// In fr, this message translates to:
  /// **'Capture d\'écran'**
  String get screenshot;

  /// No description provided for @translate.
  ///
  /// In fr, this message translates to:
  /// **'Traduire'**
  String get translate;

  /// No description provided for @searchInPage.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans la page'**
  String get searchInPage;

  /// No description provided for @desktopVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version bureau'**
  String get desktopVersion;

  /// No description provided for @mobileVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version mobile'**
  String get mobileVersion;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @noFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori'**
  String get noFavorites;

  /// No description provided for @favoriteAdded.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté aux favoris'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Favori supprimé'**
  String get favoriteRemoved;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @connectionProblem.
  ///
  /// In fr, this message translates to:
  /// **'Problème de connexion'**
  String get connectionProblem;

  /// No description provided for @connectionProblemMessage.
  ///
  /// In fr, this message translates to:
  /// **'Il semble y avoir un problème de connexion. Voulez-vous recharger la page ?'**
  String get connectionProblemMessage;

  /// No description provided for @ignore.
  ///
  /// In fr, this message translates to:
  /// **'Ignorer'**
  String get ignore;

  /// No description provided for @reload.
  ///
  /// In fr, this message translates to:
  /// **'Recharger'**
  String get reload;

  /// No description provided for @cacheCleared.
  ///
  /// In fr, this message translates to:
  /// **'Cache vidé'**
  String get cacheCleared;

  /// No description provided for @screenshotTaken.
  ///
  /// In fr, this message translates to:
  /// **'Capture d\'écran prise'**
  String get screenshotTaken;

  /// No description provided for @searchPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Tapez votre recherche...'**
  String get searchPlaceholder;

  /// No description provided for @pageLoaded.
  ///
  /// In fr, this message translates to:
  /// **'Page chargée'**
  String get pageLoaded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr', 'tn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
    case 'tn':
      return AppLocalizationsTn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
