import os
import re
import json

SOURCE_EXTENSIONS = ['.gd']

PATTERN = re.compile(r'([\u4e00-\u9fa5\uff00-\uffef\u3000-\u303f\u2026]+)')

translations = {}

EXCLUDE=[
    True,
    re.compile(r"^\s*#")
]
COMMENT_PATTERN=re.compile(r"#[^\"']*$")

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
            if EXCLUDE[0]:
                if EXCLUDE[1].match(line):
                    continue
                line=re.sub(COMMENT_PATTERN,'', line)
            matches = PATTERN.findall(line)
            if matches:
                # print(line)
                lineobj=eval('{'+line+'}')
                words=[]
                for k1 in lineobj:
                    v1=lineobj[k1]
                    for k2 in v1:
                        v2=v1[k2]
                        if PATTERN.findall(str(k2)):words.append(str(k2))
                        if PATTERN.findall(str(v2)):words.append(str(v2))
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
    EXCLUDE[0]=True
    scan_files('../../Datatable/Dist')
    generate_pot_file('../../locale/message.pot')
    print(f"Generated .pot file with {len(translations)} entries.")
