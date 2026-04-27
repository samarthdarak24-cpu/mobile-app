const mongoose = require('mongoose');

const lessonAttemptSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  lessonId: { type: mongoose.Schema.Types.ObjectId, ref: 'Lesson', required: true },
  correctAnswers: { type: Number, default: 0 },
  wrongAnswers: { type: Number, default: 0 },
  timeSpent: { type: Number, default: 0 }, // in seconds
  completed: { type: Boolean, default: false }
}, {
  timestamps: true
});

module.exports = mongoose.model('LessonAttempt', lessonAttemptSchema);
