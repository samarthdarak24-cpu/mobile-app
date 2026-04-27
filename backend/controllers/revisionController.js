const RevisionQueue = require('../models/RevisionQueue');

// @desc    Get pending revisions for user
// @route   GET /api/revision
// @access  Private
const getPendingRevisions = async (req, res) => {
  try {
    const today = new Date();
    
    // Find everything in queue where nextRevisionDate is <= today
    const revisions = await RevisionQueue.find({
      userId: req.user._id,
      nextRevisionDate: { $lte: today }
    }).populate('lessonId', 'topic difficulty duration');

    res.json(revisions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = { getPendingRevisions };
