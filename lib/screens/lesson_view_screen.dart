import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'lesson_quiz_screen.dart';

class LessonViewScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonViewScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.topic)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lesson.topic,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            _SectionContent(title: 'Explanation', content: lesson.explanation),
            const SizedBox(height: 20),
            _SectionContent(title: 'Example', content: lesson.example),
            const SizedBox(height: 20),
            _SectionContent(title: 'Summary', content: lesson.summary),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LessonQuizScreen(lesson: lesson)),
                );
              },
              child: const Text('Take Quiz'),
            )
          ],
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String title;
  final String content;

  const _SectionContent({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
