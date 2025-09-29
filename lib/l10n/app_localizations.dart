import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding App'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @manageYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Account'**
  String get manageYourAccount;

  /// No description provided for @devicePermission.
  ///
  /// In en, this message translates to:
  /// **'Device Permission'**
  String get devicePermission;

  /// No description provided for @languageAndTranslations.
  ///
  /// In en, this message translates to:
  /// **'Language and Translations'**
  String get languageAndTranslations;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bahasaMelayu.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Melayu'**
  String get bahasaMelayu;

  /// No description provided for @languageChangeNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Changing the language will affect all text in the application.'**
  String get languageChangeNote;

  /// No description provided for @languageChangedToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChangedToEnglish;

  /// No description provided for @languageChangedToMalay.
  ///
  /// In en, this message translates to:
  /// **'Bahasa ditukar kepada Bahasa Melayu'**
  String get languageChangedToMalay;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get somethingWentWrong;

  /// No description provided for @quickaction.
  ///
  /// In en, this message translates to:
  /// **'Quick Action'**
  String get quickaction;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @mydocument.
  ///
  /// In en, this message translates to:
  /// **'My\nDocument'**
  String get mydocument;

  /// No description provided for @meettheteam.
  ///
  /// In en, this message translates to:
  /// **'Meet\nThe Team'**
  String get meettheteam;

  /// No description provided for @buddychat.
  ///
  /// In en, this message translates to:
  /// **'Buddy Chat'**
  String get buddychat;

  /// No description provided for @taskmanager.
  ///
  /// In en, this message translates to:
  /// **'Task Manager'**
  String get taskmanager;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @learninghub.
  ///
  /// In en, this message translates to:
  /// **'Learning Hub'**
  String get learninghub;

  /// No description provided for @myjourney.
  ///
  /// In en, this message translates to:
  /// **'My\nJourney'**
  String get myjourney;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @scanqr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanqr;

  /// No description provided for @myqr.
  ///
  /// In en, this message translates to:
  /// **'My QR'**
  String get myqr;

  /// No description provided for @workinformation.
  ///
  /// In en, this message translates to:
  /// **'Work Information'**
  String get workinformation;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @workplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get workplace;

  /// No description provided for @scanthisQRcodeapptoaddmeasacontactinapp.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code (app) to add me as a contact in-app'**
  String get scanthisQRcodeapptoaddmeasacontactinapp;

  /// No description provided for @thisQRcontainsavCardphonecamerasGoogleLenscanofferAddcontact.
  ///
  /// In en, this message translates to:
  /// **'This QR contains a vCard — phone cameras/Google Lens can offer (Add contact)'**
  String get thisQRcontainsavCardphonecamerasGoogleLenscanofferAddcontact;

  /// No description provided for @usevCardQRphonecameras.
  ///
  /// In en, this message translates to:
  /// **'Use vCard QR(Phone Camera)'**
  String get usevCardQRphonecameras;

  /// No description provided for @sortbyNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Sort Name (A-Z)'**
  String get sortbyNameAZ;

  /// No description provided for @createNewFolder.
  ///
  /// In en, this message translates to:
  /// **'Create New Folder'**
  String get createNewFolder;

  /// No description provided for @addNewFile.
  ///
  /// In en, this message translates to:
  /// **'Add New File'**
  String get addNewFile;

  /// No description provided for @organizationChart.
  ///
  /// In en, this message translates to:
  /// **'Organization Chart'**
  String get organizationChart;

  /// No description provided for @departmentStructure.
  ///
  /// In en, this message translates to:
  /// **'Department Structure'**
  String get departmentStructure;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ms': return AppLocalizationsMs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
