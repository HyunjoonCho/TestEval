#!/bin/bash
NUM_SAMPLES=10
MODELS=("Meta-Llama-3-8B-Instruct" "Meta-Llama-3.1-8B-Instruct" "Mistral-Nemo-Instruct-2407" "Qwen2.5-Coder-7B-Instruct" "phi-4" "gpt-4o" "gemini-2.5-flash-lite")

for i in $(seq 1 "$NUM_SAMPLES"); do
    for model in "${MODELS[@]}"; do
        python format.py --mode overall --path totalcov_"$model"_"$i".jsonl
        python eval_overall.py --path totalcov_"$model"_"$i"_format.jsonl > predictions/totalcov_"$model"_"$i"_output.txt

        python format.py --mode line --path linecov_"$model"_"$i".jsonl
        python eval_linecov.py --path linecov_"$model"_"$i"_format.jsonl > predictions/linecov_"$model"_"$i"_output.txt

        python format.py --mode branch --path branchcov_"$model"_"$i".jsonl
        python eval_branchcov.py --path branchcov_"$model"_"$i"_format.jsonl > predictions/branchcov_"$model"_"$i"_output.txt

        python format.py --mode overall --path pathcov_"$model"_"$i".jsonl
        python eval_pathcov.py --path pathcov_"$model"_"$i"_format.jsonl > predictions/pathcov_"$model"_"$i"_output.txt
    done
done