import subprocess
import requests
import sys
import os
import json

# CONSTANTS
CONFIG_DIR = os.path.expanduser("~/.auto-commit")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")
MODEL = "llama-3.3-70b-versatile"

def load_api_key():
    if not os.path.exists(CONFIG_FILE):
        print(f"❌ Configuration not found at {CONFIG_FILE}")
        print("Please run the install script again.")
        sys.exit(1)
    
    try:
        with open(CONFIG_FILE, 'r') as f:
            config = json.load(f)
            return config.get("GROQ_API_KEY")
    except Exception as e:
        print(f"❌ Error reading config: {e}")
        sys.exit(1)

def get_git_diff():
    # Shows file stats and the actual code changes
    try:
        stat = subprocess.check_output(["git", "diff", "--staged", "--stat"]).decode("utf-8")
        diff = subprocess.check_output(["git", "diff", "--staged"]).decode("utf-8")
        
        if len(diff) > 12000:
            return f"FILE SUMMARY:\n{stat}\n\n(Diff too large for full context.)"
        return diff
    except subprocess.CalledProcessError:
        print("❌ Not a git repository or git is not installed.")
        sys.exit(1)

def generate_message(diff, api_key):
    if not diff.strip(): return None
    
    url = "https://api.groq.com/openai/v1/chat/completions"
    headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
    
    # Prompt asks for clean header (no scope)
    prompt = f"Write a professional conventional commit message (header + bullet points) for these changes. Use the format 'type: description' (e.g., 'feat: add new script') and OMIT the scope (e.g. do NOT use 'feat(scope):'). Do not include introductory text:\n\n{diff}"
    
    data = {"model": MODEL, "messages": [{"role": "user", "content": prompt}], "temperature": 0.2}
    
    try:
        response = requests.post(url, headers=headers, json=data)
        res_data = response.json()

        if 'error' in res_data:
            print(f"❌ Groq Error: {res_data['error']['message']}")
            sys.exit(1)
        
        # REMOVED: No longer appending the AI signature
        return res_data['choices'][0]['message']['content'].strip()
        
    except Exception as e:
        print(f"❌ Connection Error: {e}")
        sys.exit(1)

# --- MAIN EXECUTION ---
try:
    key = load_api_key()
    diff_data = get_git_diff()
    
    if not diff_data.strip():
        print("💡 No changes staged. Run 'git add' first.")
        sys.exit(0)

    print("⏳ Generating commit message...")
    message = generate_message(diff_data, key)
    
    while True:
        print(f"\n--- PROPOSED COMMIT ---\n{message}\n")
        
        action = input("Options: [y]es, [n]o, [e]dit, [r]egenerate: ").lower()
        
        if action == 'y':
            subprocess.run(["git", "commit", "-m", message])
            print("🚀 Successfully committed!")
            break
        elif action == 'e':
            print("\nType your new message below (Press Enter twice to finish):")
            lines = []
            while True:
                line = input()
                if line:
                    lines.append(line)
                else:
                    break
            message = "\n".join(lines)
            continue 
        elif action == 'r':
            print("🔄 Regenerating...")
            message = generate_message(diff_data, key)
            continue
        elif action == 'n':
            print("❌ Commit cancelled.")
            break
        else:
            print("Invalid option.")

except KeyboardInterrupt:
    print("\n\nOperation cancelled.")
    sys.exit(0)