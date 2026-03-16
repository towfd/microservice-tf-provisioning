<template>
  <div class="chat-container">
    <!-- 頂部導覽列 -->
    <header class="chat-header">
      <h2>🤖 AI 英文專屬家教</h2>
      <p>隨時隨地，開口練英文</p>
    </header>

    <!-- 對話顯示區 -->
    <div class="chat-box" ref="chatBox">
      <div 
        v-for="(msg, index) in messages" 
        :key="index" 
        :class="['message-wrapper', msg.role]"
      >
        <div class="message-bubble">
          {{ msg.content }}
        </div>
      </div>
      
      <!-- 載入中的動畫提示 -->
      <div v-if="isLoading" class="message-wrapper ai">
        <div class="message-bubble loading">
          思考中...
        </div>
      </div>
    </div>

    <!-- 輸入區 -->
    <div class="input-area">
      <input 
        v-model="userInput" 
        @keyup.enter="sendMessage" 
        type="text" 
        placeholder="輸入你想說的英文或中文..." 
        :disabled="isLoading"
      />
      <button @click="sendMessage" :disabled="isLoading || !userInput.trim()">
        發送
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue';

// 聊天紀錄狀態 (預設先給一句 AI 的開場白)
const messages = ref([
  { role: 'ai', content: '哈囉！我是你的 AI 英文家教。想練習對話，還是有不懂的句子想問我呢？' }
]);
const userInput = ref('');
const isLoading = ref(false);
const chatBox = ref(null);

const API_URL = 'http://35.221.184.82/api/ai/chat'; 

// 讓視窗永遠滾動到最底部的功能
const scrollToBottom = async () => {
  await nextTick();
  if (chatBox.value) {
    chatBox.value.scrollTop = chatBox.value.scrollHeight;
  }
};

// 發送訊息到你的 FastAPI 後端
const sendMessage = async () => {
  if (!userInput.value.trim()) return;

  const text = userInput.value;
  // 把使用者的訊息推入畫面
  messages.value.push({ role: 'user', content: text });
  userInput.value = '';
  isLoading.value = true;
  scrollToBottom();

  try {
    // 呼叫你的 FastAPI
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: text })
    });

    const data = await response.json();
    
    // AI 的回覆推入畫面
    if (data.status === 'success') {
      messages.value.push({ role: 'ai', content: data.reply });
    } else {
      messages.value.push({ role: 'ai', content: '抱歉，我的大腦當機了：' + data.message });
    }
  } catch (error) {
    messages.value.push({ role: 'ai', content: '連線失敗！請檢查 API 是否正常運作。' });
    console.error(error);
  } finally {
    isLoading.value = false;
    scrollToBottom();
  }
};
</script>

<style scoped>
.chat-container {
  max-width: 500px;
  margin: 20px auto;
  border-radius: 15px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  height: 80vh;
  font-family: 'Arial', sans-serif;
  background-color: #f8f9fa;
}

.chat-header {
  background: linear-gradient(135deg, #42b883, #35495e);
  color: white;
  padding: 15px 20px;
  text-align: center;
}

.chat-header h2 { margin: 0; font-size: 1.2rem; }
.chat-header p { margin: 5px 0 0; font-size: 0.8rem; opacity: 0.8; }

.chat-box {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.message-wrapper {
  display: flex;
  width: 100%;
}

.message-wrapper.user { justify-content: flex-end; }
.message-wrapper.ai { justify-content: flex-start; }

.message-bubble {
  max-width: 75%;
  padding: 12px 16px;
  border-radius: 20px;
  font-size: 0.95rem;
  line-height: 1.4;
  white-space: pre-wrap;
}

.user .message-bubble {
  background-color: #42b883;
  color: white;
  border-bottom-right-radius: 5px;
}

.ai .message-bubble {
  background-color: white;
  color: #333;
  border-bottom-left-radius: 5px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.loading { color: #888; font-style: italic; }

.input-area {
  display: flex;
  padding: 15px;
  background-color: white;
  border-top: 1px solid #eee;
}

.input-area input {
  flex: 1;
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 25px;
  outline: none;
  font-size: 0.95rem;
}

.input-area input:focus { border-color: #42b883; }

.input-area button {
  background-color: #42b883;
  color: white;
  border: none;
  border-radius: 25px;
  padding: 0 20px;
  margin-left: 10px;
  cursor: pointer;
  font-weight: bold;
  transition: 0.2s;
}

.input-area button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>