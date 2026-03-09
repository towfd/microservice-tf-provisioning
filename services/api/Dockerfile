FROM python:3.11-slim
# 設定容器內的工作目錄
WORKDIR /app
# 快取
COPY requirements.txt .
# 安裝依賴套件
RUN pip install --no-cache-dir -r requirements.txt
# 複製所有程式碼
COPY . .
# 宣告這個容器對外 Port
EXPOSE 8000
# 啟動 FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]