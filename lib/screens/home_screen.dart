import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/lesson_service.dart';
import '../models/lesson.dart';
import 'lesson_setup_screen.dart';
import 'lesson_history_screen.dart';
import 'flashcard_review_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _launchFlashcards(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final data = await LessonService().fetchHistory();
    if (context.mounted) Navigator.pop(context);

    if (data.isNotEmpty) {
      final latest = data.first['lessonId'];
      final lessonObj = Lesson.fromJson(latest);
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardReviewScreen(lesson: lessonObj)));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Take a lesson first to unlock interactive flashcards!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonHistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => auth.logout(),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Welcome, ${user?.name.split(" ")[0] ?? 'Explorer'}! 👋',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Stat(title: 'Level', val: user?.level.toString() ?? '1', icon: Icons.star, clr: Colors.amber),
                      _Stat(title: 'XP', val: user?.totalXP.toString() ?? '0', icon: Icons.bolt, clr: Colors.blueAccent),
                      _Stat(title: 'Streak', val: user?.currentStreak.toString() ?? '0', icon: Icons.local_fire_department, clr: Colors.redAccent),
                    ],
                  ),
                ),

                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonSetupScreen())),
                  child: _buildActionCard('Start New Lesson', 'Explore a new topic today', Icons.rocket_launch, Colors.tealAccent),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _launchFlashcards(context),
                  child: _buildActionCard('Review Flashcards', 'Solidify past learning', Icons.style, Colors.purpleAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 30)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String title;
  final String val;
  final IconData icon;
  final Color clr;

  const _Stat({required this.title, required this.val, required this.icon, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: clr, size: 28),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(title, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
      ],
    );
  }
}
