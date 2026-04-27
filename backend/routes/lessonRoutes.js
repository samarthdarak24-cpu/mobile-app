const express = require('express');
const router = express.Router();
const { startLesson, getLessonById, submitLesson, getLessonHistory } = require('../controllers/lessonController');
const { protect } = require('../middleware/authMiddleware');

router.post('/start', protect, startLesson);
router.post('/submit', protect, submitLesson);
router.get('/history', protect, getLessonHistory);
router.get('/:id', protect, getLessonById);

module.exports = router;
