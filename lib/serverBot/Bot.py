# Python Backend

# 1. **Setup Python Project**:
#    - Install Flask using `pip install flask`.
#    - Install any chatbot library (e.g., `transformers` for HuggingFace models).

# 2. **Python Code**:

# ```python
from flask import Flask, request, jsonify
from transformers import AutoModelForCausalLM, AutoTokenizer

app = Flask(__name__)

# Load Pre-trained Model and Tokenizer
model_name = "microsoft/DialoGPT-small"
model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json.get('message', '')

    if not user_message:
        return jsonify({'response': 'Please provide a message.'}), 400

    inputs = tokenizer.encode(user_message + tokenizer.eos_token, return_tensors="pt")
    outputs = model.generate(inputs, max_length=100, pad_token_id=tokenizer.eos_token_id)
    bot_response = tokenizer.decode(outputs[:, inputs.shape[-1]:][0], skip_special_tokens=True)

    return jsonify({'response': bot_response})

if __name__ == '__main__':
    app.run(debug=True)

