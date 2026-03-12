FROM python:3.10-slim
WORKDIR /app

# 防止 Python 產生 pyc 檔，並即時輸出 log
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8000

# 啟動指令
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]