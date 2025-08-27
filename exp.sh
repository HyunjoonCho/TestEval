#!/bin/bash

python generate_targetcov_ollama.py --covmode line --model llama3
python generate_targetcov_ollama.py --covmode line --model llama3.1
python generate_targetcov_ollama.py --covmode line --model mistral-nemo
python generate_targetcov_ollama.py --covmode line --model qwen2.5-coder
python generate_targetcov_openai.py --covmode line --model gpt-4o 

python generate_targetcov_ollama.py --covmode branch --model llama3
python generate_targetcov_ollama.py --covmode branch --model llama3.1
python generate_targetcov_ollama.py --covmode branch --model mistral-nemo
python generate_targetcov_ollama.py --covmode branch --model qwen2.5-coder
python generate_targetcov_openai.py --covmode branch --model gpt-4o

python generate_pathcov_ollama.py --model llama3
python generate_pathcov_ollama.py --model llama3.1
python generate_pathcov_ollama.py --model mistral-nemo 
python generate_pathcov_ollama.py --model qwen2.5-coder 
python generate_pathcov_openai.py --model gpt-4o

# evaluate

# Targeted Line Coverage
python format.py --mode line --path linecov_llama3.jsonl
python eval_linecov.py --path linecov_llama3_format.jsonl > predictions/linecov_llama3_output.txt

python format.py --mode line --path linecov_llama3.1.jsonl
python eval_linecov.py --path linecov_llama3.1_format.jsonl > predictions/linecov_llama3.1_output.txt

python format.py --mode line --path linecov_mistral-nemo.jsonl
python eval_linecov.py --path linecov_mistral-nemo_format.jsonl > predictions/linecov_mistral-nemo_output.txt

python format.py --mode line --path linecov_qwen2.5-coder.jsonl
python eval_linecov.py --path linecov_qwen2.5-coder_format.jsonl > predictions/linecov_qwen2.5-coder_output.txt

python format.py --mode line --path linecov_gpt-4o.jsonl
python eval_linecov.py --path linecov_gpt-4o_format.jsonl > predictions/linecov_gpt-4o_output.txt

# Targeted Branch Coverage
python format.py --mode branch --path branchcov_llama3.jsonl
python eval_branchcov.py --path branchcov_llama3_format.jsonl > predictions/branchcov_llama3_output.txt

python format.py --mode branch --path branchcov_llama3.1.jsonl
python eval_branchcov.py --path branchcov_llama3.1_format.jsonl > predictions/branchcov_llama3.1_output.txt

python format.py --mode branch --path branchcov_mistral-nemo.jsonl
python eval_branchcov.py --path branchcov_mistral-nemo_format.jsonl > predictions/branchcov_mistral-nemo_output.txt

python format.py --mode branch --path branchcov_qwen2.5-coder.jsonl
python eval_branchcov.py --path branchcov_qwen2.5-coder_format.jsonl > predictions/branchcov_qwen2.5-coder_output.txt

python format.py --mode branch --path branchcov_gpt-4o.jsonl
python eval_branchcov.py --path branchcov_gpt-4o_format.jsonl > predictions/branchcov_gpt-4o_output.txt

# Targeted Branch Coverage
python format.py --mode overall --path pathcov_llama3.jsonl
python eval_pathcov.py --path pathcov_llama3_format.jsonl > predictions/pathcov_llama3_output.txt

python format.py --mode overall --path pathcov_llama3.1.jsonl
python eval_pathcov.py --path pathcov_llama3.1_format.jsonl > predictions/pathcov_llama3.1_output.txt

python format.py --mode overall --path pathcov_mistral-nemo.jsonl
python eval_pathcov.py --path pathcov_mistral-nemo_format.jsonl > predictions/pathcov_mistral-nemo_output.txt

python format.py --mode overall --path pathcov_qwen2.5-coder.jsonl
python eval_pathcov.py --path pathcov_qwen2.5-coder_format.jsonl > predictions/pathcov_qwen2.5-coder_output.txt

python format.py --mode overall --path pathcov_gpt-4o.jsonl
python eval_pathcov.py --path pathcov_gpt-4o_format.jsonl > predictions/pathcov_gpt-4o_output.txt
