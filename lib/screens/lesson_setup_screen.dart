import 'package:flutter/material.dart';
import '../services/lesson_service.dart';
import 'lesson_view_screen.dart';

class LessonSetupScreen extends StatefulWidget {
  const LessonSetupScreen({super.key});

  @override
  State<LessonSetupScreen> createState() => _LessonSetupScreenState();
}

class _LessonSetupScreenState extends State<LessonSetupScreen> {
  final _topicController = TextEditingController();
  final LessonService _lessonService = LessonService();
  
  String _difficulty = 'beginner';
  int _duration = 5;
  bool _isLoading = false;

  void _generateLesson() async {
    if (_topicController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final lesson = await _lessonService.startLesson(
      _topicController.text.trim(), 
      _difficulty, 
      _duration
    );
    setState(() => _isLoading = false);

    if (lesson != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LessonViewScreen(lesson: lesson)),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate lesson. Please try again.'))
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Lesson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What do you want to learn today?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                hintText: 'e.g., Python Lists, Options Trading...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Length'),
            DropdownButton<int>(
              value: _duration,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 3, child: Text('3 Minutes')),
                DropdownMenuItem(value: 5, child: Text('5 Minutes')),
                DropdownMenuItem(value: 10, child: Text('10 Minutes')),
              ],
              onChanged: (val) => setState(() => _duration = val!),
            ),
            const SizedBox(height: 20),
            const Text('Difficulty'),
            DropdownButton<String>(
              value: _difficulty,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (val) => setState(() => _difficulty = val!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: _isLoading ? null : _generateLesson,
                child: _isLoading 
                    ? const CircularProgressIndicator() 
                    : const Text('Generate Lesson & Start'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
