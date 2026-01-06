import json
import os
import transformers
import torch
import textwrap
from argparse import ArgumentParser
from tqdm import tqdm
from pathlib import Path

from transformers import LlamaForCausalLM, CodeLlamaTokenizer, AutoTokenizer, AutoModelForCausalLM
from transformers import pipeline
access_token=os.getenv("HUGGINGFACE_TOKEN")

from data_utils import read_jsonl, write_jsonl, add_lineno
from prompt_utils import extract_hf_tokens

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("--dataset", type=str, default='leetcode')
    parser.add_argument("--lang", type=str, default='python', choices=['python', 'java', 'c++'])
    parser.add_argument("--model", type=str, default='meta-llama/Meta-Llama-3-8B-Instruct')
    parser.add_argument("--covmode", type=str, default='line', choices=['line', 'branch'], help='cover targets at line level or branch level')
    parser.add_argument("--max_tokens", type=int, default=256)
    parser.add_argument("--temperature", type=float, default=1e-5)
    parser.add_argument("--index", type=int, default=0)
    return parser.parse_args()

model_list=[
    "meta-llama/Meta-Llama-3.1-8B-Instruct",
    "meta-llama/Meta-Llama-3-8B-Instruct",
    "Qwen/Qwen2.5-Coder-7B-Instruct"
    "mistralai/Mistral-Nemo-Instruct-2407",
    "microsoft/phi-4",
]

#models do not support system message
models_nosys=['google/gemma-1.1-7b-it',
            'bigcode/starcoder2-15b-instruct-v0.1',
            'mistralai/Mistral-7B-Instruct-v0.3']


if __name__=='__main__':
    args=parse_args()
    model_abbrv=args.model.split('/')[-1]
    print('Model:', model_abbrv)
    print('task:', args.covmode)
    output_dir = Path('predictions')

    prompt_template=open('prompt/template_line.txt').read()
    prompt_template_branch=open('prompt/template_branch.txt').read()
    system_template=open('prompt/system.txt').read()
    system_message=system_template.format(lang='python')

    dataset=read_jsonl('data/leetcode-py.jsonl')

    model = AutoModelForCausalLM.from_pretrained(args.model, token=access_token, torch_dtype=torch.bfloat16, trust_remote_code=True, device_map='auto')
    tokenizer = AutoTokenizer.from_pretrained(args.model, token=access_token, torch_dtype=torch.bfloat16, trust_remote_code=True, device_map='auto')
    generator = pipeline("text-generation",model=model, tokenizer=tokenizer, torch_dtype=torch.bfloat16, device_map='auto', token=access_token)

    data_size=len(dataset)
    testing_results=[]
    print('number of samples:',len(dataset))
    generation_costs = {}

    for i in tqdm(range(data_size)):
        data=dataset[i]
        func_name=data['func_name']
        desc=data['description']
        code=data['python_solution']
        difficulty=data['difficulty']
        code_withlineno=add_lineno(code)           
        
        #generate test case
        if args.covmode=='line':
            target_lines=data['target_lines']
            tests={}
            print(data['task_num'],target_lines)
            for lineno in target_lines: #line number to be tested
                code_lines=code.split('\n')
                target_line=code_lines[lineno-1]
                target_line_withlineno=f'{lineno}: {target_line}'

                code_input=code_withlineno
                line_input=target_line_withlineno

                prompt=prompt_template.format(lang='python', program=code_input, description=desc, func_name=func_name, lineno=line_input)
                if args.model in models_nosys: #models don't support system message
                    messages=[{"role": "user", "content": system_message+prompt}]
                else:
                    messages=[
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": prompt},
                ]
                prompt = generator.tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
                
                generated=generator(prompt, 
                                    max_new_tokens=args.max_tokens, 
                                    temperature=args.temperature, 
                                    return_full_text=False)
                generated_test=generated[0]['generated_text']
                generation_costs[f"{data['task_num']}_{lineno}"] = extract_hf_tokens(prompt, generated_test, tokenizer)
                if generated_test.startswith('  '): #remove extra indents (encountered in codellama)
                    generated_test=textwrap.dedent(generated_test)
                print(generated_test)
                tests[lineno]=generated_test
                print('----------')        
            testing_data={'task_num':data['task_num'],'task_title':data['task_title'],'func_name':func_name,'difficulty':difficulty,'code':code,'tests':tests}
        
        elif args.covmode=='branch':
            tests_branch=[]
            print(data['task_num'])
            branches=data['blocks']
            for branch in branches:
                print(branch)
                startline=branch['start']
                endline=branch['end']
                
                code_input=code_withlineno

                split_lines=code_withlineno.split('\n')
                target_lines=split_lines[startline-1:endline]
                target_branch_withlineno='\n'.join(target_lines)
                branch_input="\n'''\n"+target_branch_withlineno+"\n'''"

                prompt=prompt_template_branch.format(lang='python', program=code_input, description=desc, func_name=func_name, branch=branch_input)
                if args.model in models_nosys: #models don't support system message
                    messages=[{"role": "user", "content": system_message+prompt}]
                else:
                    messages=[
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": prompt},
                ]
                prompt = generator.tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
                
                generated=generator(prompt, 
                                    max_new_tokens=args.max_tokens, 
                                    temperature=args.temperature, 
                                    return_full_text=False)
                generated_test=generated[0]['generated_text']
                generation_costs[f"{data['task_num']}_{startline}_{endline}"] = extract_hf_tokens(prompt, generated_test, tokenizer)
                if generated_test.startswith('  '): #remove extra indents (encountered in codellama)
                    generated_test=textwrap.dedent(generated_test)
                print(generated_test)
                generatedtest_branch={'start':startline,'end':endline,'test':generated_test}
                tests_branch.append(generatedtest_branch)
            testing_data={'task_num':data['task_num'],'task_title':data['task_title'],'func_name':func_name,'difficulty':difficulty,'code':code,'tests':tests_branch}
        
        testing_results.append(testing_data)
        print('<<<<----------------------------------------->>>>')
        write_jsonl(testing_results, output_dir / f'{args.covmode}cov_{model_abbrv}_temp.jsonl')
    
    if args.index:
        output_path = output_dir / f'{args.covmode}cov_{model_abbrv}_{args.index}.jsonl'
        cost_path = output_dir / f'{args.covmode}cov_{model_abbrv}_cost_{args.index}.json'
    else: 
        output_path = output_dir / f'{args.covmode}cov_{model_abbrv}.jsonl'
        cost_path = output_dir / f'{args.covmode}cov_{model_abbrv}_cost.json'
    
    write_jsonl(testing_results, output_path)
    with open(cost_path, 'w') as f:
        json.dump(generation_costs, f, indent=2)
