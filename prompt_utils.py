
def generate_path(pathdata):
    for i in range(len(pathdata)):
        #pathdata[i]=pathdata[i].replace('\n','')
        pathdata[i]=f"'{pathdata[i]}'"
    path_prompt=' -> '.join(pathdata)
    return path_prompt

def extract_hf_tokens(prompt, generated_text, tokenizer):
    return {
        'prompt_tokens': len(tokenizer.encode(prompt)),
        'completion_tokens': len(tokenizer.encode(generated_text)),
    }