import json
from argparse import ArgumentParser
from tqdm import tqdm
from pathlib import Path
from data_utils import read_jsonl, write_jsonl, add_lineno
from prompt_utils import generate_path

from ollama_util import query_ollama_served_model

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("--dataset", type=str, default='leetcode')
    parser.add_argument("--lang", type=str, default='python')
    parser.add_argument("--model", type=str, default='llama3')
    parser.add_argument("--max_tokens", type=int, default=256)
    parser.add_argument("--temperature", type=float, default=0)
    return parser.parse_args()

def generate_completion(args,prompt,system_message=''):
    code_output, costs = query_ollama_served_model({
        'model': args.model,
        'prompt': f'{system_message}\n{prompt}',
        'stream': False,
        'options': {
            'temperature': args.temperature, 
        },
    })
    return code_output, costs

if __name__=='__main__':
    args=parse_args()
    print('Model:', args.model)
    output_dir = Path('predictions')

    prompt_template=open('prompt/template_path.txt').read()
    system_template=open('prompt/system.txt').read()
    system_message=system_template.format(lang='python')

    dataset=read_jsonl('data/leetcode-py-instrumented.jsonl')
    path_dataset=read_jsonl('data/tgt_paths.jsonl')
    data_size=len(dataset)
    testing_results=[]
    generation_costs = {}

    for i in tqdm(range(data_size)):
        data=dataset[i]
        func_name=data['func_name']
        desc=data['description']
        code=data['python_solution']
        difficulty=data['difficulty']
        code_withlineno=add_lineno(code)           

        log_paths=path_dataset[i]['sampled_paths']
        condition_paths=path_dataset[i]['sampled_condition_paths']
        generated_path_tests=[]
        for j in range(len(log_paths)):
            log_path=log_paths[j]
            condition_path=condition_paths[j]
            #print(log_path, condition_path)
            path_prompt=generate_path(condition_path)

            prompt=prompt_template.format(func_name=func_name, description=desc, program=code_withlineno, path=path_prompt)

            generated_test, costs=generate_completion(args,prompt,system_message)
            print(generated_test)
            generated_path_tests.append(generated_test)
            generation_costs[f"{data['task_num']}_{j}"] = costs
        testing_data={'task_num':data['task_num'],'task_title':data['task_title'],'func_name':func_name,'difficulty':difficulty,'code':code,'tests':generated_path_tests}
        testing_results.append(testing_data)

    write_jsonl(testing_results, output_dir / f'pathcov_{args.model}.jsonl')
    with open(output_dir / f'pathcov_{args.model}_cost.json', 'w') as f:
        json.dump(generation_costs, f, indent=2)