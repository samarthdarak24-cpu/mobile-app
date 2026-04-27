import 'package:flutter/material.dart';
import 'home_screen.dart';

class LessonResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const LessonResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final stats = result['userStats'] ?? {};
    final xpGained = stats['xpGained'] ?? 0;
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, size: 100, color: Colors.orange),
              const SizedBox(height: 20),
              const Text('Lesson Completed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text('+$xpGained XP', style: const TextStyle(fontSize: 36, color: Colors.teal, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              Text(result['message'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (_) => const HomeScreen()), 
                      (r) => false
                    );
                  },
                  child: const Text('Back to Dashboard'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
