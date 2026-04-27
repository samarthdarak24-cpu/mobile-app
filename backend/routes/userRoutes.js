const express = require('express');
const router = express.Router();
const { getUserProfile, getUserProgress } = require('../controllers/userController');
const { protect } = require('../middleware/authMiddleware');

router.get('/profile', protect, getUserProfile);
router.get('/progress', protect, getUserProgress);

module.exports = router;
