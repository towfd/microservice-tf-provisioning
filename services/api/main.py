from fastapi import FastAPI

app = FastAPI(title="AI Translation API", version="0.1.0")

# 健康檢查 (Health Check) - 給我們自己還有未來的 K8s 測試用的
@app.get("/")
def read_root():
    return {"status": "ok", "message": "FastAPI is running inside Docker!!"}

# 預留的翻譯接口 - 先用假資料代替
@app.post("/api/translate")
def translate_text():
    return {
        "original": "Hello World",
        "translated": "你好，世界 (Mocked by API)"
    }