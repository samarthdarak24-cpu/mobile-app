const mongoose = require('mongoose');

const lessonSchema = new mongoose.Schema({
  topic: { type: String, required: true },
  difficulty: { type: String, required: true },
  duration: { type: Number, required: true }, // 3, 5, 10
  explanation: { type: String, required: true },
  example: { type: String, required: true },
  summary: { type: String, required: true },
  quizQuestions: [{
    question: { type: String, required: true },
    options: [{ type: String, required: true }],
    correctOptionIndex: { type: Number, required: true }
  }],
  generatedByAI: { type: Boolean, default: true }
}, {
  timestamps: true
});

module.exports = mongoose.model('Lesson', lessonSchema);
