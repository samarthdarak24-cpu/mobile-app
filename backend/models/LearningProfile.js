const mongoose = require('mongoose');

const learningProfileSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  weakTopics: [{ type: String }],
  strongTopics: [{ type: String }],
  preferredLessonLength: { 
    type: Number, 
    enum: [3, 5, 10], 
    default: 5 
  },
  difficultyLevel: { 
    type: String, 
    enum: ['beginner', 'intermediate', 'advanced'], 
    default: 'beginner' 
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('LearningProfile', learningProfileSchema);
