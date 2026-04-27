class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correctOptionIndex'] ?? 0,
    );
  }
}

class Lesson {
  final String id;
  final String topic;
  final String difficulty;
  final int duration;
  final String explanation;
  final String example;
  final String summary;
  final List<QuizQuestion> quizQuestions;

  Lesson({
    required this.id,
    required this.topic,
    required this.difficulty,
    required this.duration,
    required this.explanation,
    required this.example,
    required this.summary,
    required this.quizQuestions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var list = json['quizQuestions'] as List? ?? [];
    List<QuizQuestion> quizList = list.map((i) => QuizQuestion.fromJson(i)).toList();

    return Lesson(
      id: json['_id'] ?? '',
      topic: json['topic'] ?? '',
      difficulty: json['difficulty'] ?? '',
      duration: json['duration'] ?? 5,
      explanation: json['explanation'] ?? '',
      example: json['example'] ?? '',
      summary: json['summary'] ?? '',
      quizQuestions: quizList,
    );
  }
}
