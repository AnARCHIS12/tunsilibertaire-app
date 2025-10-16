import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('fr');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveLanguage(locale.languageCode);
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'fr';
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunisie Libertaire',
      theme: ThemeData(primarySwatch: Colors.red),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('ar'),
        Locale('tn'),
      ],
      home: BlogWebView(onLanguageChange: _changeLanguage),
    );
  }
}

class BlogWebView extends StatefulWidget {
  final Function(Locale) onLanguageChange;
  
  const BlogWebView({super.key, required this.onLanguageChange});

  @override
  State<BlogWebView> createState() => _BlogWebViewState();
}

class _BlogWebViewState extends State<BlogWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  bool canGoBack = false;
  bool canGoForward = false;
  String currentUrl = 'https://tunisielibertaire.wordpress.com';
  String pageTitle = 'Tunisie Libertaire';
  List<String> favorites = [];
  bool isFullscreen = false;
  int criticalErrorCount = 0;
  DateTime? lastErrorTime;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            isLoading = true;
            currentUrl = url;
          });
        },
        onPageFinished: (url) async {
          setState(() {
            isLoading = false;
            currentUrl = url;
          });
          _updateNavigationState();
          _getPageTitle();
          print('Page chargée: $url');
        },
        onWebResourceError: (error) {
          _handleWebResourceError(error);
        },
      ))
      ..setUserAgent('Mozilla/5.0 (Linux; Android 12; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36')
      ..addJavaScriptChannel('Flutter', onMessageReceived: (message) {})
      ..enableZoom(true)
      ..loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com'), 
          headers: {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'fr-FR,fr;q=0.9,en;q=0.8',
            'Cache-Control': 'no-cache',
          });
  }

  Future<void> _updateNavigationState() async {
    final back = await controller.canGoBack();
    final forward = await controller.canGoForward();
    setState(() {
      canGoBack = back;
      canGoForward = forward;
    });
  }

  Future<void> _getPageTitle() async {
    final title = await controller.getTitle();
    setState(() {
      pageTitle = title ?? 'Tunisie Libertaire';
    });
  }

  void _handleWebResourceError(WebResourceError error) {
    print('Erreur de ressource web: ${error.description} (Code: ${error.errorCode})');
    
    // Erreurs critiques qui nécessitent une attention
    final criticalErrorCodes = [
      -2, // ERR_INTERNET_DISCONNECTED
      -6, // ERR_CONNECTION_REFUSED
      -7, // ERR_CONNECTION_TIMED_OUT
      -105, // ERR_NAME_NOT_RESOLVED
      -106, // ERR_INTERNET_DISCONNECTED
      -118, // ERR_CONNECTION_TIMED_OUT
    ];
    
    if (criticalErrorCodes.contains(error.errorCode)) {
      final now = DateTime.now();
      
      // Reset le compteur si la dernière erreur était il y a plus de 30 secondes
      if (lastErrorTime == null || now.difference(lastErrorTime!).inSeconds > 30) {
        criticalErrorCount = 0;
      }
      
      criticalErrorCount++;
      lastErrorTime = now;
      
      // Après 3 erreurs critiques, proposer de recharger
      if (criticalErrorCount >= 3) {
        _showReloadDialog();
        criticalErrorCount = 0; // Reset après avoir montré le dialog
      }
    }
  }

  void _showReloadDialog() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.connectionProblem),
        content: Text(l10n.connectionProblemMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ignore),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.reload();
            },
            child: Text(l10n.reload),
          ),
        ],
      ),
    );
  }

  void _shareCurrentPage() {
    Share.share('$pageTitle\n$currentUrl');
  }

  void _showFavorites() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.favorites),
        content: favorites.isEmpty 
          ? Text(l10n.noFavorites)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: favorites.map((url) => ListTile(
                title: Text(url.length > 40 ? '${url.substring(0, 40)}...' : url),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      favorites.remove(url);
                    });
                    _saveFavorites();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.favoriteRemoved)),
                    );
                  },
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.loadRequest(Uri.parse(url));
                },
              )).toList(),
            ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favorites);
  }

  void _addToFavorites() {
    final l10n = AppLocalizations.of(context)!;
    if (!favorites.contains(currentUrl)) {
      setState(() {
        favorites.add(currentUrl);
      });
      _saveFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.favoriteAdded)),
      );
    }
  }

  void _toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
    if (isFullscreen) {
      controller.runJavaScript('document.documentElement.requestFullscreen()');
    } else {
      controller.runJavaScript('document.exitFullscreen()');
    }
  }

  void _takeScreenshot() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.screenshotTaken)),
    );
  }

  void _showSearchDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        String searchText = '';
        return AlertDialog(
          title: Text(l10n.searchInPage),
          content: TextField(
            onChanged: (value) => searchText = value,
            decoration: InputDecoration(hintText: l10n.searchPlaceholder),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.runJavaScript('window.find("$searchText")');
              },
              child: Text(l10n.search),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Français'),
              onTap: () {
                Navigator.pop(context);
                widget.onLanguageChange(const Locale('fr'));
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                Navigator.pop(context);
                widget.onLanguageChange(const Locale('ar'));
              },
            ),
            ListTile(
              title: const Text('تونسي'),
              onTap: () {
                Navigator.pop(context);
                widget.onLanguageChange(const Locale('tn'));
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showMenu() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            ListTile(
              leading: const Icon(Icons.language, color: Colors.red),
              title: Text(l10n.language),
              onTap: () {
                Navigator.pop(context);
                _showLanguageDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.red),
              title: Text(l10n.home),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.red),
              title: Text(l10n.refresh),
              onTap: () {
                Navigator.pop(context);
                controller.reload();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.red),
              title: Text(l10n.share),
              onTap: () {
                Navigator.pop(context);
                _shareCurrentPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.red),
              title: Text(l10n.searchOnSite),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com/?s='));
              },
            ),
            ListTile(
              leading: const Icon(Icons.rss_feed, color: Colors.red),
              title: Text(l10n.rssFeed),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com/feed/'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.red),
              title: Text(l10n.favorites),
              onTap: () {
                Navigator.pop(context);
                _showFavorites();
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_increase, color: Colors.red),
              title: Text(l10n.zoomIn),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.zoom = "1.2"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_decrease, color: Colors.red),
              title: Text(l10n.zoomOut),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.zoom = "0.8"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.red),
              title: Text(l10n.darkMode),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.filter = "invert(1) hue-rotate(180deg)"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode, color: Colors.red),
              title: Text(l10n.lightMode),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.filter = "none"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fullscreen, color: Colors.red),
              title: Text(l10n.fullscreen),
              onTap: () {
                Navigator.pop(context);
                _toggleFullscreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: Colors.red),
              title: Text(l10n.print),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('window.print()');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.red),
              title: Text(l10n.copyUrl),
              onTap: () {
                Navigator.pop(context);
                Share.share(currentUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all, color: Colors.red),
              title: Text(l10n.clearCache),
              onTap: () {
                Navigator.pop(context);
                controller.clearCache();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.cacheCleared)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.screenshot, color: Colors.red),
              title: Text(l10n.screenshot),
              onTap: () {
                Navigator.pop(context);
                _takeScreenshot();
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate, color: Colors.red),
              title: Text(l10n.translate),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://translate.google.com/translate?sl=auto&tl=fr&u=$currentUrl'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.find_in_page, color: Colors.red),
              title: Text(l10n.searchInPage),
              onTap: () {
                Navigator.pop(context);
                _showSearchDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.desktop_windows, color: Colors.red),
              title: Text(l10n.desktopVersion),
              onTap: () {
                Navigator.pop(context);
                controller.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
                controller.reload();
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.red),
              title: Text(l10n.mobileVersion),
              onTap: () {
                Navigator.pop(context);
                controller.setUserAgent('Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36');
                controller.reload();
              },
            ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com')),
          ),
          IconButton(
            icon: Icon(favorites.contains(currentUrl) ? Icons.favorite : Icons.favorite_border),
            onPressed: _addToFavorites,
          ),


          IconButton(
            icon: Icon(canGoBack ? Icons.arrow_back : Icons.arrow_back, 
                      color: canGoBack ? Colors.white : Colors.white54),
            onPressed: canGoBack ? () => controller.goBack() : null,
          ),
          IconButton(
            icon: Icon(canGoForward ? Icons.arrow_forward : Icons.arrow_forward,
                      color: canGoForward ? Colors.white : Colors.white54),
            onPressed: canGoForward ? () => controller.goForward() : null,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
        ],
      ),

    );
  }
}