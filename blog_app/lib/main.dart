import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunisie Libertaire',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const BlogWebView(),
    );
  }
}

class BlogWebView extends StatefulWidget {
  const BlogWebView({super.key});

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
          controller.reload();
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

  void _shareCurrentPage() {
    Share.share('$pageTitle\n$currentUrl');
  }

  void _showFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Favoris'),
        content: favorites.isEmpty 
          ? const Text('Aucun favori')
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
                      const SnackBar(content: Text('Favori supprimé')),
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
            child: const Text('Fermer'),
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
    if (!favorites.contains(currentUrl)) {
      setState(() {
        favorites.add(currentUrl);
      });
      _saveFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajouté aux favoris')),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Capture d\'écran prise')),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchText = '';
        return AlertDialog(
          title: const Text('Rechercher dans la page'),
          content: TextField(
            onChanged: (value) => searchText = value,
            decoration: const InputDecoration(hintText: 'Tapez votre recherche...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.runJavaScript('window.find("$searchText")');
              },
              child: const Text('Rechercher'),
            ),
          ],
        );
      },
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Colors.red),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.red),
              title: const Text('Actualiser'),
              onTap: () {
                Navigator.pop(context);
                controller.reload();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.red),
              title: const Text('Partager'),
              onTap: () {
                Navigator.pop(context);
                _shareCurrentPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.red),
              title: const Text('Rechercher sur le site'),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com/?s='));
              },
            ),
            ListTile(
              leading: const Icon(Icons.rss_feed, color: Colors.red),
              title: const Text('Flux RSS'),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://tunisielibertaire.wordpress.com/feed/'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.red),
              title: const Text('Favoris'),
              onTap: () {
                Navigator.pop(context);
                _showFavorites();
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_increase, color: Colors.red),
              title: const Text('Zoom +'),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.zoom = "1.2"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_decrease, color: Colors.red),
              title: const Text('Zoom -'),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.zoom = "0.8"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.red),
              title: const Text('Mode sombre'),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.filter = "invert(1) hue-rotate(180deg)"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode, color: Colors.red),
              title: const Text('Mode clair'),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('document.body.style.filter = "none"');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fullscreen, color: Colors.red),
              title: const Text('Plein écran'),
              onTap: () {
                Navigator.pop(context);
                _toggleFullscreen();
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: Colors.red),
              title: const Text('Imprimer'),
              onTap: () {
                Navigator.pop(context);
                controller.runJavaScript('window.print()');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.red),
              title: const Text('Copier URL'),
              onTap: () {
                Navigator.pop(context);
                Share.share(currentUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all, color: Colors.red),
              title: const Text('Vider cache'),
              onTap: () {
                Navigator.pop(context);
                controller.clearCache();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache vidé')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.screenshot, color: Colors.red),
              title: const Text('Capture d\'écran'),
              onTap: () {
                Navigator.pop(context);
                _takeScreenshot();
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate, color: Colors.red),
              title: const Text('Traduire'),
              onTap: () {
                Navigator.pop(context);
                controller.loadRequest(Uri.parse('https://translate.google.com/translate?sl=auto&tl=fr&u=$currentUrl'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.find_in_page, color: Colors.red),
              title: const Text('Rechercher dans la page'),
              onTap: () {
                Navigator.pop(context);
                _showSearchDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.desktop_windows, color: Colors.red),
              title: const Text('Version bureau'),
              onTap: () {
                Navigator.pop(context);
                controller.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
                controller.reload();
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.red),
              title: const Text('Version mobile'),
              onTap: () {
                Navigator.pop(context);
                controller.setUserAgent('Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36');
                controller.reload();
              },
            ),
          ],
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