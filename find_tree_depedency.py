import os
import re
from pathlib import Path
from typing import Optional
from collections import defaultdict

DEFAULT_EXTS = [".vue", ".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs"]


def extract_script_code(vue_text: str) -> str:
    blocks = re.findall(r"<script\b[^>]*>([\s\S]*?)</script>", vue_text, flags=re.IGNORECASE)
    return "\n".join(blocks)


def strip_js_comments(code: str) -> str:
    code = re.sub(r"/\*[\s\S]*?\*/", "", code)
    code = re.sub(r"(^|[^:])//.*?$", r"\1", code, flags=re.MULTILINE)
    return code


def find_import_specifiers_from_code(code: str) -> set[str]:
    patterns = [
        r"""(?:import|export)\s+(?:[\w*\s{},]+\s+from\s+)?[\"']([^\"']+)[\"']""",
        r"""import\(\s*[\"']([^\"']+)[\"']\s*\)""",
    ]
    out: set[str] = set()
    for p in patterns:
        out.update(re.findall(p, code))
    return out


def is_external(spec: str) -> bool:
    return not (spec.startswith("./") or spec.startswith("../") or spec.startswith("/") or spec.startswith("@/"))


def resolve_specifier_to_file(spec: str, src_file: Path, project_src_root: Path) -> Optional[Path]:
    if is_external(spec):
        return None

    if spec.startswith("@/"):
        base = project_src_root / spec[2:]
    elif spec.startswith("/"):
        base = project_src_root / spec.lstrip("/")
    else:
        base = src_file.parent / spec

    base_str = str(base)
    base_str = base_str.split("?", 1)[0].split("#", 1)[0]
    base = Path(base_str)

    if base.exists() and base.is_file():
        return base

    for ext in DEFAULT_EXTS:
        cand = base.with_suffix(ext)
        if cand.exists() and cand.is_file():
            return cand

    if base.exists() and base.is_dir():
        for ext in DEFAULT_EXTS:
            cand = base / f"index{ext}"
            if cand.exists() and cand.is_file():
                return cand

    return None


def escape_html(s: str) -> str:
    return (
        s.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
        .replace("'", "&#39;")
    )


def build_dependency_graph(project_src_root: Path) -> tuple[dict[str, set[str]], dict[str, int], dict[str, set[str]]]:
    graph: dict[str, set[str]] = defaultdict(set)
    in_degree: dict[str, int] = defaultdict(int)
    unresolved: dict[str, set[str]] = defaultdict(set)

    vue_files = list(project_src_root.rglob("*.vue"))
    for f in vue_files:
        text = f.read_text(encoding="utf-8", errors="ignore")
        code = strip_js_comments(extract_script_code(text))
        specs = find_import_specifiers_from_code(code)

        f_key = f.relative_to(project_src_root).as_posix()
        graph.setdefault(f_key, set())

        for spec in specs:
            resolved = resolve_specifier_to_file(spec, f, project_src_root)
            if resolved is None:
                if not is_external(spec):
                    unresolved[f_key].add(spec)
                continue

            try:
                dep_key = resolved.relative_to(project_src_root).as_posix()
            except ValueError:
                continue

            graph[f_key].add(dep_key)

    for src, deps in graph.items():
        in_degree.setdefault(src, in_degree.get(src, 0))
        for dep in deps:
            in_degree[dep] += 1

    return graph, in_degree, unresolved


def compute_roots(graph: dict[str, set[str]], in_degree: dict[str, int]) -> list[str]:
    nodes = set(graph.keys())
    for deps in graph.values():
        nodes |= set(deps)

    roots = sorted([n for n in nodes if in_degree.get(n, 0) == 0])
    if roots:
        return roots

    return sorted([n for n in graph.keys() if n.endswith(".vue")])


def render_tree_html(
    graph: dict[str, set[str]],
    in_degree: dict[str, int],
    root: str,
    indent: int = 0,
    path: tuple[str, ...] = (),
) -> str:
    if root in path:
        return f"<div style='margin-left:{20 * indent}px;color:purple'>↩ {escape_html(root)} (cycle)</div>"

    color = "red" if in_degree.get(root, 0) > 1 else "black"
    html = f"<div style='margin-left:{20 * indent}px; color:{color}'>{escape_html(root)}</div>"
    for child in sorted(graph.get(root, set())):
        html += render_tree_html(graph, in_degree, child, indent + 1, path + (root,))
    return html


def main(directory):
    project_src_root = Path(directory).expanduser().resolve()
    if not project_src_root.exists():
        print(f"Error: directory not found: {project_src_root}")
        return

    graph, in_degree, unresolved = build_dependency_graph(project_src_root)
    if not graph:
        print("Error: No .vue files found")
        return

    roots = compute_roots(graph, in_degree)

    html_parts: list[str] = []
    html_parts.append(
        "<html><body style='font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;'>"
    )
    html_parts.append(f"<h2>Dependency Tree (root: {escape_html(str(project_src_root))})</h2>")
    html_parts.append("<div style='color:#666'>Red = imported by more than one file. Purple = cycle.</div>")
    html_parts.append("<hr/>")

    for r in roots:
        html_parts.append(render_tree_html(graph, in_degree, r))
        html_parts.append("<br/>")

    unresolved_items = [(k, v) for k, v in unresolved.items() if v]
    if unresolved_items:
        html_parts.append("<hr/>")
        html_parts.append("<h3>Unresolved internal-like imports</h3>")
        for file_key, specs in sorted(unresolved_items):
            html_parts.append(f"<div><b>{escape_html(file_key)}</b></div>")
            for spec in sorted(specs):
                html_parts.append(f"<div style='margin-left:20px;color:#b36b00'>{escape_html(spec)}</div>")

    html_parts.append("</body></html>")
    html_content = "\n".join(html_parts)

    with open("dependency_tree.html", "w", encoding="utf-8") as file:
        file.write(html_content)
    print("HTML file has been generated successfully.")

if __name__ == "__main__":
    project_directory = os.getcwd()
    main(project_directory)

