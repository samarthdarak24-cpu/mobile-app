const express = require('express');
const router = express.Router();
const { getPendingRevisions } = require('../controllers/revisionController');
const { protect } = require('../middleware/authMiddleware');

router.get('/', protect, getPendingRevisions);

module.exports = router;
