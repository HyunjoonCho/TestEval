#!/bin/bash

python generate_cov_ollama.py --model llama3 --num_tests 20
python generate_cov_ollama.py --model llama3.1 --num_tests 20
python generate_cov_ollama.py --model mistral-nemo --num_tests 20
python generate_cov_ollama.py --model qwen2.5-coder --num_tests 20

python generate_targetcov_ollama.py --covmode line --model llama3
python generate_targetcov_ollama.py --covmode line --model llama3.1
python generate_targetcov_ollama.py --covmode line --model mistral-nemo
python generate_targetcov_ollama.py --covmode line --model qwen2.5-coder

python generate_targetcov_ollama.py --covmode branch --model llama3
python generate_targetcov_ollama.py --covmode branch --model llama3.1
python generate_targetcov_ollama.py --covmode branch --model mistral-nemo
python generate_targetcov_ollama.py --covmode branch --model qwen2.5-coder

python generate_pathcov_ollama.py --model llama3
python generate_pathcov_ollama.py --model llama3.1
python generate_pathcov_ollama.py --model mistral-nemo 
python generate_pathcov_ollama.py --model qwen2.5-coder 
