#!/bin/bash

# python generate_cov_hf.py --model meta-llama/Meta-Llama-3-8B-Instruct --num_tests 10
# python generate_cov_hf.py --model meta-llama/Meta-Llama-3.1-8B-Instruct --num_tests 10
# python generate_cov_hf.py --model mistralai/Mistral-Nemo-Instruct-2407 --num_tests 10
# python generate_cov_hf.py --model Qwen/Qwen2.5-Coder-7B-Instruct --num_tests 10
# python generate_cov_hf.py --model microsoft/phi-4 --num_tests 10
# python generate_cov_openai.py --model gpt-4o --num_tests 10
python generate_cov_gemini.py --model models/gemini-2.5-flash-lite --num_tests 10

# python generate_targetcov_hf.py --covmode line --model meta-llama/Meta-Llama-3-8B-Instruct
# python generate_targetcov_hf.py --covmode line --model meta-llama/Meta-Llama-3.1-8B-Instruct
# python generate_targetcov_hf.py --covmode line --model mistralai/Mistral-Nemo-Instruct-2407
# python generate_targetcov_hf.py --covmode line --model Qwen/Qwen2.5-Coder-7B-Instruct
# python generate_targetcov_hf.py --covmode line --model microsoft/phi-4 
# python generate_targetcov_openai.py --covmode line --model gpt-4o 
# python generate_targetcov_gemini.py --covmode line --model models/gemini-2.5-flash-lite 

# python generate_targetcov_hf.py --covmode branch --model meta-llama/Meta-Llama-3-8B-Instruct
# python generate_targetcov_hf.py --covmode branch --model meta-llama/Meta-Llama-3.1-8B-Instruct
# python generate_targetcov_hf.py --covmode branch --model mistralai/Mistral-Nemo-Instruct-2407
# python generate_targetcov_hf.py --covmode branch --model Qwen/Qwen2.5-Coder-7B-Instruct
# python generate_targetcov_hf.py --covmode branch --model microsoft/phi-4
# python generate_targetcov_openai.py --covmode branch --model gpt-4o
# python generate_targetcov_gemini.py --covmode branch --model models/gemini-2.5-flash-lite 

# python generate_pathcov_hf.py --model meta-llama/Meta-Llama-3-8B-Instruct
# python generate_pathcov_hf.py --model meta-llama/Meta-Llama-3.1-8B-Instruct
# python generate_pathcov_hf.py --model mistralai/Mistral-Nemo-Instruct-2407 
# python generate_pathcov_hf.py --model Qwen/Qwen2.5-Coder-7B-Instruct 
# python generate_pathcov_hf.py --model microsoft/phi-4 
# python generate_pathcov_openai.py --model gpt-4o
# python generate_pathcov_gemini.py --model models/gemini-2.5-flash-lite 

# evaluate

# Total Coverage
# python format.py --mode overall --path totalcov_Meta-Llama-3-8B-Instruct.jsonl
# python eval_overall.py --path totalcov_Meta-Llama-3-8B-Instruct_format.jsonl > predictions/totalcov_Meta-Llama-3-8B-Instruct_output.txt

# python format.py --mode overall --path totalcov_Meta-Llama-3.1-8B-Instruct.jsonl
# python eval_overall.py --path totalcov_Meta-Llama-3.1-8B-Instruct_format.jsonl > predictions/totalcov_Meta-Llama-3.1-8B-Instruct_output.txt

# python format.py --mode overall --path totalcov_Mistral-Nemo-Instruct-2407.jsonl
# python eval_overall.py --path totalcov_Mistral-Nemo-Instruct-2407_format.jsonl > predictions/totalcov_Mistral-Nemo-Instruct-2407_output.txt

# python format.py --mode overall --path totalcov_Qwen2.5-Coder-7B-Instruct.jsonl
# python eval_overall.py --path totalcov_Qwen2.5-Coder-7B-Instruct_format.jsonl > predictions/totalcov_Qwen2.5-Coder-7B-Instruct_output.txt

# python format.py --mode overall --path totalcov_phi-4.jsonl
# python eval_overall.py --path totalcov_phi-4_format.jsonl > predictions/totalcov_phi-4_output.txt

# python format.py --mode overall --path totalcov_gpt-4o.jsonl
# python eval_overall.py --path totalcov_gpt-4o_format.jsonl > predictions/totalcov_gpt-4o_output.txt

python format.py --mode overall --path totalcov_gemini-2.5-flash-lite.jsonl
python eval_overall.py --path totalcov_gemini-2.5-flash-lite_format.jsonl > predictions/totalcov_gemini-2.5-flash-lite_output.txt


# Targeted Line Coverage
# python format.py --mode line --path linecov_Meta-Llama-3-8B-Instruct.jsonl
# python eval_linecov.py --path linecov_Meta-Llama-3-8B-Instruct_format.jsonl > predictions/linecov_Meta-Llama-3-8B-Instruct_output.txt

# python format.py --mode line --path linecov_Meta-Llama-3.1-8B-Instruct.jsonl
# python eval_linecov.py --path linecov_Meta-Llama-3.1-8B-Instruct_format.jsonl > predictions/linecov_Meta-Llama-3.1-8B-Instruct_output.txt

# python format.py --mode line --path linecov_Mistral-Nemo-Instruct-2407.jsonl
# python eval_linecov.py --path linecov_Mistral-Nemo-Instruct-2407_format.jsonl > predictions/linecov_Mistral-Nemo-Instruct-2407_output.txt

# python format.py --mode line --path linecov_Qwen2.5-Coder-7B-Instruct.jsonl
# python eval_linecov.py --path linecov_Qwen2.5-Coder-7B-Instruct_format.jsonl > predictions/linecov_Qwen2.5-Coder-7B-Instruct_output.txt

# python format.py --mode line --path linecov_phi-4.jsonl
# python eval_linecov.py --path linecov_phi-4_format.jsonl > predictions/linecov_phi-4_output.txt

# python format.py --mode line --path linecov_gpt-4o.jsonl
# python eval_linecov.py --path linecov_gpt-4o_format.jsonl > predictions/linecov_gpt-4o_output.txt

# python format.py --mode line --path linecov_gemini-2.5-flash-lite.jsonl
# python eval_linecov.py --path linecov_gemini-2.5-flash-lite_format.jsonl > predictions/linecov_gemini-2.5-flash-lite_output.txt

# Targeted Branch Coverage
# python format.py --mode branch --path branchcov_Meta-Llama-3-8B-Instruct.jsonl
# python eval_branchcov.py --path branchcov_Meta-Llama-3-8B-Instruct_format.jsonl > predictions/branchcov_Meta-Llama-3-8B-Instruct_output.txt

# python format.py --mode branch --path branchcov_Meta-Llama-3.1-8B-Instruct.jsonl
# python eval_branchcov.py --path branchcov_Meta-Llama-3.1-8B-Instruct_format.jsonl > predictions/branchcov_Meta-Llama-3.1-8B-Instruct_output.txt

# python format.py --mode branch --path branchcov_Mistral-Nemo-Instruct-2407.jsonl
# python eval_branchcov.py --path branchcov_Mistral-Nemo-Instruct-2407_format.jsonl > predictions/branchcov_Mistral-Nemo-Instruct-2407_output.txt

# python format.py --mode branch --path branchcov_Qwen2.5-Coder-7B-Instruct.jsonl
# python eval_branchcov.py --path branchcov_Qwen2.5-Coder-7B-Instruct_format.jsonl > predictions/branchcov_Qwen2.5-Coder-7B-Instruct_output.txt

# python format.py --mode branch --path branchcov_phi-4.jsonl
# python eval_branchcov.py --path branchcov_phi-4_format.jsonl > predictions/branchcov_phi-4_output.txt

# python format.py --mode branch --path branchcov_gpt-4o.jsonl
# python eval_branchcov.py --path branchcov_gpt-4o_format.jsonl > predictions/branchcov_gpt-4o_output.txt

# python format.py --mode branch --path branchcov_gemini-2.5-flash-lite.jsonl
# python eval_branchcov.py --path branchcov_gemini-2.5-flash-lite_format.jsonl > predictions/branchcov_gemini-2.5-flash-lite_output.txt

# Targeted Branch Coverage
# python format.py --mode overall --path pathcov_Meta-Llama-3-8B-Instruct.jsonl
# python eval_pathcov.py --path pathcov_Meta-Llama-3-8B-Instruct_format.jsonl > predictions/pathcov_Meta-Llama-3-8B-Instruct_output.txt

# python format.py --mode overall --path pathcov_Meta-Llama-3.1-8B-Instruct.jsonl
# python eval_pathcov.py --path pathcov_Meta-Llama-3.1-8B-Instruct_format.jsonl > predictions/pathcov_Meta-Llama-3.1-8B-Instruct_output.txt

# python format.py --mode overall --path pathcov_Mistral-Nemo-Instruct-2407.jsonl
# python eval_pathcov.py --path pathcov_Mistral-Nemo-Instruct-2407_format.jsonl > predictions/pathcov_Mistral-Nemo-Instruct-2407_output.txt

# python format.py --mode overall --path pathcov_Qwen2.5-Coder-7B-Instruct.jsonl
# python eval_pathcov.py --path pathcov_Qwen2.5-Coder-7B-Instruct_format.jsonl > predictions/pathcov_Qwen2.5-Coder-7B-Instruct_output.txt

# python format.py --mode overall --path pathcov_phi-4.jsonl
# python eval_pathcov.py --path pathcov_phi-4_format.jsonl > predictions/pathcov_phi-4_output.txt

# python format.py --mode overall --path pathcov_gpt-4o.jsonl
# python eval_pathcov.py --path pathcov_gpt-4o_format.jsonl > predictions/pathcov_gpt-4o_output.txt

# python format.py --mode overall --path pathcov_gemini-2.5-flash-lite.jsonl
# python eval_pathcov.py --path pathcov_gemini-2.5-flash-lite_format.jsonl > predictions/pathcov_gemini-2.5-flash-lite_output.txt
