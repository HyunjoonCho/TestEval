#!/bin/bash

python generate_cov_hf.py --index 6 --model microsoft/phi-4 --num_tests 10
python format.py --mode overall --path totalcov_phi-4_6.jsonl
python eval_overall.py --path totalcov_phi-4_6_format.jsonl > predictions/totalcov_phi-4_6_output.txt

python generate_targetcov_openai.py --index 8 --covmode line --model gpt-4o 
python format.py --mode line --path linecov_gpt-4o_8.jsonl
python eval_linecov.py --path linecov_gpt-4o_8_format.jsonl > predictions/linecov_gpt-4o_8_output.txt

python generate_targetcov_gemini.py --index 8 --covmode line --model models/gemini-2.5-flash-lite 
python format.py --mode line --path linecov_gemini-2.5-flash-lite_8.jsonl
python eval_linecov.py --path linecov_gemini-2.5-flash-lite_8_format.jsonl > predictions/linecov_gemini-2.5-flash-lite_8_output.txt

python generate_targetcov_openai.py --index 8 --covmode branch --model gpt-4o
python format.py --mode branch --path branchcov_gpt-4o_8.jsonl
python eval_branchcov.py --path branchcov_gpt-4o_8_format.jsonl > predictions/branchcov_gpt-4o_8_output.txt

python generate_pathcov_openai.py --index 10 --model gpt-4o
python format.py --mode overall --path pathcov_gpt-4o_10.jsonl
python eval_pathcov.py --path pathcov_gpt-4o_10_format.jsonl > predictions/pathcov_gpt-4o_10_output.txt

python generate_pathcov_hf.py --index 6 --model mistralai/Mistral-Nemo-Instruct-2407
python format.py --mode overall --path pathcov_Mistral-Nemo-Instruct-2407_6.jsonl
python eval_pathcov.py --path pathcov_Mistral-Nemo-Instruct-2407_6_format.jsonl > predictions/pathcov_Mistral-Nemo-Instruct-2407_6_output.txt

python generate_pathcov_hf.py --index 6 --model microsoft/phi-4
python format.py --mode overall --path pathcov_phi-4_6.jsonl
python eval_pathcov.py --path pathcov_phi-4_6_format.jsonl > predictions/pathcov_phi-4_6_output.txt