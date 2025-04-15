import os
import re
from pathlib import Path
from openai import OpenAI

client = OpenAI()

SYSTEM_PROMPT = """You are a DevOps assistant with permission to read, write, and edit local files.
You can request to READ, WRITE, APPEND, LIST, or EXECUTE commands on the server.
Always be safe and confirm before overwriting critical configs.
Use Markdown format in responses for readability."""

def gpt_response(prompt):
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt}
            ]
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"❌ GPT error: {e}"

def read_file(path):
    try:
        with open(path, 'r') as f:
            return f"📖 **Contents of {path}:**\n\n```\n{f.read()}\n```"
    except Exception as e:
        return f"❌ Error reading {path}: {e}"

def write_file(path, content):
    try:
        backup_path = f"{path}.bak"
        if os.path.exists(path):
            os.rename(path, backup_path)
        with open(path, 'w') as f:
            f.write(content)
        return f"✅ File written to `{path}` (backup saved as `{backup_path}`)"
    except Exception as e:
        return f"❌ Error writing to {path}: {e}"

def append_file(path, content):
    try:
        with open(path, 'a') as f:
            f.write(content)
        return f"✅ Content appended to `{path}`"
    except Exception as e:
        return f"❌ Error appending to {path}: {e}"

def list_dir(path):
    try:
        entries = os.listdir(path)
        return f"📂 **Directory listing of {path}:**\n" + "\n".join(f"- {e}" for e in entries)
    except Exception as e:
        return f"❌ Error listing {path}: {e}"

def handle_command(cmd):
    cmd = cmd.strip()

    if cmd.upper().startswith("READ "):
        return read_file(cmd[5:].strip())
    elif cmd.upper().startswith("LIST "):
        return list_dir(cmd[5:].strip())
    elif cmd.upper().startswith("WRITE "):
        match = re.match(r"WRITE (.+?)\n(.+)", cmd, re.DOTALL)
        if match:
            path, content = match.groups()
            return write_file(path.strip(), content)
    elif cmd.upper().startswith("APPEND "):
        match = re.match(r"APPEND (.+?)\n(.+)", cmd, re.DOTALL)
        if match:
            path, content = match.groups()
            return append_file(path.strip(), content)
    else:
        return gpt_response(cmd)

def main():
    print("🤖 GPT Agent ready. Type your command (or 'exit'):")
    while True:
        try:
            user_input = input("🤖 > ")
            if user_input.strip().lower() in ['exit', 'quit']:
                break
            result = handle_command(user_input)
            print(result)
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    main()
