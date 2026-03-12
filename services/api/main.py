from fastapi import FastAPI
from pydantic import BaseModel
from google import genai

app = FastAPI(title="AI Translation API", version="0.1.0")

# 建立 Pydantic 模型接收前端傳來的訊息
class ChatRequest(BaseModel):
    message: str

# 初始化最新版的GenAI Client
client = genai.Client(vertexai=True, project="tf-project-489614", location="us-central1")

# 建立 API 路由
@app.post("/api/ai/chat")
async def ai_chat(request: ChatRequest):
    try:
        prompt = f"""
        你是一個專業且友善的英文家教。
        學生的訊息是：「{request.message}」
        請你：
        1. 如果學生輸入中文，請提供自然且道地的英文翻譯，並解釋用法。
        2. 如果學生輸入英文，請檢查文法，並給予鼓勵或提供更進階的說法。
        3. 回答請保持簡潔明瞭，語氣要像朋友一樣輕鬆。
        """
        
        # 呼叫 Vertex AI 產生回應
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt,
        )
        
        return {"status": "success", "reply": response.text}
        
    except Exception as e:
        return {"status": "error", "message": str(e)}