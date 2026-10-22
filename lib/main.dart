import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MultiLangApp());
}

class MultiLangApp extends StatefulWidget {
  const MultiLangApp({super.key});

  @override
  State<MultiLangApp> createState() => _MultiLangAppState();
}

class _MultiLangAppState extends State<MultiLangApp> {
  String selectedLang = 'Urdu';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayTube',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: HomeScreen(
        currentLang: selectedLang,
        onLangChanged: (newLang) {
          setState(() {
            selectedLang = newLang;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String currentLang;
  final Function(String) onLangChanged;

  const HomeScreen({
    super.key,
    required this.currentLang,
    required this.onLangChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final String _adminPassword = "1234";

  final Map<String, Map<String, String>> localizedText = {
    'English': {
      'shorts': 'Shorts',
      'movies': 'Movies',
      'dramas': 'Dramas',
      'upload': 'Upload',
      'search': 'Search videos...',
      'enter_pass': 'Enter Admin Password',
    },
    'Urdu': {
      'shorts': 'شارٹس',
      'movies': 'موویز',
      'dramas': 'ڈرامے',
      'upload': 'اپلوڈ',
      'search': 'ویڈیو تلاش کریں...',
      'enter_pass': 'ایڈمن پاسورڈ درج کریں',
    },
    'Arabic': {
      'shorts': 'قصيرة',
      'movies': 'أفلام',
      'dramas': 'دراما',
      'upload': 'تحميل',
      'search': 'ابحث عن مقاطع الفيديو...',
      'enter_pass': 'أدخل كلمة مرور المسؤول',
    },
    'Bengali': {
      'shorts': 'শর্টস',
      'movies': 'মুভি',
      'dramas': 'নাটক',
      'upload': 'আপলোড',
      'search': 'ভিডিও অনুসন্ধান করুন...',
      'enter_pass': 'অ্যাডমিন পাসওয়ার্ড লিখুন',
    },
  };

  void _showPasswordDialog() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            localizedText[widget.currentLang]!['enter_pass']!,
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: passController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "*****",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (passController.text == _adminPassword) {
                  Navigator.pop(context);
                  _openUploadPage();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Wrong Password!')),
                  );
                }
              },
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            )
          ],
        );
      },
    );
  }

  void _openUploadPage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: min,
            children: [
              const Text(
                'Upload Content',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {},
                child: const Text('Upload Short / Movie / Drama', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var txt = localizedText[widget.currentLang]!;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.play_circle_fill, color: Colors.red, size: 30),
            SizedBox(width: 8),
            Text('PlayTube', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: widget.currentLang,
            dropdownColor: Colors.grey[900],
            style: const TextStyle(color: Colors.white),
            items: ['English', 'Urdu', 'Arabic', 'Bengali'].map((String lang) {
              return DropdownMenuItem<String>(
                value: lang,
                child: Text(lang),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) widget.onLangChanged(val);
            },
          ),
          IconButton(
            icon: const Icon(Icons.lock, color: Colors.white),
            onPressed: _showPasswordDialog,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: txt['search'],
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${txt['shorts']} / ${txt['movies']} / ${txt['dramas']} List',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.bolt), label: txt['shorts']),
          BottomNavigationBarItem(icon: const Icon(Icons.movie), label: txt['movies']),
          BottomNavigationBarItem(icon: const Icon(Icons.tv), label: txt['dramas']),
        ],
      ),
    );
  }
}
