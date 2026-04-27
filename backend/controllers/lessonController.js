const Lesson = require('../models/Lesson');
const LessonAttempt = require('../models/LessonAttempt');
const User = require('../models/User');
const LearningProfile = require('../models/LearningProfile');
const RevisionQueue = require('../models/RevisionQueue');
const { generateLesson } = require('../services/aiService');

// @desc    Start a lesson (Fetch from DB or Gen from AI)
// @route   POST /api/lesson/start
// @access  Private
const startLesson = async (req, res) => {
  try {
    const { topic, difficulty, duration } = req.body;

    // Check Cache
    let lesson = await Lesson.findOne({ topic, difficulty, duration });

    if (!lesson) {
      // Generate using AI
      const aiResponse = await generateLesson(topic, difficulty, duration);
      
      lesson = await Lesson.create({
        topic,
        difficulty,
        duration,
        explanation: aiResponse.explanation,
        example: aiResponse.example,
        summary: aiResponse.summary,
        quizQuestions: aiResponse.quizQuestions,
        generatedByAI: true
      });
    }

    res.status(200).json(lesson);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get lesson by ID
// @route   GET /api/lesson/:id
// @access  Private
const getLessonById = async (req, res) => {
  try {
    const lesson = await Lesson.findById(req.params.id);
    if (!lesson) return res.status(404).json({ message: 'Lesson not found' });
    res.json(lesson);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Submit a lesson result
// @route   POST /api/lesson/submit
// @access  Private
const submitLesson = async (req, res) => {
  try {
    const { lessonId, correctAnswers, wrongAnswers, timeSpent } = req.body;
    const userId = req.user._id;

    const lesson = await Lesson.findById(lessonId);
    if (!lesson) return res.status(404).json({ message: 'Lesson not found' });

    // Mark attempt
    await LessonAttempt.create({
      userId,
      lessonId,
      correctAnswers,
      wrongAnswers,
      timeSpent,
      completed: true
    });

    // Update User XP & Streak (Strictly limited to once daily)
    const user = await User.findById(userId);
    let xpGained = 0;

    const today = new Date().setHours(0, 0, 0, 0);
    const lastLearning = user.lastLearningDate ? new Date(user.lastLearningDate).setHours(0,0,0,0) : null;
    let earnedToday = false;

    if (lastLearning) {
      const diffTime = Math.abs(today - lastLearning);
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
      
      if (diffDays === 1) {
        user.currentStreak += 1;
        earnedToday = true;
      } else if (diffDays === 0) {
        // Already satisfied daily goal. Do not increment streak or award base XP again today.
        earnedToday = false;
      } else if (diffDays > 1) {
        user.currentStreak = 1;
        earnedToday = true;
      }
    } else {
      user.currentStreak = 1;
      earnedToday = true;
    }

    if (earnedToday) {
      xpGained = correctAnswers * 10;
      user.totalXP += xpGained;
      user.level = Math.floor(user.totalXP / 100) + 1;
      user.lastLearningDate = new Date();
      if (user.currentStreak > user.longestStreak) {
        user.longestStreak = user.currentStreak;
      }
      await user.save();
    }

    // Learning Profile Logic - Weak/Strong Topics
    const profile = await LearningProfile.findOne({ userId });
    const scorePercentage = correctAnswers / (correctAnswers + wrongAnswers);

    if (scorePercentage < 0.6) {
      if (!profile.weakTopics.includes(lesson.topic)) {
        profile.weakTopics.push(lesson.topic);
      }
      profile.strongTopics = profile.strongTopics.filter(t => t !== lesson.topic);
    } else {
      if (!profile.strongTopics.includes(lesson.topic)) {
        profile.strongTopics.push(lesson.topic);
      }
      profile.weakTopics = profile.weakTopics.filter(t => t !== lesson.topic);
    }
    await profile.save();

    // Spaced Repetition Logic (Schedule for 1 day later)
    let revisionDate = new Date();
    revisionDate.setDate(revisionDate.getDate() + 1);

    // See if already in queue
    let queueEntry = await RevisionQueue.findOne({ userId, lessonId });
    if (queueEntry) {
      // increase spacing
      const daysToAdd = queueEntry.revisionStage === 1 ? 2 : queueEntry.revisionStage === 2 ? 4 : 7;
      revisionDate = new Date();
      revisionDate.setDate(revisionDate.getDate() + daysToAdd);
      queueEntry.revisionStage += 1;
      queueEntry.nextRevisionDate = revisionDate;
      await queueEntry.save();
    } else {
      await RevisionQueue.create({
        userId,
        lessonId,
        revisionStage: 1,
        nextRevisionDate: revisionDate
      });
    }

    res.json({ message: 'Lesson submitted successfully', userStats: { xpGained, currentXP: user.totalXP, level: user.level, streak: user.currentStreak }});
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get user's past lessons
// @route   GET /api/lesson/history
// @access  Private
const getLessonHistory = async (req, res) => {
  try {
    const history = await LessonAttempt.find({ userId: req.user._id })
      .populate('lessonId')
      .sort({ createdAt: -1 });
    
    res.json(history);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { startLesson, getLessonById, submitLesson, getLessonHistory };
