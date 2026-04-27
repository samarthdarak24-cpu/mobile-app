require('dotenv').config({ path: 'c:/Users/Balaji/cp_oops/config/flutter_application_1/flutter_application_1/backend/.env' });

async function listModels() {
  const apiKey = process.env.GEMINI_API_KEY;
  const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey}`);
  const data = await res.json();
  if (data.models) {
    const valid = data.models
      .filter(m => m.supportedGenerationMethods && m.supportedGenerationMethods.includes('generateContent'))
      .map(m => m.name);
    console.log("VALID MODELS:", valid);
  } else {
    console.log("Error:", data);
  }
}
listModels();
