import 'dart:convert';
// import 'package:flutter/material.dart';
import 'api_service.dart';
import '../core/constants.dart';
import '../models/lesson.dart';

class LessonService {
  final ApiService _apiService = ApiService();

  Future<Lesson?> startLesson(String topic, String difficulty, int duration) async {
    try {
      final response = await _apiService.post(ApiConstants.startLessonEndpoint, {
        'topic': topic,
        'difficulty': difficulty,
        'duration': duration,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Lesson.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error starting lesson: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitLesson(String lessonId, int correct, int wrong, int timeSpent) async {
    try {
      final response = await _apiService.post(ApiConstants.submitLessonEndpoint, {
        'lessonId': lessonId,
        'correctAnswers': correct,
        'wrongAnswers': wrong,
        'timeSpent': timeSpent,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error submitting lesson: $e');
      return null;
    }
  }

  Future<List<dynamic>> fetchHistory() async {
    try {
      final response = await _apiService.get('/lesson/history');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }
}
