from pathlib import Path
from argparse import ArgumentParser
from tqdm import tqdm
from data_utils import read_jsonl, write_jsonl, add_lineno
from ollama_util import messages_to_prompt, query_ollama_served_model

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("--dataset", type=str, default='leetcode')
    parser.add_argument("--lang", type=str, default='python')
    parser.add_argument("--model", type=str, default='llama3', choices=['llama3', 'llama3.1', 'mistral-nemo', 'qwen2.5-coder'])
    parser.add_argument("--num_tests", type=int, default=10, help='number of tests generated per program')
    parser.add_argument("--temperature", type=float, default=0)
    parser.add_argument("--max_tokens", type=int, default=256)
    return parser.parse_args()

def testgeneration_multiround(args,prompt,system_message=''):
    """generate test cases with multi-round conversation, each time generate one test case"""
    template_append="Generate another test method for the function under test. Your answer must be different from previously-generated test cases, and should cover different statements and branches."
    generated_tests=[]
    messages=[
            {"role": "system", "content": system_message},
            {"role": "user", "content": prompt},
        ]
    for _ in range(args.num_tests):
        generated_test = query_ollama_served_model({
            'model': args.model,
            'prompt': messages_to_prompt(messages),
            'stream': False,
            'options': {
                'temperature': 0.8,
            },
        })
        messages.append({"role": "assistant", "content": generated_test})
        messages.append({"role": "user", "content": template_append})

        generated_tests.append(generated_test)
        print(generated_test)

    return generated_tests


lang_exts={'python':'py', 'java':'java', 'c++':'cpp'}


if __name__=='__main__':
    args=parse_args()
    print('Model:', args.model)
    output_dir = Path('predictions')

    dataset=read_jsonl('data/leetcode-py.jsonl')

    prompt_template=open('prompt/template_base.txt').read()
    system_template=open('prompt/system.txt').read()
    system_message=system_template.format(lang='python')

    data_size=len(dataset)

    testing_results=[]
    for i in tqdm(range(data_size)):
        data=dataset[i]
        func_name=data['func_name']
        desc=data['description']
        code=data['python_solution']
        difficulty=data['difficulty']
        code_withlineno=add_lineno(code)
        target_lines=data['target_lines']

        #generate test case
        prompt=prompt_template.format(lang='python', program=code, description=desc, func_name=func_name)
        generated_tests=testgeneration_multiround(args,prompt,system_message)
                   
        testing_data={'task_num':data['task_num'],'task_title':data['task_title'],'func_name':func_name,'difficulty':difficulty,'code':code,'tests':generated_tests}
        testing_results.append(testing_data)
        print('<<<<----------------------------------------->>>>')
        write_jsonl(testing_results, output_dir / f'totalcov_{args.model}_temp.jsonl')

    write_jsonl(testing_results, output_dir / f'totalcov_{args.model}.jsonl')
