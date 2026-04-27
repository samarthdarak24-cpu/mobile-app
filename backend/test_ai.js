const dotenv = require('dotenv');
dotenv.config({ path: __dirname + '/.env' });
const { generateLesson } = require('./services/aiService');

async function test() {
  try {
    console.log("Starting test generation...");
    const res = await generateLesson("python", "Beginner", 5);
    console.log("SUCCESS:", Object.keys(res));
    require('fs').writeFileSync('test_output.txt', JSON.stringify(res, null, 2));
  } catch (e) {
    console.log("FAILED WITH ERROR");
    require('fs').writeFileSync('test_output.txt', String(e.stack || e));
  }
}
test();
