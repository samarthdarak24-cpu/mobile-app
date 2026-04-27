import 'dart:math';
import 'package:flutter/material.dart';
import '../models/lesson.dart';
import 'lesson_result_screen.dart';
import '../services/lesson_service.dart';

class FlashcardReviewScreen extends StatefulWidget {
  final Lesson lesson;
  const FlashcardReviewScreen({super.key, required this.lesson});

  @override
  State<FlashcardReviewScreen> createState() => _FlashcardReviewScreenState();
}

class _FlashcardReviewScreenState extends State<FlashcardReviewScreen> {
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;

  void _nextCard(bool knewIt) {
    if (knewIt) correctCount++;
    else wrongCount++;

    if (currentIndex < widget.lesson.quizQuestions.length - 1) {
      setState(() { currentIndex++; });
    } else {
      _finishReview();
    }
  }

  void _finishReview() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    
    final service = LessonService();
    final result = await service.submitLesson(widget.lesson.id, correctCount, wrongCount, 120);
    
    if (mounted) {
      Navigator.pop(context); 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonResultScreen(result: result ?? {}),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.lesson.quizQuestions[currentIndex];
    final answerStr = question.options[question.correctOptionIndex];

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text('Flashcard Review (${currentIndex + 1}/${widget.lesson.quizQuestions.length})'),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _FlipCard(
                  frontText: question.question,
                  backText: answerStr,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text("Still Learning", style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => _nextCard(false),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Got It", style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => _nextCard(true),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FlipCard extends StatefulWidget {
  final String frontText;
  final String backText;

  const _FlipCard({required this.frontText, required this.backText});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  @override
  void didUpdateWidget(_FlipCard oldWidget) {
    if (oldWidget.frontText != widget.frontText) {
      if (!_isFront) _flip();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isUnder = _animation.value > pi / 2;
          final angle = _animation.value;
          
          return Transform(
            transform: Matrix4.rotationY(angle),
            alignment: Alignment.center,
            child: isUnder 
              ? Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child: _buildCardContent(widget.backText, Colors.teal.shade800, Colors.white)
                ) 
              : _buildCardContent(widget.frontText, Colors.white, Colors.black87),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(String text, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ]
      ),
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(bgColor == Colors.white ? Icons.help_outline : Icons.lightbulb_outline, size: 48, color: textColor.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}
