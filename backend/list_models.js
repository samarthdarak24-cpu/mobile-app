require('dotenv').config({ path: 'c:/Users/Balaji/cp_oops/config/flutter_application_1/flutter_application_1/backend/.env' });

async function listModels() {
  const apiKey = process.env.GEMINI_API_KEY;
  const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models?key=${apiKey}`);
  const data = await res.json();
  console.log("AVAILABLE MODELS:");
  if (data.models) {
    data.models.forEach(m => console.log(m.name));
  } else {
    console.log(data);
  }
}
listModels();
