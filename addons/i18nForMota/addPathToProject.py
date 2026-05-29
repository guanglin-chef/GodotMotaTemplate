import os
import re
import json

SOURCE_EXTENSIONS = ['.tscn','.gd']

PATTERN = re.compile(r'([\u4e00-\u9fa5\uff00-\uffef\u3000-\u303f\u2026]+)')

EXCLUDE=[
    'res://Scene/Map/',
    'res://Scene/CommonEvent/',
]

output_files=[]

def scan_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if any(file.endswith(ext) for ext in SOURCE_EXTENSIONS):
                filepath=(root+'/'+file).replace('../../','res://')
                filepath=re.sub(r'\\','/',filepath)
                if any(filepath.startswith(exclude) for exclude in EXCLUDE):
                    continue
                output_files.append(filepath)


def putIntoProject():
    with open('../../project.godot', 'r', encoding='utf-8') as f:
        content = f.read()
    files_str = ','.join(f'"{file}"' for file in output_files)
    files_str=f'locale/translations_pot_files=PackedStringArray({files_str})'
    content = re.sub(r'locale/translations_pot_files\s*=\s*PackedStringArray\([^)]+\)', files_str, content)
    with open('../../project.godot', 'w', encoding='utf-8') as f:
        f.write(content)


if __name__ == "__main__":
    scan_files('../../Scene')
    scan_files('../../Script')
    putIntoProject()
