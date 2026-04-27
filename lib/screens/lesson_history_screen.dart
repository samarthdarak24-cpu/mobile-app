import 'package:flutter/material.dart';
import '../services/lesson_service.dart';

class LessonHistoryScreen extends StatefulWidget {
  const LessonHistoryScreen({super.key});

  @override
  State<LessonHistoryScreen> createState() => _LessonHistoryScreenState();
}

class _LessonHistoryScreenState extends State<LessonHistoryScreen> {
  final LessonService _lessonService = LessonService();
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _lessonService.fetchHistory();
    setState(() {
      history = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : history.isEmpty 
          ? const Center(child: Text("No older sessions found. Start a new topic!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final attempt = history[index];
                final lesson = attempt['lessonId'];
                if (lesson == null) return const SizedBox();

                final date = DateTime.parse(attempt['createdAt']);
                final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                
                final correct = attempt['correctAnswers'];
                final wrong = attempt['wrongAnswers'];
                final total = correct + wrong;
                final percentage = total == 0 ? 0 : ((correct / total) * 100).round();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(
                      lesson['title'] ?? lesson['topic'], 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Topic: ${lesson['topic']} • ${lesson['difficulty']}"),
                          const SizedBox(height: 4),
                          Text("Completed: $dateStr"),
                        ],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$percentage%",
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold,
                            color: percentage >= 60 ? Colors.green : Colors.orange,
                          ),
                        ),
                        const Text("Score", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
