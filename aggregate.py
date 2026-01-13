import json
from pathlib import Path

base_dir = Path('predictions')

def initialize_results_dict(task, model):
    with open(base_dir / f"{task}_{model}_1_result.json") as f:
        result = json.load(f)
    return dict([(task_id, 0.0) for task_id in result])

def load_value_for_task_id(task, result, task_id):
    if task == 'totalcov':
        return result[task_id]["1"]["line_cov"] if "1" in result[task_id] else 0.0
    elif task == 'linecov':
        return float(result[task_id])
    elif task == 'branchcov':
        return float(result[task_id]["covered"])
    else: #pathcov
        return float(result[task_id] == 1.0)

if __name__ == "__main__":
    models = [
        "gpt-4o",
        "gemini-2.5-flash-lite",
        "Meta-Llama-3-8B-Instruct",
        "Meta-Llama-3.1-8B-Instruct",
        "Mistral-Nemo-Instruct-2407",
        "phi-4",
        "Qwen2.5-Coder-7B-Instruct",
    ]
    
    task_prefixes = ['totalcov', 'linecov', 'branchcov', 'pathcov']
        
    for task in task_prefixes:
        for model in models:
            aggregated_results = initialize_results_dict(task, model)
            try:
                for i in range(1, 11):
                    with open(base_dir / f"{task}_{model}_{i}_result.json") as f:
                        result = json.load(f) 
                    for task_id in result:
                        aggregated_results[task_id] += load_value_for_task_id(task, result, task_id)
                
                aggregated_results = dict([(key, aggregated_results[key] / 10) for key in aggregated_results])
                with open(base_dir / "agg" / f"{task}_{model}_result_R10.json", 'w') as f:
                    json.dump(aggregated_results, f, indent=2)
            except Exception as e:
                print(str(e))