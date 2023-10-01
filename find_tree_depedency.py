import os
import re
from collections import defaultdict

def find_imports(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    script_content = re.search(r'<script[^>]*>([\s\S]*?)<\/script>', content)
    if not script_content:
        return set()
    imports = re.findall(r'import\s+(?:[\w*{},\s]+from\s+)?[\'"]([^\'"]+)[\'"]', script_content.group(1))
    filtered_imports = {imp for imp in imports if 'views' in imp or 'components' in imp}
    return set(filtered_imports)

def build_dependency_tree(directory):
    tree = defaultdict(set)
    all_imports = defaultdict(int)
    for foldername, _, filenames in os.walk(directory):
        for filename in filenames:
            if filename.endswith('.vue'):
                file_path = os.path.join(foldername, filename)
                imports = find_imports(file_path)
                for imp in imports:
                    tree[filename].add(imp)
                    all_imports[imp] += 1
    return tree, all_imports

def generate_html(tree, all_imports, root, indent=0):
    color = 'red' if all_imports[root] > 1 else 'black'
    html = f"<div style='margin-left:{20 * indent}px; color:{color}'>{root}</div>"
    for child in tree[root]:
        html += generate_html(tree, all_imports, child, indent + 1)
    return html

def main(directory):
    dependency_tree, all_imports = build_dependency_tree(directory)
    if not dependency_tree:
        print("Error: No .vue files found")
        return
    html_content = "<html><body>"
    # Iterate over a copy of the keys of the dictionary
    for root in list(dependency_tree.keys()):
        html_content += generate_html(dependency_tree, all_imports, root)
    html_content += "</body></html>"
    
    with open("dependency_tree.html", "w", encoding="utf-8") as file:
        file.write(html_content)
    print("HTML file has been generated successfully.")

if __name__ == "__main__":
    project_directory = os.path.expanduser("~/work-project/frontend/src")
    main(project_directory)

