import sys

with open('d:/OneDrive - VNPT/AI/thueCSHT/vercel-static-hopdong/form_in.html', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if 'ông/bà' in line.lower():
        print(f"{i+1}: {line.strip()}")
