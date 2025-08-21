import json
import requests
import time

DEFAULT_OLLAMA_ENDPOINT = 'http://localhost:11434/api/generate'

def messages_to_prompt(messages):
    return '\n'.join([f"{msg['role']}: {msg['content']}" for msg in messages])

def query_ollama_served_model(payload):
    for _ in range(5):
        try:
            json_payload = json.dumps(payload)
            headers = {'Content-Type': 'application/json'}
            response = json.loads(requests.post(DEFAULT_OLLAMA_ENDPOINT, data=json_payload, headers=headers).text)
            return response['response']
        except Exception as e:
            save_err = e
            if "The server had an error processing your request." in str(e):
                time.sleep(1)
            else:
                break
    raise save_err