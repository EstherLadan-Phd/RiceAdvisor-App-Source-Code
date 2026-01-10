import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/symptom_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/smart_advisor_screen.dart';
import 'screens/RiceCareTutorScreen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/learning_modules_screen.dart';
import 'screens/e_learning_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

// Custom fallback delegates for unsupported languages
class FallbackMaterialLocalizationsDelegate 
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) => 
      DefaultMaterialLocalizations.load(const Locale('en'));

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) => 
      DefaultCupertinoLocalizations.load(const Locale('en'));

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.microphone.request();
  // Load saved locale or default to English
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('languageCode') ?? 'en';
  final savedLocale = Locale(savedLocaleCode);
  
  runApp(MyApp(initialLocale: savedLocale));
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;
  
  const MyApp({super.key, required this.initialLocale});

  static void setLocale(BuildContext context, Locale newLocale) async {
    final state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
      
      // Update app state
      state.setLocale(newLocale);
    }
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale newLocale) {
    if (!AppLocalizations.supportedLocales.contains(newLocale)) {
      debugPrint('Locale $newLocale is not supported');
      return;
    }
    
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RiceAdvisor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ha'), // Hausa
        Locale('ig'), // Igbo
        Locale('yo'), // Yoruba
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationsDelegate(),
        FallbackCupertinoLocalizationsDelegate(),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Try to match device locale
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // Fallback to English
        return const Locale('en');
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/auth_screen': (context) => const AuthScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/symptom_screen': (context) => const SymptomScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/smart_advisor': (context) => const SmartAdvisorScreen(),
        '/tutor': (context) => RiceCareTutorScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/learning_modules': (context) => const LearningModulesScreen(),
        '/e_learning': (context) => const ELearningScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }
}

dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          localizations?.dashboardTitle ?? 'RiceAdvisor Dashboard',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      drawer: _buildDrawer(localizations),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slider Section
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: 320,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                      ),
                      items: _buildSliderItems(localizations).map((item) {
                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(colors: [Color.fromARGB(255, 1, 120, 5), Color.fromARGB(255, 2, 186, 42)]),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: (item['content'] as List<String>).map((point) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                          const SizedBox(width: 10),
                                          Expanded(child: Text(point, style: const TextStyle(color: Colors.white, fontSize: 16))),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Important Tips Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localizations?.importantTipsTitle ?? 'Other Important Tips',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildImportantTips(localizations).map((tip) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle, size: 20, color: Colors.green),
                                const SizedBox(width: 10),
                                Expanded(child: Text(tip, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Button at the Bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.local_hospital,
                    label: localizations?.diagnose ?? 'Diagnose',
                    route: '/symptom_screen'
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    context,
                    icon: Icons.auto_awesome,
                    label: localizations?.smartAdvisor ?? 'Smart Advisor',
                    route: '/smart_advisor'
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    context,
                    icon: Icons.menu_book,
                    label: localizations?.riceAdvisorTutor ?? 'RiceAdvisor Tutor',
                    route: '/tutor'
                  ),
                  const SizedBox(width: 10),
                    _buildActionButton(
                    context,
                    icon: Icons.video_library,
                    label: localizations?.learningModules ?? 'Learning Videos',
                    route: '/learning_modules'
                  ),
                  const SizedBox(width: 10),
                    _buildActionButton(
                    context,
                    icon: Icons.menu_book,
                    label: localizations?.learningModules ?? 'E Learning',
                    route: '/e_learning'
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    context,
                    icon: Icons.chat,
                    label: localizations?.chatbot ?? 'Chatbot',
                    route: '/chatbot'
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AppLocalizations? localizations) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(
              localizations?.navigationMenu ?? 'Navigation Menu',
              style: const TextStyle(color: Colors.white, fontSize: 22)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.green),
            title: Text(localizations?.dashboard ?? 'Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.green),
            title: Text(localizations?.diagnose ?? 'Diagnose'),
            onTap: () {
              Navigator.pushNamed(context, '/symptom_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.green),
            title: Text(localizations?.smartAdvisor ?? 'Smart Advisor'),
            onTap: () {
              Navigator.pushNamed(context, '/smart_advisor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.riceAdvisorTutor ?? 'RiceAdvisor Tutor'),
            onTap: () {
              Navigator.pushNamed(context, '/tutor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library, color: Colors.green),
            title: Text(localizations?.learningModules ?? 'Learning Videos'),
            onTap: () {
              Navigator.pushNamed(context, '/learning_modules');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.elearningModules ?? 'E Learning'),
            onTap: () {
              Navigator.pushNamed(context, '/e_learning');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: Text(localizations?.chatbot ?? 'Chatbot'),
            onTap: () {
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
           const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(localizations?.exit ?? 'Exit'),
            onTap: () {
              exit(0); // Exit the app
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required String route}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon, color: const Color.fromARGB(255, 195, 252, 195)),
      label: Text(label, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    );
  }

  List<Map<String, dynamic>> _buildSliderItems(AppLocalizations? localizations) {
    return [
      {
        'title': localizations?.ipmTitle ?? 'Integrated Pest Management (IPM)',
        'content': [
          localizations?.ipmPoint1 ?? 'Biological Control: Utilize natural predators or parasites to manage pest populations.',
          localizations?.ipmPoint2 ?? 'Cultural Practices: Implement crop rotation and intercropping to disrupt pest life cycles.',
          localizations?.ipmPoint3 ?? 'Resistant Varieties: Plant rice varieties resistant to common pests and diseases.'
        ]
      },
      {
        'title': localizations?.weedManagementTitle ?? 'Weed Management',
        'content': [
          localizations?.weedPoint1 ?? 'Herbicide Application: Use appropriate herbicides to control weed growth.',
          localizations?.weedPoint2 ?? 'Manual Weeding: Regular hand weeding can be effective, especially in small-scale farms.'
        ]
      },
      {
        'title': localizations?.diseasePreventionTitle ?? 'Disease Prevention',
        'content': [
          localizations?.diseasePoint1 ?? 'Seed Selection: Choose high-quality, disease-free seeds with at least 80% viability.',
          localizations?.diseasePoint2 ?? 'Field Hygiene: Remove and destroy crop residues that may harbor pathogens.',
          localizations?.diseasePoint3 ?? 'Fungicide Use: Apply recommended fungicides when necessary, following proper guidelines.'
        ]
      },
      {
        'title': localizations?.birdControlTitle ?? 'Bird Control',
        'content': [
          localizations?.birdPoint1 ?? 'Physical Barriers: Install bird nets to prevent birds from accessing the fields.',
          localizations?.birdPoint2 ?? 'Scare Tactics: Use visual deterrents like scarecrows or reflective materials to discourage birds.'
        ]
      }
    ];
  }

  List<String> _buildImportantTips(AppLocalizations? localizations) {
    return [
      localizations?.tip1 ?? 'Use disease and insect-free pure seeds',
      localizations?.tip2 ?? 'Pay more attention to nursery protection',
      localizations?.tip3 ?? 'Ensure timely planting and crop protection during the early growth stage',
      localizations?.tip4 ?? 'Maintain field sanitation and adopt clean cultivation',
      localizations?.tip5 ?? 'Provide alleys (30 cm width) every 3 meters in the main field',
      localizations?.tip6 ?? 'Apply nitrogen fertilizer in splits (3-4 times or adjust when conditions warrant)',
      localizations?.tip7 ?? 'Monitor the incidence of pests and diseases through survey and surveillance programme',
      localizations?.tip8 ?? 'Exploit biological control by encouraging natural enemies through need-based pesticide application.'
    ];
  }
}

Feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void submitFeedback() {
    String feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      // Here, you can store the feedback in a database or handle it as needed
      print("Feedback submitted: $feedback");

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.feedbackThankYou ?? "Thank you for your feedback!")),
      );

      // Clear the input field
      _feedbackController.clear();
    } else {
      // Show an error message if the field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.feedbackEmptyError ?? "Please enter your feedback")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(localizations?.feedbackTitle ?? "Feedback & Bug Report"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      drawer: _buildDrawer(localizations),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations?.feedbackHeader ?? "We'd love to hear your feedback!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              localizations?.feedbackSubheader ?? "Let us know about any issues or improvements you'd like to see.",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: localizations?.feedbackHint ?? "Enter your feedback",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  localizations?.submitFeedbackButton ?? "Submit Feedback",
                  style: const TextStyle(color: Colors.white, fontSize: 16)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(AppLocalizations? localizations) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(
              localizations?.navigationMenu ?? 'Navigation Menu',
              style: const TextStyle(color: Colors.white, fontSize: 22)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.green),
            title: Text(localizations?.dashboard ?? 'Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.green),
            title: Text(localizations?.diagnose ?? 'Diagnose'),
            onTap: () {
              Navigator.pushNamed(context, '/symptom_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.green),
            title: Text(localizations?.smartAdvisor ?? 'Smart Advisor'),
            onTap: () {
              Navigator.pushNamed(context, '/smart_advisor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.riceAdvisorTutor ?? 'RiceAdvisor Tutor'),
            onTap: () {
              Navigator.pushNamed(context, '/tutor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library, color: Colors.green),
            title: Text(localizations?.learningModules ?? 'Learning Videos'),
            onTap: () {
              Navigator.pushNamed(context, '/learning_modules');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.elearningModules ?? 'E Learning'),
            onTap: () {
              Navigator.pushNamed(context, '/e_learning');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: Text(localizations?.chatbot ?? 'Chatbot'),
            onTap: () {
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(localizations?.exit ?? 'Exit'),
            onTap: () {
              exit(0); // Exit the app
            },
          ),
        ],
      ),
    );
  }
}

learning_module.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LearningModulesScreen extends StatefulWidget {
  const LearningModulesScreen({super.key});

  @override
  State<LearningModulesScreen> createState() => _LearningModulesScreenState();
}

class _LearningModulesScreenState extends State<LearningModulesScreen> {
  final List<Map<String, dynamic>> _videoModules = [];
  late YoutubePlayerController _controller;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoModules();
    _initializeController();
  }

  void _initializeVideoModules() {
    _videoModules.addAll([
      {
        'title': 'Rice Blast Disease Management',
        'description': 'Learn identification and control of rice blast disease',
        'youtubeId': 'JJxLv0Kx5do',
        'duration': '5:27',
        'thumbnail': 'https://img.youtube.com/vi/JJxLv0Kx5do/mqdefault.jpg'
      },
      {
        'title': 'SRI Planting Method',
        'description': 'System of Rice Intensification techniques',
        'youtubeId': 'KrBcwdAcYAc',
        'duration': '2:58',
        'thumbnail': 'https://img.youtube.com/vi/KrBcwdAcYAc/mqdefault.jpg'
      },
      {
        'title': 'Integrated Pest Management',
        'description': 'Organic pest control for rice fields',
        'youtubeId': 'm24qTP4lHt0',
        'duration': '15:43',
        'thumbnail': 'https://img.youtube.com/vi/m24qTP4lHt0/mqdefault.jpg'
      },
      {
        'title': 'Water Management',
        'description': 'Efficient irrigation techniques for rice',
        'youtubeId': 'gU9Rr8icQEE',
        'duration': '6:00',
        'thumbnail': 'https://img.youtube.com/vi/gU9Rr8icQEE/mqdefault.jpg'
      },
      {
        'title': 'Harvesting Techniques',
        'description': 'Best practices for rice harvesting',
        'youtubeId': 'Wm34vvV4T1o',
        'duration': '9:16',
        'thumbnail': 'https://img.youtube.com/vi/Wm34vvV4T1o/mqdefault.jpg'
      },
    ]);
  }

  void _initializeController() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoModules[_currentIndex]['youtubeId'],
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: true,
        enableCaption: false,
        strictRelatedVideos: true,
      ),
    );
    _isLoading = false;
  }

  Future<void> _playVideo(int index) async {
    if (_currentIndex == index || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await _controller.loadVideoById(
        videoId: _videoModules[index]['youtubeId'],
      );
      setState(() {
        _currentIndex = index;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load video: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(localizations?.learningModules ?? 'Learning Modules'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _isLoading
                  ? Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : player,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _videoModules[_currentIndex]['title'],
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 16, color: theme.disabledColor),
                      const SizedBox(width: 4),
                      Text(
                        _videoModules[_currentIndex]['duration'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _videoModules[_currentIndex]['description'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _videoModules.length,
                itemBuilder: (context, index) {
                  final video = _videoModules[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _playVideo(index),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                video['thumbnail'],
                                width: 120,
                                height: 80,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    width: 120,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: progress.expectedTotalBytes !=
                                                null
                                            ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.videocam_off),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['title'],
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.timer_outlined,
                                          size: 14,
                                          color: theme.disabledColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        video['duration'],
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.disabledColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (_currentIndex == index)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(Icons.play_arrow_rounded,
                                    color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

rice_advisor.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'TopicDetailScreen.dart';
import 'dart:io';

class TutorContent {
  final AppLocalizations localizations;

  TutorContent(this.localizations);

  List<Map<String, String>> get topics {
    return [
      {
        'title': localizations.siteSelectionTitle,
        'shortDetails': localizations.siteSelectionShort,
        'fullDescription': localizations.siteSelectionFull,
        'image': 'assets/images/site_selection.jpg',
      },
      {
        'title': localizations.seedSelectionTitle,
        'shortDetails': localizations.seedSelectionShort,
        'fullDescription': localizations.seedSelectionFull,
        'image': 'assets/images/seed_selection.jpg',
      },
      {
        'title': localizations.lowlandVarietiesTitle,
        'shortDetails': localizations.lowlandVarietiesShort,
        'fullDescription': localizations.lowlandVarietiesFull,
        'image': 'assets/images/lowland_rice.jpg',
      },
      {
        'title': localizations.uplandVarietiesTitle,
        'shortDetails': localizations.uplandVarietiesShort,
        'fullDescription': localizations.uplandVarietiesFull,
        'image': 'assets/images/upland_rice.jpg',
      },
      {
        'title': localizations.soilPreparationTitle,
        'shortDetails': localizations.soilPreparationShort,
        'fullDescription': localizations.soilPreparationFull,
        'image': 'assets/images/soil_preparation.jpg',
      },
      {
        'title': localizations.riceVarietiesTitle,
        'shortDetails': localizations.riceVarietiesShort,
        'fullDescription': localizations.riceVarietiesFull,
        'image': 'assets/images/rice_varieties.jpg',
      },
      {
        'title': localizations.waterManagementTitle,
        'shortDetails': localizations.waterManagementShort,
        'fullDescription': localizations.waterManagementFull,
        'image': 'assets/images/water_management.jpg',
      },
      {
        'title': localizations.fertilizerApplicationTitle,
        'shortDetails': localizations.fertilizerApplicationShort,
        'fullDescription': localizations.fertilizerApplicationFull,
        'image': 'assets/images/fertilizer_application.jpg',
      },
      {
        'title': localizations.weedControlTitle,
        'shortDetails': localizations.weedControlShort,
        'fullDescription': localizations.weedControlFull,
        'image': 'assets/images/weed_control.jpg',
      },
      {
        'title': localizations.pestDiseasePreventionTitle,
        'shortDetails': localizations.pestDiseasePreventionShort,
        'fullDescription': localizations.pestDiseasePreventionFull,
        'image': 'assets/images/pest_disease_prevention.jpg',
      },
      {
        'title': localizations.harvestPostHarvestTitle,
        'shortDetails': localizations.harvestPostHarvestShort,
        'fullDescription': localizations.harvestPostHarvestFull,
        'image': 'assets/images/harvesting_postharvest.jpg',
      },
    ];
  }
}

class RiceCareTutorScreen extends StatefulWidget {
  const RiceCareTutorScreen({super.key});

  @override
  State<RiceCareTutorScreen> createState() => _RiceCareTutorScreenState();
}

class _RiceCareTutorScreenState extends State<RiceCareTutorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Map<String, String>> topics;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      topics = TutorContent(localizations).topics;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(localizations?.tutorTitle ?? 'RiceAdvisor Tutor'),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      drawer: _buildDrawer(localizations),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              leading: Image.asset(
                topics[index]['image']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                topics[index]['title']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  topics[index]['shortDetails']!,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.green,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => TopicDetailScreen(
                          title: topics[index]['title']!,
                          fullDescription: topics[index]['fullDescription']!,
                          image: topics[index]['image']!,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(AppLocalizations? localizations) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(
              localizations?.navigationMenu ?? 'Navigation Menu',
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.green),
            title: Text(localizations?.dashboard ?? 'Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.green),
            title: Text(localizations?.diagnose ?? 'Diagnose'),
            onTap: () {
              Navigator.pushNamed(context, '/symptom_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.green),
            title: Text(localizations?.smartAdvisor ?? 'Smart Advisor'),
            onTap: () {
              Navigator.pushNamed(context, '/smart_advisor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.riceAdvisorTutor ?? 'RiceAdvisor Tutor'),
            onTap: () {
              Navigator.pushNamed(context, '/tutor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library, color: Colors.green),
            title: Text(localizations?.learningModules ?? 'Learning Videos'),
            onTap: () {
              Navigator.pushNamed(context, '/learning_modules');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.elearningModules ?? 'E Learning'),
            onTap: () {
              Navigator.pushNamed(context, '/e_learning');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: Text(localizations?.chatbot ?? 'Chatbot'),
            onTap: () {
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(localizations?.exit ?? 'Exit'),
            onTap: () {
              exit(0); // Exit the app
            },
          ),
        ],
      ),
    );
  }
}

Symptom_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'result_screen.dart';
import 'dart:io';

class LoadingScreen extends StatefulWidget {
  final String disease;
  final String recommendation;

  const LoadingScreen({
    super.key,
    required this.disease,
    required this.recommendation,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              localizations?.analyzing ?? "Analyzing...",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FlutterTts flutterTts;
  late stt.SpeechToText speechToText;
  bool isListening = false;
  String recognizedText = '';
  bool speechAvailable = false;
  Map<String, bool> selectedSymptoms = {};
  String? detectedDisease;
  String? recommendation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    initTts();
    initSpeech();
  }

  Future<void> initTts() async {
  flutterTts = FlutterTts();
  await flutterTts.awaitSpeakCompletion(true);
  
  // Set initial language based on device locale
  final locale = Localizations.localeOf(context);
  String langCode = 'en-US';
  if (locale.languageCode == 'ha') langCode = 'ha-NG';
  if (locale.languageCode == 'yo') langCode = 'yo-NG';
  if (locale.languageCode == 'ig') langCode = 'ig-NG';
  
  await flutterTts.setLanguage(langCode);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0);
  
  if (Platform.isAndroid) {
    await flutterTts.setEngine("com.google.android.tts");
  }
}

  Future<void> initSpeech() async {
    speechToText = stt.SpeechToText();
    bool hasPermission = await _checkMicrophonePermission();
    
    if (hasPermission) {
      speechAvailable = await speechToText.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (status == 'done' && isListening) {
            stopListening();
          }
        },
        onError: (error) {
          print('Speech error: $error');
          setState(() => isListening = false);
        },
      );
      setState(() {});
    }
  }

  Future<bool> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  Future<void> startListening() async {
  final localizations = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context);
  
  if (!speechAvailable) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations?.voiceFeatureUnavailable ?? "Voice feature unavailable on this device")),
    );
    return;
  }

  setState(() {
    recognizedText = '';
    isListening = true;
    _isProcessing = true;
  });

  try {
    await flutterTts.speak(localizations?.voicePrompt ?? 
        "Please describe the symptoms you're observing on your rice plants. For example, say: my rice has yellow spots on the leaves");
    await flutterTts.awaitSpeakCompletion(true);

    await Future.delayed(const Duration(milliseconds: 500));

    // Determine the appropriate locale for speech recognition
    String speechLocale = 'en-US'; // default
    if (locale.languageCode == 'ha') speechLocale = 'ha-NG';
    if (locale.languageCode == 'yo') speechLocale = 'yo-NG';
    if (locale.languageCode == 'ig') speechLocale = 'ig-NG';

    final result = await speechToText.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          setState(() => recognizedText = result.recognizedWords);
        }
        if (result.finalResult) {
          processVoiceInput(recognizedText);
        }
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: speechLocale, // Use the determined locale
      cancelOnError: true,
      listenMode: stt.ListenMode.dictation,
    );

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations?.speechRecognitionFailed ?? "Failed to start speech recognition")),
      );
    }
  } catch (e) {
    print("Speech recognition error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${localizations?.errorShowingResults ?? "Error"}: ${e.toString()}")),
    );
  } finally {
    setState(() => _isProcessing = false);
  }
}

  Future<void> stopListening() async {
    try {
      await speechToText.stop();
      if (recognizedText.isNotEmpty) {
        processVoiceInput(recognizedText);
      }
    } catch (e) {
      print("Error stopping speech recognition: $e");
    } finally {
      if (mounted) {
        setState(() => isListening = false);
      }
    }
  }

  Future<void> speak(String text) async {
    final locale = Localizations.localeOf(context);
    String langCode = 'en-US';
    if (locale.languageCode == 'ha') langCode = 'ha-NG';
    if (locale.languageCode == 'yo') langCode = 'yo-NG';
    if (locale.languageCode == 'ig') langCode = 'ig-NG';

    await flutterTts.setLanguage(langCode);
    await flutterTts.speak(text);
  }

  void processVoiceInput(String input) {
    final localizations = AppLocalizations.of(context);
    
    try {
      if (input.isEmpty) {
        speak(localizations?.noInputReceived ?? "I didn't catch that. Please try again.");
        return;
      }

      final symptoms = getSymptoms(context);
      final lowerInput = input.toLowerCase();
      
      selectedSymptoms = Map.fromIterables(
        symptoms,
        List.filled(symptoms.length, false),
      );
      
      bool foundMatch = false;
      for (var symptom in symptoms) {
        final lowerSymptom = symptom.toLowerCase();
        final words = lowerSymptom.split(' ');
        
        if (lowerInput.contains(lowerSymptom) ||
            words.any((word) => word.length > 3 && lowerInput.contains(word))) {
          selectedSymptoms[symptom] = true;
          foundMatch = true;
        }
      }
      
      setState(() {});
      
      if (foundMatch) {
        speak(localizations?.symptomsFound ?? "I found matching symptoms. Analyzing now...");
        Future.delayed(const Duration(seconds: 2), () {
          analyzeResult(context);
        });
      } else {
        speak(localizations?.noSymptomsIdentified ?? "I couldn't identify specific symptoms. Please try again or select manually.");
      }
    } catch (e) {
      print("Voice processing error: $e");
      speak(localizations?.voiceProcessingError ?? "There was an error processing your voice input. Please try again.");
    }
  }

  List<String> getSymptoms(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return [
      localizations?.symptom1 ?? "Green to gray water-soaked spots on leaf sheaths",
      localizations?.symptom2 ?? "Lesions covering leaf sheaths and stems",
      localizations?.symptom3 ?? "Drying of leaves from tip and curling, leaving midrib intact",
      localizations?.symptom4 ?? "The rice clump as a whole withers",
      localizations?.symptom5 ?? "Gray to yellow spots on the leaf blades all over until they dry out and die",
      localizations?.symptom6 ?? "Leaves have tiny beads of yellow colored bacterial exudate on the surface of the streaks",
      localizations?.symptom7 ?? "Leaves with undulated yellowish white or golden yellow marginal necrosis",
      localizations?.symptom8 ?? "White to green or gray diamond-shaped lesions with dark green borders",
      localizations?.symptom9 ?? "Rice plant stems are fragile and fall easily",
      localizations?.symptom10 ?? "Yellow-green oblong to linear spots on the base of the youngest leaves",
      localizations?.symptom11 ?? "Leaf spots often cover the surface of the leaves, causing the leaves to wilt",
      localizations?.symptom12 ?? "Water-soaked, linear lesions between leaf veins",
    ];
  }

  Map<String, String> getDiseaseMapping(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return {
      localizations?.diseaseBlast ?? "Blast": localizations?.blastRecommendation ?? "Apply fungicides like tricyclazole and use resistant rice varieties.",
      localizations?.diseaseYellowMottleVirus ?? "Yellow Mottle Virus": localizations?.yellowMottleRecommendation ?? "Use virus-free seedlings and control insect vectors.",
      localizations?.diseaseBacterialLeafStreak ?? "Bacterial Leaf Streak": localizations?.bacterialLeafStreakRecommendation ?? "Apply copper-based bactericides and use resistant varieties.",
      localizations?.diseaseBacterialLeafBlight ?? "Bacterial Leaf Blight": localizations?.bacterialLeafBlightRecommendation ?? "Avoid excessive nitrogen fertilizers and use resistant varieties."
    };
  }

  void analyzeResult(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    
    try {
      final symptoms = getSymptoms(context);
      final diseaseMapping = getDiseaseMapping(context);

      List<String> selected = selectedSymptoms.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      if (selected.isNotEmpty) {
        if (selected.contains(symptoms[0]) || selected.contains(symptoms[1])) {
          detectedDisease = diseaseMapping.keys.firstWhere(
            (key) => key.contains(localizations?.diseaseBlast ?? "Blast"),
            orElse: () => diseaseMapping.keys.first
          );
        } else if (selected.contains(symptoms[2])) {
          detectedDisease = diseaseMapping.keys.firstWhere(
            (key) => key.contains(localizations?.diseaseYellowMottleVirus ?? "Yellow Mottle Virus"),
            orElse: () => diseaseMapping.keys.elementAt(1)
          );
        } else if (selected.contains(symptoms[6])) {
          detectedDisease = diseaseMapping.keys.firstWhere(
            (key) => key.contains(localizations?.diseaseBacterialLeafStreak ?? "Bacterial Leaf Streak"),
            orElse: () => diseaseMapping.keys.elementAt(2)
          );
        } else {
          detectedDisease = diseaseMapping.keys.firstWhere(
            (key) => key.contains(localizations?.diseaseBacterialLeafBlight ?? "Bacterial Leaf Blight"),
            orElse: () => diseaseMapping.keys.last
          );
        }
        recommendation = diseaseMapping[detectedDisease];
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            disease: detectedDisease ?? localizations?.unknownDisease ?? "Unknown Disease",
            recommendation: recommendation ?? localizations?.consultExpert ?? "Consult an expert",
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            disease: detectedDisease ?? localizations?.unknownDisease ?? "Unknown Disease",
            recommendation: recommendation ?? localizations?.consultExpert ?? "Consult an expert",
          ),
        ),
      );
    } catch (e) {
      print("Navigation error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations?.errorShowingResults ?? "Error showing results")),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    flutterTts.stop();
    speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final symptoms = getSymptoms(context);
    
    if (selectedSymptoms.isEmpty) {
      for (var symptom in symptoms) {
        selectedSymptoms[symptom] = false;
      }
    }
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(localizations?.symptomChecker ?? "Symptom Checker", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Text(
                localizations?.navigationMenu ?? 'Navigation Menu', 
                style: const TextStyle(color: Colors.white, fontSize: 22)
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.green),
              title: Text(localizations?.dashboard ?? 'Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.green),
              title: Text(localizations?.diagnose ?? 'Diagnose'),
              onTap: () {
                Navigator.pushNamed(context, '/symptom_screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: Colors.green),
              title: Text(localizations?.smartAdvisor ?? 'Smart Advisor'),
              onTap: () {
                Navigator.pushNamed(context, '/smart_advisor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.green),
              title: Text(localizations?.riceAdvisorTutor ?? 'RiceAdvisor Tutor'),
              onTap: () {
                Navigator.pushNamed(context, '/tutor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.green),
              title: Text(localizations?.learningModules ?? 'Learning Videos'),
              onTap: () {
                Navigator.pushNamed(context, '/learning_modules');
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.green),
              title: Text(localizations?.elearningModules ?? 'E Learning'),
              onTap: () {
                Navigator.pushNamed(context, '/e_learning');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: Text(localizations?.chatbot ?? 'Chatbot'),
              onTap: () {
                Navigator.pushNamed(context, '/chatbot');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(localizations?.exit ?? 'Exit'),
              onTap: () {
                exit(0);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations?.selectSymptoms ?? "Select symptoms",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (!speechAvailable)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  localizations?.voiceFeatureUnavailable ?? "Voice feature unavailable on this device",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (recognizedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  localizations?.youSaid != null 
                      ? localizations!.youSaid(recognizedText)
                      : "You said: $recognizedText",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            if (isListening) ...[
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      localizations?.listeningPrompt ?? "Listening... Speak now", 
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  String symptom = symptoms[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSymptoms[symptom] = !(selectedSymptoms[symptom] ?? false);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedSymptoms[symptom] == true ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedSymptoms[symptom] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                selectedSymptoms[symptom] = value ?? false;
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              symptom,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedSymptoms[symptom] == true ? Colors.white : Colors.green[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => analyzeResult(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        localizations?.analyzeSymptoms ?? "Analyze Symptoms", 
                        style: const TextStyle(fontSize: 16, color: Colors.white)
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isListening) {
            await stopListening();
          } else {
            await startListening();
          }
        },
        backgroundColor: isListening ? Colors.red : Colors.green,
        child: Icon(
          isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}

smart_advisor.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SmartAdvisorScreen extends StatefulWidget {
  const SmartAdvisorScreen({super.key});

  @override
  State<SmartAdvisorScreen> createState() => _SmartAdvisorScreenState();
}

class _SmartAdvisorScreenState extends State<SmartAdvisorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String statusMessage = "";
  String weatherInfo = "";
  String riskAlert = "";
  String recommendation = "";
  bool isLoading = true;
  bool _hasRequirements = false;
  bool _initialCheckDone = false;
  DateTime? lastUpdated;
  String? errorMessage;
  late FlutterTts flutterTts;
  bool _isSpeaking = false;

  final String weatherApiKey = "0cd79d73428244a08f6233016251704";

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
    
    // Set language based on device locale
    final locale = Localizations.localeOf(context);
    String langCode = 'en-US';
    if (locale.languageCode == 'ha') langCode = 'ha-NG';
    if (locale.languageCode == 'yo') langCode = 'yo-NG';
    if (locale.languageCode == 'ig') langCode = 'ig-NG';
    
    await flutterTts.setLanguage(langCode);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    if (Platform.isAndroid) {
      await flutterTts.setEngine("com.google.android.tts");
    }

    flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });

    flutterTts.setErrorHandler((msg) {
      setState(() => _isSpeaking = false);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialCheckDone) {
      _initialCheckDone = true;
      _checkRequirements();
    }
  }

  Future<void> _speakResults() async {
    final localizations = AppLocalizations.of(context);
    final weatherMessage = weatherInfo.replaceAll(RegExp(r'[:]'), ': ');
    final riskMessage = riskAlert.replaceAll('•', '');
    final recommendationMessage = recommendation.replaceAll('•', '');
    
    await flutterTts.speak(
      '${localizations?.weatherInformation ?? "Weather Information"}. $weatherMessage. '
      '${localizations?.agriculturalRiskAlerts ?? "Agricultural Risk Alerts"}. $riskMessage. '
      '${localizations?.diseasePrediction ?? "Disease Prediction"}. $recommendationMessage'
    );
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    setState(() => _isSpeaking = false);
  }

  Future<void> _checkRequirements() async {
    if (!mounted) return;
    
    final localizations = AppLocalizations.of(context);
    
    setState(() {
      isLoading = true;
      statusMessage = localizations?.checkingRequirements ?? "Checking requirements...";
      errorMessage = null;
    });

    try {
      // Check internet connection
      final hasInternet = await _checkInternetConnection();
      if (!hasInternet) {
        throw localizations?.internetRequired ?? "Internet connection required. Please enable mobile data/WiFi.";
      }

      // Check location services
      final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        throw localizations?.locationServicesDisabled ?? "Location services are disabled. Please enable GPS.";
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw localizations?.locationPermissionDenied ?? "Location permission denied. Please enable in settings.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw localizations?.locationPermissionPermanentlyDenied ?? "Location permissions permanently denied. Please enable in app settings.";
      }

      setState(() {
        _hasRequirements = true;
      });
      await fetchWeatherData();
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage(e.toString());
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    
    setState(() {
      errorMessage = message;
      statusMessage = message;
      isLoading = false;
      _hasRequirements = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: AppLocalizations.of(context)?.retry ?? 'RETRY',
          textColor: Colors.white,
          onPressed: _checkRequirements,
        ),
      ),
    );
  }

  Future<void> fetchWeatherData() async {
    if (!mounted || !_hasRequirements) return;
    final localizations = AppLocalizations.of(context);

    setState(() {
      isLoading = true;
      statusMessage = localizations?.detectingLocation ?? "📍 Detecting your location...";
      errorMessage = null;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        statusMessage = localizations?.fetchingWeatherData ?? "🌦 Fetching weather data...";
      });

      final apiUrl = "http://api.weatherapi.com/v1/current.json?key=$weatherApiKey&q=${position.latitude},${position.longitude}&aqi=no";
      final response = await http.get(Uri.parse(apiUrl));

      if (!mounted) return;
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final current = data['current'];
        final location = data['location'];
        
        final temperature = current['temp_c'];
        final humidity = current['humidity'];
        final condition = current['condition']['text'];
        final windSpeed = current['wind_kph'];
        final precipitation = current['precip_mm'];
        final cloudCover = current['cloud'];
        final feelsLike = current['feelslike_c'];
        final lastUpdatedEpoch = current['last_updated_epoch'];
        
        if (!mounted) return;
        setState(() {
          lastUpdated = DateTime.fromMillisecondsSinceEpoch(lastUpdatedEpoch * 1000);
          
          weatherInfo = """
📍 ${location['name']}, ${location['region']}, ${location['country']}
🕒 ${localizations?.lastUpdated ?? "Last Updated"}: ${DateFormat('MMM dd, hh:mm a').format(lastUpdated!)}
🌡 ${localizations?.temperature ?? "Temperature"}: $temperature°C (${localizations?.feelsLike ?? "Feels like"} $feelsLike°C)
💧 ${localizations?.humidity ?? "Humidity"}: $humidity%
🌬 ${localizations?.windSpeed ?? "Wind"}: $windSpeed ${localizations?.kmh ?? "km/h"}
🌧 ${localizations?.precipitation ?? "Precipitation"}: $precipitation ${localizations?.mm ?? "mm"}
☁ ${localizations?.cloudCover ?? "Cloud Cover"}: $cloudCover%
🌤 ${localizations?.condition ?? "Condition"}: $condition
""";

          statusMessage = localizations?.weatherDataRetrieved ?? "✅ Weather data retrieved!";
          isLoading = false;
          analyzeRisk(temperature, humidity, condition, windSpeed, precipitation);
          predictDiseases(temperature, humidity, condition, precipitation);
        });
      } else {
        final errorData = jsonDecode(response.body);
        final errorMsg = errorData['error']['message'] ?? localizations?.unknownError ?? 'Unknown error';
        throw Exception("API Error: $errorMsg (Code: ${response.statusCode})");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "${localizations?.failedToLoadWeatherData ?? "⚠️ Failed to load weather data"}: ${e.toString().replaceAll('Exception: ', '')}";
        isLoading = false;
      });
    }
  }

  void analyzeRisk(double temperature, int humidity, String condition, double windSpeed, double precipitation) {
    final localizations = AppLocalizations.of(context);
    final warnings = <String>[];

    // Temperature risks
    if (temperature > 35) {
      warnings.add(localizations?.extremeHeatRisk ?? "🔥 Extreme Heat: May cause heat stress in crops");
    } else if (temperature > 30) warnings.add(localizations?.highTempRisk ?? "🌡 High Temperature: Monitor for heat stress");
    else if (temperature < 10) warnings.add(localizations?.coldStressRisk ?? "❄️ Cold Stress: Risk to young seedlings");
    else if (temperature < 15) warnings.add(localizations?.coolTempRisk ?? "☁ Cool Temperatures: May slow plant growth");

    // Humidity risks
    if (humidity > 85) {
      warnings.add(localizations?.highHumidityRisk ?? "💦 High Humidity: Increased fungal disease risk");
    } else if (humidity < 40) warnings.add(localizations?.lowHumidityRisk ?? "🌵 Low Humidity: May require irrigation");

    // Precipitation risks
    if (precipitation > 20) {
      warnings.add(localizations?.heavyRainRisk ?? "🌧 Heavy Rain: Risk of waterlogging and erosion");
    } else if (precipitation > 5) warnings.add(localizations?.moderateRainRisk ?? "☔ Moderate Rain: Good for crops but monitor drainage");

    // Wind risks
    if (windSpeed > 30) {
      warnings.add(localizations?.strongWindRisk ?? "🌬 Strong Winds: May damage crops and spread pathogens");
    } else if (windSpeed > 15) warnings.add(localizations?.breezyConditionsRisk ?? "🍃 Breezy Conditions: Helps dry foliage but may spread spores");

    // Condition-based risks
    if (condition.toLowerCase().contains("rain")) {
      warnings.add(localizations?.wetConditionsRisk ?? "💧 Wet Conditions: Ideal for fungal diseases");
    }
    if (condition.toLowerCase().contains("storm")) {
      warnings.add(localizations?.stormWarningRisk ?? "⚡ Storm Warning: Potential crop damage");
    }

    setState(() {
      riskAlert = warnings.isEmpty 
          ? localizations?.noWeatherRisks ?? "✅ No significant weather risks detected"
          : warnings.map((w) => "• $w").join("\n");
    });
  }

  void predictDiseases(double temperature, int humidity, String condition, double precipitation) {
    final localizations = AppLocalizations.of(context);
    final diseases = <String>[];

    // High humidity/temperature diseases
    if (temperature > 28 && humidity > 80) {
      diseases.add(localizations?.bacterialLeafBlight ?? "🌿 Bacterial Leaf Blight (Xanthomonas oryzae)");
      diseases.add(localizations?.blastDisease ?? "🦠 Blast Disease (Pyricularia oryzae)");
      diseases.add(localizations?.sheathBlight ?? "🍄 Sheath Blight (Rhizoctonia solani)");
    }

    // Wet condition diseases
    if (precipitation > 10 || condition.toLowerCase().contains("rain")) {
      diseases.add(localizations?.rootRot ?? "🌊 Root Rot (Pythium spp.)");
      diseases.add(localizations?.brownSpot ?? "🍃 Brown Spot (Bipolaris oryzae)");
      diseases.add(localizations?.bacterialLeafStreak ?? "🟤 Bacterial Leaf Streak (Xanthomonas oryzae pv. oryzicola)");
    }

    // Cool/wet conditions
    if (temperature < 22 && humidity > 75) {
      diseases.add(localizations?.coldInducedChlorosis ?? "❄️ Cold-induced Chlorosis");
    }

    setState(() {
      recommendation = diseases.isEmpty
          ? localizations?.noDiseaseRisks ?? "✅ No major disease risks detected with current weather"
          : "${localizations?.potentialDiseaseRisks ?? "⚠️ Potential Disease Risks"}:\n${diseases.map((d) => "• $d").join("\n")}";
    });
  }

  Widget _buildSegment(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black54,
            ),
          ),
          const Divider(color: Colors.lightGreen, thickness: 2),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: _checkRequirements,
            child: Text(localizations?.tryAgain ?? 'TRY AGAIN', style: const TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    final localizations = AppLocalizations.of(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Colors.green.shade700),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        if (!_hasRequirements)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: _checkRequirements,
            child: Text(localizations?.checkRequirementsAgain ?? 'CHECK REQUIREMENTS AGAIN'),
          ),
      ],
    );
  }

  Widget _buildWeatherContent() {
    final localizations = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lastUpdated != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "${localizations?.lastUpdated ?? "Last Updated"}: ${DateFormat('MMM dd, hh:mm a').format(lastUpdated!)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  _buildSegment(localizations?.weatherInformation ?? "🌦 Weather Information", weatherInfo),
                  _buildSegment(localizations?.agriculturalRiskAlerts ?? "🚨 Agricultural Risk Alerts", riskAlert),
                  _buildSegment(localizations?.diseasePrediction ?? "🦠 Disease Prediction", recommendation),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            localizations?.recommendationsBasedOnWeather ?? "Recommendations are based on current weather conditions",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AppLocalizations? localizations) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(
              localizations?.navigationMenu ?? 'Navigation Menu', 
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.green),
            title: Text(localizations?.dashboard ?? 'Dashboard'),
            onTap: () {
              _stopSpeaking();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.green),
            title: Text(localizations?.diagnose ?? 'Diagnose'),
            onTap: () {
              _stopSpeaking();
              Navigator.pushNamed(context, '/symptom_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.green),
            title: Text(localizations?.smartAdvisor ?? 'Smart Advisor'),
            onTap: () {
              _stopSpeaking();
              Navigator.pushNamed(context, '/smart_advisor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.riceAdvisorTutor ?? 'RiceAdvisor Tutor'),
            onTap: () {
              _stopSpeaking();
              Navigator.pushNamed(context, '/tutor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library, color: Colors.green),
            title: Text(localizations?.learningModules ?? 'Learning Videos'),
            onTap: () {
              Navigator.pushNamed(context, '/learning_modules');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text(localizations?.elearningModules ?? 'E Learning'),
            onTap: () {
              Navigator.pushNamed(context, '/e_learning');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: Text(localizations?.chatbot ?? 'Chatbot'),
            onTap: () {
              _stopSpeaking();
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(localizations?.exit ?? 'Exit'),
            onTap: () {
              _stopSpeaking();
              exit(0);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(
          localizations?.smartAdvisorTitle ?? '🌱 Smart Advisor',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _stopSpeaking();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _stopSpeaking();
              _checkRequirements();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(localizations),
      floatingActionButton: !isLoading && errorMessage == null
          ? FloatingActionButton(
              onPressed: _isSpeaking ? _stopSpeaking : _speakResults,
              backgroundColor: _isSpeaking ? Colors.red : Colors.green,
              tooltip: _isSpeaking ? "Stop speaking" : "Read aloud",
              child: Icon(
                _isSpeaking ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
            )
          : null,
      body: Center(
        child: errorMessage != null
            ? _buildErrorState()
            : isLoading
                ? _buildLoadingState()
                : _buildWeatherContent(),
      ),
    );
  }

  @override
  void dispose() {
    _stopSpeaking();
    flutterTts.stop();
    super.dispose();
  }
}

e_learning_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class ELearningScreen extends StatefulWidget {
  const ELearningScreen({super.key});

  @override
  State<ELearningScreen> createState() => _ELearningScreenState();
}

class _ELearningScreenState extends State<ELearningScreen> with WidgetsBindingObserver {
  // App states
  bool _isLoading = false;
  bool _showMaterialsList = true;
  bool _showPdfViewer = false;
  bool _showQuiz = false;
  bool _showCompletionScreen = false;
  bool _showNameDialog = false; // New state for name dialog
  final GlobalKey _certificateKey = GlobalKey();
  PDFViewController? _pdfViewController;

  // User info
  String _userName = ''; // Store user name

  // PDF navigation
  int _currentSlidePosition = 0;
  int _totalSlides = 0;
  
  // PDF related
  String? _currentPdfPath;
  int? _totalPages;
  int? _currentPage = 0;
  
  // Quiz related
  int _currentScore = 0;
  int _totalQuestions = 0;
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = [];
  List<bool> _isCorrect = [];
  
  // Learning materials
  final List<Map<String, dynamic>> _learningMaterials = [
    {
      'title': 'Rice Production Manual',
      'description': 'Complete guide to rice cultivation techniques',
      'assetPath': 'assets/rice_production_manual.pdf',
      'quizScores': {},
      'lastScore': 0,
      'unlockThreshold': 0,
      'passThreshold': 70,
      'isUnlocked': true,
    },
    {
      'title': 'Guide to Rice Production',
      'description': 'Practical guide to rice cultivation in Nigeria',
      'assetPath': 'assets/guide_to_rice_production_in_nigeria.pdf',
      'quizScores': {},
      'lastScore': 0,
      'unlockThreshold': 70,
      'passThreshold': 75,
      'isUnlocked': false,
    },
    {
      'title': 'SRI Training Module',
      'description': 'Advanced System of Rice Intensification techniques',
      'assetPath': 'assets/sri_training_module.pdf',
      'quizScores': {},
      'lastScore': 0,
      'unlockThreshold': 75,
      'passThreshold': 80,
      'isUnlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeMaterials();
    _loadUserData();
  }

  // Load user data from storage
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    
    // Load user name
    final savedName = prefs.getString('user_name');
    if (savedName == null || savedName.isEmpty) {
      // Show name dialog if name is not saved
      setState(() {
        _isLoading = false;
        _showNameDialog = true;
      });
    } else {
      setState(() {
        _userName = savedName;
        _isLoading = false;
      });
    }
    
    // Load quiz scores after loading user data
    _loadQuizScoresAndUnlockStatus();
  }

  // Save user name to storage
  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    setState(() {
      _userName = name;
      _showNameDialog = false;
    });
  }

  void _initializeMaterials() {
    _learningMaterials[0]['isUnlocked'] = true;
    for (int i = 1; i < _learningMaterials.length; i++) {
      _learningMaterials[i]['isUnlocked'] = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadQuizScoresAndUnlockStatus();
    }
  }

  Future<bool> _isCourseCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('course_completed') ?? false;
  }

  Future<void> _loadQuizScoresAndUnlockStatus() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    
    for (int i = 0; i < _learningMaterials.length; i++) {
      final material = _learningMaterials[i];
      material['quizScores'] = {};
      
      // Load detailed scores
      final scores = prefs.getStringList('quiz_scores_${material['title']}') ?? [];
      for (var entry in scores) {
        try {
          final parts = entry.split(':');
          if (parts.length == 2) {
            material['quizScores'][parts[0]] = int.tryParse(parts[1]) ?? 0;
          }
        } catch (e) {
          debugPrint('Error parsing score entry: $entry');
        }
      }
      
      // Get highest score from both sources
      final storedHighest = prefs.getInt('highest_score_${material['title']}') ?? 0;
      final calculatedHighest = _getHighestScore(material['quizScores']);
      material['lastScore'] = storedHighest > calculatedHighest ? storedHighest : calculatedHighest;
      
      // Handle unlock status
      if (i > 0) {
        final previousMaterial = _learningMaterials[i - 1];
        final highestPreviousScore = _getHighestScore(previousMaterial['quizScores']);
        final wasUnlocked = prefs.getBool('${material['title']}_unlocked') ?? false;
        
        material['isUnlocked'] = highestPreviousScore >= previousMaterial['passThreshold'] || wasUnlocked;
        
        if (material['isUnlocked']) {
          await prefs.setBool('${material['title']}_unlocked', true);
        }
      }
    }
    
    setState(() => _isLoading = false);
  }

  int _getHighestScore(Map<dynamic, dynamic> scores) {
    if (scores.isEmpty) return 0;
    return scores.values.cast<int>().reduce((a, b) => a > b ? a : b);
  }

  Future<void> _saveQuizScore(String materialTitle, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().toIso8601String();
    
    // Save detailed score
    final scores = prefs.getStringList('quiz_scores_$materialTitle') ?? [];
    scores.add('$timestamp:$score');
    await prefs.setStringList('quiz_scores_$materialTitle', scores);
    
    // Update highest score if needed
    final currentHighest = prefs.getInt('highest_score_$materialTitle') ?? 0;
    if (score > currentHighest) {
      await prefs.setInt('highest_score_$materialTitle', score);
    }
    
    // Update material data
    final materialIndex = _learningMaterials.indexWhere((m) => m['title'] == materialTitle);
    if (materialIndex == -1) return;
    
    _learningMaterials[materialIndex]['quizScores'][timestamp] = score;
    final highestScore = prefs.getInt('highest_score_$materialTitle') ?? 0;
    _learningMaterials[materialIndex]['lastScore'] = highestScore;
    
    // Handle unlocking next material
    if (materialIndex < _learningMaterials.length - 1) {
      if (highestScore >= _learningMaterials[materialIndex]['passThreshold']) {
        _learningMaterials[materialIndex + 1]['isUnlocked'] = true;
        await prefs.setBool(
          '${_learningMaterials[materialIndex + 1]['title']}_unlocked', 
          true
        );
      }
    }
    
    // Check course completion
    if (materialIndex == _learningMaterials.length - 1 && 
        highestScore >= _learningMaterials[materialIndex]['passThreshold']) {
      await prefs.setBool('course_completed', true);
    }
    
    setState(() {});
  }

  Future<void> _refreshScores() async {
    setState(() => _isLoading = true);
    await _loadQuizScoresAndUnlockStatus();
    setState(() => _isLoading = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scores refreshed')),
    );
  }

  Future<void> _openMaterial(Map<String, dynamic> material) async {
    if (!material['isUnlocked']) return;
    
    setState(() {
      _isLoading = true;
      _showMaterialsList = false;
      _showPdfViewer = true;
      _showCompletionScreen = false;
      _currentSlidePosition = 0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${material['title'].replaceAll(' ', '_')}.pdf');
      
      if (!await file.exists()) {
        final data = await DefaultAssetBundle.of(context).load(material['assetPath']);
        await file.writeAsBytes(data.buffer.asUint8List());
      }

      setState(() {
        _currentPdfPath = file.path;
        _isLoading = false;
      });
      
      _generateQuestions(material['title']);
      _showQuizInfoDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load material: $e')),
      );
      _showMaterialsList = true;
      _showPdfViewer = false;
    }
  }

  void _showQuizInfoDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Quiz Information',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: const Text(
            'After completing this material, you\'ll be assessed with a short quiz to test your understanding.'
            'You can access the quiz at any time by clicking the quiz button that appears at the end of the material.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.green, fontSize: 18)),
            ),
          ],
        ),
      );
    });
  }

  // Widget for name input dialog
  Widget _buildNameDialog() {
    final TextEditingController nameController = TextEditingController();
    
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_add,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Rice Cultivation Training',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enter your name to get started.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.green[50],
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      _saveUserName(nameController.text.trim());
                    }
                  },
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _generateQuestions(String materialTitle) {
    setState(() {
      if (materialTitle == 'Rice Production Manual') {
        _questions = [
          // Existing questions
          {
            'question': 'What is the recommended spacing for rice planting?',
            'options': ['10cm x 10cm', '20cm x 20cm', '30cm x 30cm', '40cm x 40cm'],
            'correctAnswer': '20cm x 20cm',
            'referencePage': 5,
          },
          {
            'question': 'When is the best time to harvest rice?',
            'options': [
              'When 50% of grains are mature',
              'When 80% of grains are mature',
              'When all grains are fully mature',
              'When leaves start turning yellow'
            ],
            'correctAnswer': 'When 80% of grains are mature',
            'referencePage': 29,
          },
          {
            'question': 'What is the most common rice pest?',
            'options': ['Aphids', 'Rice weevil', 'Stem borer', 'Locusts'],
            'correctAnswer': 'Stem borer',
            'referencePage': 21,
          },
          
          // Module 1: Agronomic Practices
          {
            'question': 'What are the three major growth phases of rice plants?',
            'options': [
              'Germination, flowering, maturity',
              'Vegetative, reproductive, ripening',
              'Seedling, tillering, harvesting',
              'Planting, growing, harvesting'
            ],
            'correctAnswer': 'Vegetative, reproductive, ripening',
            'referencePage': 14,
          },
          {
            'question': 'How many days after sowing should seedlings be transplanted?',
            'options': ['5-10 days', '15-30 days', '40-50 days', '60-70 days'],
            'correctAnswer': '15-30 days',
            'referencePage': 12,
          },
          
          // Module 2: Varietal Selection
          {
            'question': 'How do you break seed dormancy in freshly harvested rice seeds?',
            'options': [
              'Soak in cold water for 24 hours',
              'Heat treatment at 50°C or sun drying for 1-2 days',
              'Freeze the seeds overnight',
              'Treat with chemical fertilizers'
            ],
            'correctAnswer': 'Heat treatment at 50°C or sun drying for 1-2 days',
            'referencePage': 6,
          },
          {
            'question': 'What is the formula to calculate seed requirement per hectare?',
            'options': [
              '(Seed rate × Area) × % germination',
              '(Seed rate × Area) / (% germination × % filled grains)',
              'Seed rate × % germination',
              'Area / (Seed rate × % germination)'
            ],
            'correctAnswer': '(Seed rate × Area) / (% germination × % filled grains)',
            'referencePage': 7,
          },
          
          // Module 3: Site Selection
          {
            'question': 'What type of soil is preferred for rice cultivation?',
            'options': [
              'Sandy soil',
              'Heavy soil or valleys with good water retention',
              'Rocky soil',
              'Dry, loose soil'
            ],
            'correctAnswer': 'Heavy soil or valleys with good water retention',
            'referencePage': 9,
          },
          {
            'question': 'How often should soil tests be conducted?',
            'options': ['Every year', 'Every 3-4 years', 'Every 10 years', 'Only when problems appear'],
            'correctAnswer': 'Every 3-4 years',
            'referencePage': 9,
          },
          
          // Module 4: Rice Planting
          {
            'question': 'What are the two main methods of rice planting?',
            'options': [
              'Broadcasting and drilling',
              'Direct sowing and transplanting',
              'Hydroponics and aeroponics',
              'Seed tape and dibbling'
            ],
            'correctAnswer': 'Direct sowing and transplanting',
            'referencePage': 11,
          },
          {
            'question': 'How many seeds should be planted per hole in direct sowing?',
            'options': ['1 seed', '2 seeds', '3-4 seeds', '5-6 seeds'],
            'correctAnswer': '3-4 seeds',
            'referencePage': 11,
          },
          
          // Module 5: Water Management
          {
            'question': 'What is the ideal water depth to maintain after transplanting?',
            'options': [
              'Start with 1cm, increase to 2-3cm',
              'Start with 3cm, gradually increase to 5-10cm',
              'Keep constant at 15cm',
              'Flood the field completely'
            ],
            'correctAnswer': 'Start with 3cm, gradually increase to 5-10cm',
            'referencePage': 14,
          },
          {
            'question': 'What does AWD stand for in rice cultivation?',
            'options': [
              'Automatic Water Distribution',
              'Alternate Wetting and Drying',
              'Agricultural Water Directive',
              'Annual Water Demand'
            ],
            'correctAnswer': 'Alternate Wetting and Drying',
            'referencePage': 15,
          },
          
          // Module 6: Soil Fertility
          {
            'question': 'What are the recommended NPK application rates per hectare?',
            'options': [
              '80kg N, 20kg P2O5, 20kg K2O',
              '100kg N, 30kg P2O5, 30kg K2O',
              '120kg N, 40kg P2O5, 40kg K2O',
              '150kg N, 50kg P2O5, 50kg K2O'
            ],
            'correctAnswer': '120kg N, 40kg P2O5, 40kg K2O',
            'referencePage': 17,
          },
          {
            'question': 'When should the first top dressing of urea be applied?',
            'options': [
              '1-2 weeks after transplanting',
              '3-4 weeks after transplanting',
              '6-7 weeks after transplanting',
              'Only at planting time'
            ],
            'correctAnswer': '3-4 weeks after transplanting',
            'referencePage': 17,
          },
          
          // Module 7: Pest Management
          {
            'question': 'Name three common rice pests mentioned in the manual',
            'options': [
              'Stem borer, leaf folder, rice weevil',
              'Aphids, locusts, beetles',
              'Mosquitoes, flies, ants',
              'Rats, birds, snakes'
            ],
            'correctAnswer': 'Stem borer, leaf folder, rice weevil',
            'referencePage': 21,
          },
          {
            'question': 'What are three components of integrated pest management?',
            'options': [
              'Chemical control only',
              'Cultural control, varietal resistance, biological control',
              'Only using organic methods',
              'Spraying pesticides weekly'
            ],
            'correctAnswer': 'Cultural control, varietal resistance, biological control',
            'referencePage': 25,
          },
          
          // Module 8: Yield Forecasting
          {
            'question': 'What moisture content should grain be dried to for storage?',
            'options': ['5-8%', '10-12%', '13-14%', '15-18%'],
            'correctAnswer': '13-14%',
            'referencePage': 27,
          },
          
          // Module 9: Harvest/Post-Harvest
          {
            'question': 'What are two advantages of parboiling rice?',
            'options': [
              'Better storage and cooking quality',
              'Makes rice cook faster and changes color',
              'Reduces nutritional value but improves taste',
              'Makes rice harder and less digestible'
            ],
            'correctAnswer': 'Better storage and cooking quality',
            'referencePage': 32,
          },
          
          // Module 10: Record Keeping
          {
            'question': 'What are three benefits of farm record keeping?',
            'options': [
              'Track performance, evaluate profitability, access loans',
              'Only for tax purposes',
              'To show neighbors',
              'Required by law with no real benefits'
            ],
            'correctAnswer': 'Track performance, evaluate profitability, access loans',
            'referencePage': 34,
          }
        ];
      } 
      else if (materialTitle == 'Guide to Rice Production') {
        _questions = [
          {
            'question': 'What percentage of Nigeria\'s rice demand is met by imports?',
            'options': ['10%', '30%', '50%', '70%'],
            'correctAnswer': '50%',
            'referencePage': 4,
          },
          {
            'question': 'Which state is NOT a major rice producer in Nigeria?',
            'options': ['Ebonyi', 'Kebbi', 'Lagos', 'Kano'],
            'correctAnswer': 'Lagos',
            'referencePage': 4,
          },

          // 2. Site Selection & Varieties
          {
            'question': 'What is the key feature of FARO 52 rice variety?',
            'options': [
              'Early maturity (95–110 days)', 
              'High tillering capacity', 
              'Gold husk color', 
              'Blast disease resistance'
            ],
            'correctAnswer': 'High tillering capacity',
            'referencePage': 8,
          },
          {
            'question': 'Which rice variety is best suited for rainfed upland areas?',
            'options': ['FARO 44', 'FARO 52', 'FARO 59', 'GAWAL R1'],
            'correctAnswer': 'FARO 59',
            'referencePage': 8,
          },

          // 3. Land Preparation & Seeds
          {
            'question': 'What solution is used to sort viable rice seeds?',
            'options': ['Saltwater (12%)', 'Vinegar', 'Bleach', 'Sugar water'],
            'correctAnswer': 'Saltwater (12%)',
            'referencePage': 11,
          },
          {
            'question': 'How deep should rice seeds be planted?',
            'options': ['1–2 cm', '2–4 cm', '5–7 cm', '8–10 cm'],
            'correctAnswer': '2–4 cm',
            'referencePage': 13,
          },

          // 4. Fertilizer & Weed Control
          {
            'question': 'What is the recommended NPK ratio for lowland rice?',
            'options': ['15:15:15', '20:10:10', '10:20:20', '12:24:12'],
            'correctAnswer': '15:15:15',
            'referencePage': 14,
          },
          {
            'question': 'Which herbicide is applied post-emergence?',
            'options': ['Stomp CS', 'Vespanil Plus', 'Glyphosate', 'Mancozeb'],
            'correctAnswer': 'Vespanil Plus',
            'referencePage': 18,
          },

          // 5. Pest & Disease Control
          {
            'question': 'What is the symptom of borer attack in young rice plants?',
            'options': [
              'Yellow leaves', 
              'Dead heart', 
              'White powdery spots', 
              'Stunted roots'
            ],
            'correctAnswer': 'Dead heart',
            'referencePage': 20,
          },
          {
            'question': 'Which chemical controls blast disease?',
            'options': ['Lamdacyhalothrin', 'Dithane M-45', 'Coopex', 'Apron XL'],
            'correctAnswer': 'Dithane M-45',
            'referencePage': 23,
          },

          // 6. Harvesting & Storage
          {
            'question': 'How many days after flowering is rice ready for harvest?',
            'options': ['10–20 days', '30–45 days', '50–60 days', '70–80 days'],
            'correctAnswer': '30–45 days',
            'referencePage': 25,
          },
          {
            'question': 'What moisture content is safe for paddy storage?',
            'options': ['5–8%', '10–12%', '12–14%', '15–18%'],
            'correctAnswer': '12–14%',
            'referencePage': 27,
          },

          // 7. Parboiling & Yield
          {
            'question': 'How long should paddy be soaked for parboiling?',
            'options': ['1–2 hours', '5–6 hours', '12 hours', '24 hours'],
            'correctAnswer': '5–6 hours',
            'referencePage': 28,
          },
          {
            'question': 'What is the yield range for upland rice varieties (t/ha)?',
            'options': ['1–2', '2–3', '4–6', '8–10'],
            'correctAnswer': '4–6',
            'referencePage': 28,
          },

          // 8. General Agronomy
          {
            'question': 'What is the primary purpose of Alternate Wetting and Drying (AWD)?',
            'options': [
              'Increase soil acidity', 
              'Reduce water usage', 
              'Prevent bird attacks', 
              'Enhance seed dormancy'
            ],
            'correctAnswer': 'Reduce water usage',
            'referencePage': 15,
          },
          {
            'question': 'Which practice reduces Striga infestation?',
            'options': [
              'Monocropping', 
              'Late planting', 
              'Crop rotation with soybeans', 
              'Flooding the field'
            ],
            'correctAnswer': 'Crop rotation with soybeans',
            'referencePage': 22,
          },

          // 9. Tools & Safety
          {
            'question': 'What protective gear is needed for herbicide application?',
            'options': [
              'Gloves and goggles', 
              'Raincoat', 
              'Sandals', 
              'No special gear'
            ],
            'correctAnswer': 'Gloves and goggles',
            'referencePage': 18,
          },
          {
            'question': 'Which structure is used for modern paddy storage?',
            'options': ['Jute sacks', 'Earthen pots', 'Rumbu', 'Plastic bins'],
            'correctAnswer': 'Rumbu',
            'referencePage': 27,
          },

          // 10. Calculations
          {
            'question': 'If a seed germination rate is 80%, how much seed (kg) is needed for 1 ha at 50 kg/ha rate?',
            'options': ['40 kg', '50 kg', '62.5 kg', '75 kg'],
            'correctAnswer': '62.5 kg',
            'referencePage': 12,
          },

          {
            'question': 'Which nutrient is driven into the starchy core during parboiling?',
            'options': [
              'Vitamin C', 
              'Vitamin Thiamine', 
              'Iron', 
              'Calcium'
            ],
            'correctAnswer': 'Vitamin Thiamine',
            'referencePage': 28,
          },
        ];
      }
      else if (materialTitle == 'SRI Training Module') {
        _questions = [
          {
            'question': 'What is the primary goal of the System of Rice Intensification (SRI)?',
            'options': [
              'To increase water usage for higher yields', 
              'To reduce seed, water, and fertilizer use while boosting yields', 
              'To grow rice in flooded fields only', 
              'To eliminate the need for weeding'
            ],
            'correctAnswer': 'To reduce seed, water, and fertilizer use while boosting yields',
            'referencePage': 2,
          },
          {
            'question': 'How much can SRI reduce methane emissions compared to conventional rice farming?',
            'options': ['10–20%', '22–64%', '70–90%', 'No reduction'],
            'correctAnswer': '22–64%',
            'referencePage': 2,
          },

          // 2. Seed Preparation
          {
            'question': 'How are viable rice seeds separated from non-viable ones in SRI?',
            'options': [
              'By freezing seeds overnight', 
              'By soaking in saltwater and using seeds that sink', 
              'By exposing seeds to direct sunlight', 
              'By spraying with glyphosate'
            ],
            'correctAnswer': 'By soaking in saltwater and using seeds that sink',
            'referencePage': 3,
          },
          {
            'question': 'Why is seed soaking recommended in SRI?',
            'options': [
              'To kill pests', 
              'To initiate uniform germination', 
              'To reduce seed size', 
              'To increase seed dormancy'
            ],
            'correctAnswer': 'To initiate uniform germination',
            'referencePage': 3,
          },

          // 3. Nursery Management
          {
            'question': 'What is the ideal width of an SRI nursery bed?',
            'options': ['0.5m', '1m', '2m', '3m'],
            'correctAnswer': '1m',
            'referencePage': 4,
          },
          {
            'question': 'How many grams of seeds are used per 1m² of nursery bed in SRI?',
            'options': ['50g', '100g', '200g', '300g'],
            'correctAnswer': '100g',
            'referencePage': 5,
          },

          // 4. Land Preparation
          {
            'question': 'What is a key benefit of double harrowing in SRI?',
            'options': [
              'Reduces soil fertility', 
              'Ensures adequate soil aeration',
              'Increases waterlogging', 
              'Promotes weed growth'
            ],
            'correctAnswer': 'Ensures adequate soil aeration',
            'referencePage': 6,
          },
          {
            'question': 'Why is field leveling critical in SRI?',
            'options': [
              'To drown seedlings', 
              'To ensure even water distribution and fertilizer application', 
              'To attract birds', 
              'To reduce organic matter'
            ],
            'correctAnswer': 'To ensure even water distribution and fertilizer application',
            'referencePage': 7,
          },

          // 5. Transplanting
          {
            'question': 'At what growth stage are seedlings transplanted in SRI?',
            'options': [
              '4-leaf stage', 
              '2-leaf stage (8–12 days old)', 
              '6-leaf stage', 
              'After flowering'
            ],
            'correctAnswer': '2-leaf stage (8–12 days old)',
            'referencePage': 7,
          },
          {
            'question': 'What spacing is used for transplanting in SRI?',
            'options': ['10cm × 10cm', '20cm × 20cm', '30cm × 30cm', '40cm × 40cm'],
            'correctAnswer': '30cm × 30cm',
            'referencePage': 7,
          },

          // 6. Water Management
          {
            'question': 'What irrigation method is used in SRI during the vegetative stage?',
            'options': [
              'Continuous flooding', 
              'Alternate wetting and drying (AWD)', 
              'No irrigation', 
              'Sprinkler irrigation'
            ],
            'correctAnswer': 'Alternate wetting and drying (AWD)',
            'referencePage': 11,
          },
          {
            'question': 'How often should SRI fields typically be irrigated?',
            'options': ['Daily', 'Every 7–10 days', 'Monthly', 'Only at transplanting'],
            'correctAnswer': 'Every 7–10 days',
            'referencePage': 12,
          },

          // 7. Weed Management
          {
            'question': 'What is a key advantage of mechanical weeding in SRI?',
            'options': [
              'Increases soil compaction', 
              'Aerates soil and reincorporates weeds as organic matter', 
              'Promotes flooding', 
              'Reduces plant spacing'
            ],
            'correctAnswer': 'Aerates soil and reincorporates weeds as organic matter',
            'referencePage': 13,
          },
          {
            'question': 'When should mechanical weeding begin after transplanting?',
            'options': ['Immediately', '1–2 weeks later', 'After flowering', 'Never'],
            'correctAnswer': '1–2 weeks later',
            'referencePage': 13,
          },

          // 8. Fertilization
          {
            'question': 'What is the recommended organic matter application rate for a 0.5ha field?',
            'options': ['500kg', '1t', '2.5t', '5t'],
            'correctAnswer': '2.5t',
            'referencePage': 15,
          },
          {
            'question': 'When is urea best applied in SRI?',
            'options': [
              'At transplanting', 
              'During tillering and panicle initiation', 
              'Only after harvest', 
              'Never'
            ],
            'correctAnswer': 'During tillering and panicle initiation',
            'referencePage': 15,
          },

          // 9. Harvesting
          {
            'question': 'When is rice ready for harvest in SRI?',
            'options': [
              'When 50% panicles are yellow', 
              'When 85% panicles are yellow/brown', 
              'When leaves wilt', 
              'After first rains'
            ],
            'correctAnswer': 'When 85% panicles are yellow/brown',
            'referencePage': 17,
          },
          {
            'question': 'What is a key advantage of early harvest in SRI?',
            'options': [
              'Avoids bird damage', 
              'Increases water usage', 
              'Delays grain filling', 
              'Reduces tillering'
            ],
            'correctAnswer': 'Avoids bird damage',
            'referencePage': 17,
          },

          // 10. Post-Harvest
          {
            'question': 'What moisture content is safe for paddy storage?',
            'options': ['5–8%', '10–12%', '12–13%', '15–20%'],
            'correctAnswer': '12–13%',
            'referencePage': 19,
          },
          {
            'question': 'Why should paddy be dried immediately after harvest?',
            'options': [
              'To attract insects', 
              'To prevent microbial growth and mycotoxin production', 
              'To increase grain size', 
              'To reduce organic matter'
            ],
            'correctAnswer': 'To prevent microbial growth and mycotoxin production',
            'referencePage': 19,
          },
        ];
      }
      
      _totalQuestions = _questions.length;
      _selectedAnswers = List.filled(_totalQuestions, null);
      _isCorrect = List.filled(_totalQuestions, false);
    });
  }

  void _startQuiz() {
    setState(() {
      _showPdfViewer = false;
      _showQuiz = true;
      _currentQuestionIndex = 0;
      _currentScore = 0;
      _selectedAnswers = List.filled(_totalQuestions, null);
      _isCorrect = List.filled(_totalQuestions, false);
    });
  }

  void _answerQuestion(String answer) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answer;
      final isCorrect = answer == _questions[_currentQuestionIndex]['correctAnswer'];
      
      if (_isCorrect[_currentQuestionIndex] != isCorrect) {
        if (isCorrect) {
          _currentScore++;
        } else if (_isCorrect[_currentQuestionIndex]) {
          _currentScore--;
        }
        _isCorrect[_currentQuestionIndex] = isCorrect;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _completeQuiz();
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  Future<void> _completeQuiz() async {
    final material = _learningMaterials.firstWhere(
      (m) => _currentPdfPath?.contains(m['title'].replaceAll(' ', '_')) ?? false,
      orElse: () => _learningMaterials[0],
    );
    
    final percentageScore = ((_currentScore / _totalQuestions) * 100).round();
    await _saveQuizScore(material['title'], percentageScore);
    
    final currentIndex = _learningMaterials.indexWhere((m) => m['title'] == material['title']);
    final highestScore = material['lastScore'];
    final hasNextMaterial = currentIndex < _learningMaterials.length - 1;
    final nextMaterialUnlocked = hasNextMaterial && highestScore >= material['passThreshold'];
    final passmark = material['passThreshold'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Quiz Completed',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This attempt: $percentageScore% ($_currentScore out of $_totalQuestions)',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pass Mark: $passmark%',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your highest score: $highestScore%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              percentageScore == 100
                  ? 'Excellent! You mastered the material!'
                  : highestScore >= material['passThreshold'] && highestScore <= percentageScore
                      ? 'Good job! You passed!'
                      : highestScore > percentageScore 
                          ? 'Your performace dropped!'                     
                          : 'Review the material and try again!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (nextMaterialUnlocked)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Next material unlocked!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        actions: [
          if (percentageScore >= material['passThreshold'] && 
              currentIndex == _learningMaterials.length - 1)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _showQuiz = false;
                  _showCompletionScreen = true;
                });
              },
              child: const Text('View Certificate', style: TextStyle(color: Colors.green)),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showQuiz = false;
                _showMaterialsList = true;
              });
            },
            child: const Text('Back to Materials', style: TextStyle(color: Colors.green)),
          ),
          if (nextMaterialUnlocked)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _showQuiz = false;
                  _openMaterial(_learningMaterials[currentIndex + 1]);
                });
              },
              child: const Text('Next Material', style: TextStyle(color: Colors.green)),
            ),
          if (highestScore < material['passThreshold'])
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentQuestionIndex = 0;
                  _currentScore = 0;
                  _selectedAnswers = List.filled(_totalQuestions, null);
                  _isCorrect = List.filled(_totalQuestions, false);
                });
              },
              child: const Text('Try Again', style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }
  Future<void> _saveCertificate() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required to save certificates')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving certificate...')),
      );

      final boundary = _certificateKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to generate certificate image');
      
      final pngBytes = byteData.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/Certificates';
      await Directory(folderPath).create(recursive: true);
      
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '$folderPath/RiceCertificate_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Certificate saved successfully!'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              if (await file.exists()) await OpenFile.open(file.path);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save certificate: ${e.toString()}')),
      );
    }
  }

  Widget _buildCertificateScreen() {
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year}';
    
    return SingleChildScrollView(
      child: Center(
        child: RepaintBoundary(
          key: _certificateKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.green, width: 10),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/rice_doctor_logo_green.png', height: 80),
                      const SizedBox(height: 10),
                      const Text(
                        'CERTIFICATE OF COMPLETION',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'This is to certify that',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // Use the user's name instead of placeholder
                      Text(
                        _userName.isNotEmpty ? _userName : 'Student Name',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('has successfully completed the', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      const Text(
                        'Rice Cultivation Training Program',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center
                      ),
                      const SizedBox(height: 30),
                      const Text('with distinction on this day', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text(formattedDate, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                Container(height: 1, width: 120, color: Colors.black),
                                const Text('Program Director', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Container(height: 1, width: 120, color: Colors.black),
                                const Text('Date', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Certificate ID: RC-${DateTime.now().millisecondsSinceEpoch}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _buildCertificateScreen(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _saveCertificate,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Flexible(child: Text('Save Certificate', overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showCompletionScreen = false;
                          _showMaterialsList = true;
                        });
                      },
                      child: const Text('Back to Materials', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _learningMaterials.length,
      itemBuilder: (context, index) {
        final material = _learningMaterials[index];
        final isUnlocked = material['isUnlocked'] as bool;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: isUnlocked ? () => _openMaterial(material) : null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Opacity(
                opacity: isUnlocked ? 1.0 : 0.6,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isUnlocked ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isUnlocked ? Icons.menu_book : Icons.lock,
                        color: isUnlocked ? Colors.green : Colors.grey,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? Colors.black : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            material['description'],
                            style: TextStyle(
                              color: isUnlocked ? Colors.grey : Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.score, color: Colors.green, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'High Score: ${material['lastScore']}%',
                                style: TextStyle(
                                  color: isUnlocked ? Colors.green : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (!isUnlocked && index > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Score ${_learningMaterials[index - 1]['passThreshold']}% on previous material to unlock',
                                style: TextStyle(color: Colors.orange, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isUnlocked) const Icon(Icons.chevron_right, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPdfViewer() {
    return Column(
      children: [
        Expanded(
          child: PDFView(
            filePath: _currentPdfPath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
            onRender: (pages) => setState(() {
              _totalPages = pages;
              _totalSlides = pages ?? 0;
              _currentSlidePosition = _currentPage ?? 0;
            }),
            onPageChanged: (page, total) => setState(() {
              _currentPage = page;
              _currentSlidePosition = page ?? 0;
            }),
            onError: (error) => debugPrint(error.toString()),
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfViewController = pdfViewController;
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page ${(_currentPage ?? 0) + 1} of $_totalPages',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_currentSlidePosition < _totalSlides - 1) {
                    // Go to next slide
                    final nextPage = _currentSlidePosition + 1;
                    await _pdfViewController?.setPage(nextPage);
                    setState(() {
                      _currentSlidePosition = nextPage;
                      _currentPage = nextPage;
                    });
                  } else {
                    // Reached the end, start quiz
                    _startQuiz();
                  }
                },
                child: Text(
                  _currentSlidePosition < _totalSlides - 1 ? 'Next' : 'Take Quiz',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final currentAnswer = _selectedAnswers[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Quiz - Question ${_currentQuestionIndex + 1}/$_totalQuestions',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _totalQuestions,
              color: Colors.green,
              backgroundColor: Colors.green.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQuestion['question'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: (currentQuestion['options'] as List<String>).map((option) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: currentAnswer,
                      onChanged: (value) => _answerQuestion(value!),
                      activeColor: Colors.green,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                    onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: currentAnswer == null ? null : _nextQuestion,
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Colors.green));
    if (_showQuiz) return _buildQuiz();
    if (_showPdfViewer) return _buildPdfViewer();
    return _buildMaterialsList();
  }

  @override
  Widget build(BuildContext context) {
    // Show name dialog if needed
    if (_showNameDialog) {
      return Scaffold(
        backgroundColor: Colors.green[50],
        body: Center(
          child: _buildNameDialog(),
        ),
      );
    }
    
    if (_showCompletionScreen) return _buildCompletionScreen();
    
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          _showMaterialsList 
              ? 'Learning Materials' 
              : _showCompletionScreen
                  ? 'Course Completed'
                  : 'Rice Production Training',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_showPdfViewer || _showQuiz) {
              setState(() {
                _showPdfViewer = false;
                _showQuiz = false;
                _showMaterialsList = true;
              });
            } else if (_showCompletionScreen) {
              setState(() {
                _showCompletionScreen = false;
                _showMaterialsList = true;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          if (_showMaterialsList)
            FutureBuilder<bool>(
              future: _isCourseCompleted(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return IconButton(
                    icon: const Icon(Icons.download_done_outlined, color: Colors.white),
                    onPressed: () {
                      setState(() => _showCompletionScreen = true);
                    },
                    tooltip: 'View Certificate',
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refreshScores,
                    tooltip: 'Refresh scores',
                  );
                }
              },
            ),
        ],
      ),
      body: _buildContent(),
    );
  }
}
