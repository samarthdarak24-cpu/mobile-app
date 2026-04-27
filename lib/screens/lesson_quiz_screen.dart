import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import 'lesson_result_screen.dart';

class LessonQuizScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonQuizScreen({super.key, required this.lesson});

  @override
  State<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  final LessonService _lessonService = LessonService();
  int _currentQuestionIndex = 0;
  List<int?> _selectedAnswers = [];
  bool _isLoading = false;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _selectedAnswers = List.filled(widget.lesson.quizQuestions.length, null);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.lesson.quizQuestions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() async {
    setState(() => _isLoading = true);

    int correct = 0;
    int wrong = 0;
    for (int i = 0; i < widget.lesson.quizQuestions.length; i++) {
      if (_selectedAnswers[i] == widget.lesson.quizQuestions[i].correctOptionIndex) {
        correct++;
      } else {
        wrong++;
      }
    }

    final timeSpent = DateTime.now().difference(_startTime).inSeconds;

    final result = await _lessonService.submitLesson(
      widget.lesson.id, 
      correct, 
      wrong, 
      timeSpent
    );

    setState(() => _isLoading = false);

    if (result != null && mounted) {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LessonResultScreen(result: result)),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit learning results. PLease check your connection.'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.quizQuestions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No quiz available for this topic.")));
    }

    final question = widget.lesson.quizQuestions[_currentQuestionIndex];
    final selectedOption = _selectedAnswers[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz: ${widget.lesson.topic}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${widget.lesson.quizQuestions.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAnswers[_currentQuestionIndex] = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedOption == index ? Colors.teal.shade100 : Colors.white,
                      border: Border.all(color: selectedOption == index ? Colors.teal : Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(question.options[index], style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: selectedOption == null || _isLoading ? null : _nextQuestion,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_currentQuestionIndex < widget.lesson.quizQuestions.length - 1 ? 'Next Question' : 'Submit Quiz'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
