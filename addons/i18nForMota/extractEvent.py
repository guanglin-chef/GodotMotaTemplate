import os
import re
import json

SOURCE_EXTENSIONS = ['.tscn']

PATTERN = re.compile(r'([\u4e00-\u9fa5\uff00-\uffef\u3000-\u303f\u2026]+)')

translations = {}

def scan_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if any(file.endswith(ext) for ext in SOURCE_EXTENSIONS):
                filepath = os.path.join(root, file)
                extract_translations(filepath)

def extract_translations(filepath):
    print("extract:",filepath)
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if not line.startswith('text = "{'):
                continue
            content=line
            if line == 'text = "{\n':
                ii=i
                content = line[:-1]
                while lines[ii]!='}"\n':
                    ii+=1
                    content+=lines[ii][:-1]
            matches = PATTERN.findall(content)
            if matches:
                namespace = {}
                exec(content, namespace)
                lineobj=json.loads(namespace['text'])
                words=[]
                def traverse_leaves(obj, path=""):
                    if PATTERN.findall(str(path)):words.append(str(path))
                    if isinstance(obj, dict):
                        for key, value in obj.items():
                            traverse_leaves(value, key)
                    elif isinstance(obj, list):
                        for i, item in enumerate(obj):
                            traverse_leaves(item, "")
                    else:
                        if PATTERN.findall(str(obj)):words.append(str(obj))
                traverse_leaves(lineobj,"")
                for match in words:
                    if match not in translations:
                        translations[match] = []
                    translations[match].append(f"{filepath}:{i + 1}")

def generate_pot_file(output_path='message.pot'):
    with open(output_path, 'a', encoding='utf-8') as pot_file:
        for text, locations in translations.items():
            for location in locations:
                pot_file.write(f"\n#: {location.replace('../../', '../')}\n")
            pot_file.write(f"msgid {json.dumps(text,ensure_ascii=False)}\n")
            pot_file.write("msgstr \"\"\n")

if __name__ == "__main__":
    scan_files('../../Scene')
    generate_pot_file('../../locale/message.pot')
    print(f"Generated .pot file with {len(translations)} entries.")
