#!/bin/bash
NUM_SAMPLES=10
WEAK_MODELS=("meta-llama/Meta-Llama-3-8B-Instruct" "meta-llama/Meta-Llama-3.1-8B-Instruct" "mistralai/Mistral-Nemo-Instruct-2407" "microsoft/phi-4" "Qwen/Qwen2.5-Coder-7B-Instruct")

for i in $(seq 1 "$NUM_SAMPLES"); do
    for weak_model in "${WEAK_MODELS[@]}"; do
        python generate_cov_hf.py  --index $i --model "$weak_model" --num_tests 10
        python generate_targetcov_hf.py  --index $i --covmode line --model "$weak_model" 
        python generate_targetcov_hf.py  --index $i --covmode branch --model "$weak_model" 
        python generate_pathcov_hf.py  --index $i --model "$weak_model" 
    done

    python generate_cov_openai.py  --index $i --model gpt-4o --num_tests 10
    python generate_targetcov_openai.py  --index $i --covmode line --model gpt-4o 
    python generate_targetcov_openai.py  --index $i --covmode branch --model gpt-4o
    python generate_pathcov_openai.py  --index $i --model gpt-4o
    
    python generate_cov_gemini.py  --index $i --model models/gemini-2.5-flash-lite --num_tests 10
    python generate_targetcov_gemini.py  --index $i --covmode line --model models/gemini-2.5-flash-lite 
    python generate_targetcov_gemini.py  --index $i --covmode branch --model models/gemini-2.5-flash-lite 
    python generate_pathcov_gemini.py  --index $i --model models/gemini-2.5-flash-lite 
done