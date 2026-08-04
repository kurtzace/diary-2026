The git checkout --orphan <new_branch> command creates a new branch that has no parent commits and no commit history


## uv
- uv init: Initialize a new Python project in the current directory.
- uv init <name>: Create a new project directory and initialize it.
- uv run <script.py>: Run a Python script inside the managed virtual environment.
- uv sync: Update the project environment and refresh the lockfile.
- uv lock: Generate or update the   uv.lock dependency lockfile.
- uv tree: View the dependency graph tree
- uv add langchain-openai

black isort

load_dotenv()

### uv toml eg

```
[project]
name = "my-awesome-project"
version = "0.1.0"
description = "A fast Python project managed by uv"
readme = "README.md"
requires-python = ">=3.11"
authors = [
    { name = "Your Name", email = "you@example.com" }
]
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0",
]
```