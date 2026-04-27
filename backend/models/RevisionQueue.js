const mongoose = require('mongoose');

const revisionQueueSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  lessonId: { type: mongoose.Schema.Types.ObjectId, ref: 'Lesson', required: true },
  revisionStage: { type: Number, default: 1 }, // e.g., 1=day1, 2=day3, 3=day7
  nextRevisionDate: { type: Date, required: true }
}, {
  timestamps: true
});

module.exports = mongoose.model('RevisionQueue', revisionQueueSchema);
