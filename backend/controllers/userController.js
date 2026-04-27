const User = require('../models/User');
const LearningProfile = require('../models/LearningProfile');

// @desc    Get user profile
// @route   GET /api/user/profile
// @access  Private
const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    const profile = await LearningProfile.findOne({ userId: req.user._id });

    if (user && profile) {
      res.json({
        _id: user._id,
        name: user.name,
        email: user.email,
        profilePicture: user.profilePicture,
        totalXP: user.totalXP,
        level: user.level,
        currentStreak: user.currentStreak,
        longestStreak: user.longestStreak,
        learningProfile: profile
      });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get user progress details
// @route   GET /api/user/progress
// @access  Private
const getUserProgress = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('totalXP level currentStreak longestStreak');
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { getUserProfile, getUserProgress };
