import time

def generate_with_timeout_gemini(model, prompt, generation_config, NUM_RETRY=5):
    for _ in range(NUM_RETRY):
        try:
            return model.generate_content(prompt, generation_config=generation_config)
        except Exception as e:
            if "429" in str(e):
                print("Rate limit exceeded. Sleep for 1 minute")
                time.sleep(60)
            else:
                raise e
    raise Exception("Failed to generate")
