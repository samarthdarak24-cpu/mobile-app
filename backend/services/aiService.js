const { GoogleGenerativeAI } = require('@google/generative-ai');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

/**
 * Generate a lesson using Google Gemini structured JSON output.
 * @param {string} topic - The topic to teach
 * @param {string} difficulty - beginner, intermediate, or advanced
 * @param {number} duration - 3, 5, or 10 minutes
 */
const generateLesson = async (topic, difficulty, duration) => {
  const numQuestions = duration === 3 ? 2 : duration === 5 ? 3 : 5;

  const prompt = `Generate a ${difficulty}-level, ${duration}-minute micro-learning lesson on the topic of "${topic}". 
  Provide the result in valid JSON format matching this exact schema:
  {
    "title": "A catchy title",
    "explanation": "Clear explanation of the concept tailored to the difficulty",
    "example": "A concrete example to illustrate the concept",
    "summary": "A 1-2 sentence recap",
    "quizQuestions": [
      {
        "question": "Question text",
        "options": ["Option A", "Option B", "Option C", "Option D"],
        "correctOptionIndex": 0 
      }
    ]
  }
  Ensure there are exactly ${numQuestions} quiz questions. Important constraint: Always output your complete response in raw JSON format, do NOT wrap the response in markdown blocks like \`\`\`json.`;

  try {
    const model = genAI.getGenerativeModel({ 
      model: "gemini-2.5-flash"
    });

    const result = await model.generateContent(prompt);
    let text = result.response.text();
    text = text.replace(/```json/g, '').replace(/```/g, ''); // strip markdown

    
    const lessonData = JSON.parse(text);
    return lessonData;
  } catch (error) {
    console.error('Error in aiService (Gemini):', error);
    throw new Error('Failed to generate lesson from AI');
  }
};

module.exports = { generateLesson };
