// Flutter Finance Adviser MVP
// Single-file starter app (main.dart)
// Add to a new Flutter project and replace lib/main.dart with this file.
// PUBSPEC: add these dependencies in pubspec.yaml:
//   fl_chart: ^0.55.2
//   intl: any
//   cupertino_icons: ^1.0.2

import 'package:flutter/material.dart';
// Removed unused imports after refactor
import 'pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/reports_page.dart';
import 'pages/chatbot_page.dart';
import 'pages/notifications_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(FinanceAdvisorApp());
}

class FinanceAdvisorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'مشاور مالی',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
  home: SplashWrapper(),
      locale: const Locale('fa'),
      supportedLocales: [const Locale('fa')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Remove global Directionality to fix bottom navigation bar position
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      primaryColor: Color(0xFF00E5C6), // mint accent
      scaffoldBackgroundColor: Color(0xFF0B1020), // deep dark
      colorScheme: base.colorScheme.copyWith(secondary: Color(0xFF7C4DFF)),
      textTheme: base.textTheme.apply(fontFamily: 'Inter'),
    );
  }
}

// --- Splash ---
class SplashWrapper extends StatefulWidget {
  @override
  _SplashWrapperState createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> with TickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: Duration(milliseconds: 1400));
    _anim.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainShell()));
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF07102A), Color(0xFF081423)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: CurvedAnimation(parent: _anim, curve: Curves.elasticOut),
              child: _LogoWidget(),
            ),
            SizedBox(height: 24),
            FadeTransition(
              opacity: _anim,
              child: Text('مشاور مالی', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white70)),
            )
          ],
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFF00E5C6), Color(0xFF7C4DFF)]),
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Center(
        child: Icon(Icons.account_balance_wallet_rounded, size: 56, color: Colors.white),
      ),
    );
  }
}

// --- Main Shell with custom floating bottom nav ---
class MainShell extends StatefulWidget {
  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _selectedIndex = 2; // chatbot center by default
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), ReportsPage(), ChatbotPage(), NotificationsPage(), SettingsPage()];
  }

  void _onTap(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: _pages[_selectedIndex],
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FloatingBottomNav(selectedIndex: _selectedIndex, onTap: _onTap),
          ),
        ],
      ),
    );
  }
}
class _FloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  _FloatingBottomNav({required this.selectedIndex, required this.onTap});

  final List<String> labels = const [
    'خانه', 'گزارش‌ها', 'چت', 'اعلان‌ها', 'تنظیمات'
  ];

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).primaryColor;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFF0D1626),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 8))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavIcon(icon: Icons.home_rounded, index: 0, selectedIndex: selectedIndex, onTap: onTap, label: labels[0]),
            _NavIcon(icon: Icons.bar_chart_rounded, index: 1, selectedIndex: selectedIndex, onTap: onTap, label: labels[1]),
            GestureDetector(
              onTap: () => onTap(2),
              child: Column(children:[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [accent, Theme.of(context).colorScheme.secondary]),
                    boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.32), blurRadius: 18, offset: Offset(0, 8))],
                  ),
                  child: Icon(Icons.chat_bubble_rounded, size: 36, color: Colors.white),
                ),
                Text(labels[2], style: TextStyle(color: selectedIndex==2?accent:Colors.white54, fontSize: 12))
              ]),
            ),
            _NavIcon(icon: Icons.notifications_rounded, index: 3, selectedIndex: selectedIndex, onTap: onTap, label: labels[3]),
            _NavIcon(icon: Icons.settings_rounded, index: 4, selectedIndex: selectedIndex, onTap: onTap, label: labels[4]),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final void Function(int) onTap;
  final String label;
  _NavIcon({required this.icon, required this.index, required this.selectedIndex, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final bool active = index == selectedIndex;
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(6),
            child: Icon(icon, size: 26, color: active ? Theme.of(context).primaryColor : Colors.white54),
          ),
        ),
        Text(label, style: TextStyle(color: active ? Theme.of(context).primaryColor : Colors.white54, fontSize: 12)),
      ],
    );
  }
}

// Removed custom floating bottom nav, now using BottomNavigationBar