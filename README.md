Here is the content formatted in clean, structured Markdown.

---

# auto-commit 🚀

Turn your code changes into professional Git history in milliseconds.

**auto-commit** is a lightweight, AI-powered CLI utility designed for developers who value clean project history but hate the manual overhead of writing commit logs. Powered by Groq's LPU hardware and Llama 3, it analyzes your staged changes and "forges" a professional, **Conventional Commit-compliant** message instantly.

## ✨ Why use auto-commit?

* ⚡ **Blazing Fast:** Generates messages in under 500ms using Groq's LPU.
* 🧠 **Context Aware:** Reads your git diff to understand why changes were made.
* 📝 **Standardized:** Enforces Conventional Commits (`feat`, `fix`, `refactor`, etc.).
* 💰 **100% Free:** Runs on the Groq free tier API.
* 🔒 **Privacy Focused:** Your API key is stored locally on your machine.
* 🛠️ **Automated Setup:** Includes a self-install script that handles dependencies and aliases.

---

## 🚀 Installation

### Option 1: The One-Line Installer (Recommended)

Run this command in your terminal. It will install dependencies, set up the commit alias, and prompt you for your API key securely.

```bash
curl -sSL https://raw.githubusercontent.com/synapsyz/auto-commit/main/install.sh | bash

```

> **Note:** You will need a free API Key from [Groq Cloud](https://console.groq.com/). The script will ask for it.

### Option 2: Manual Install

If you prefer to set it up yourself, follow these steps:

1. **Clone the repo:**
```bash
git clone https://github.com/synapsyz/auto-commit.git

```


2. **Navigate to the folder:**
```bash
cd auto-commit

```


3. **Make the script executable:**
```bash
chmod +x install.sh

```


4. **Run the installer:**
```bash
./install.sh

```



---

## 🛠️ Usage

Once installed, you don't need to type `git commit` anymore. Just use the `commit` command.

1. **Stage your files:**
```bash
git add .

```


2. **Run the tool:**
```bash
commit

```


3. **Confirm:**
The tool will generate a message. Type `y` to approve and commit, or `n` to cancel.

### 📖 Example Output

```text
$ commit

⏳ Generating commit message...

--- PROPOSED COMMIT ---
feat(auth): implement JWT session handling

- lib/api.js: Added interceptors for token refresh logic.
- middleware.js: Implemented route protection for /dashboard.
- pages/login.js: Fixed state persistence issue on failed login.

Confirm commit? (y/n): y
🚀 Successfully committed!

```

---

## ⚙️ Configuration

The installer creates a hidden folder in your home directory: `~/.auto-commit/`.

* **Script:** `~/.auto-commit/commit.py`
* **Config:** `~/.auto-commit/config.json` (Stores your API Key)

To update your API Key manually, simply edit the `config.json` file.

---

## 🤝 Contributing

Built with passion by **Synapsyz Innovations**. Feel free to fork this repository and submit Pull Requests to make it even better.

## 📜 License

This project is licensed under the **MIT License**.

---

Would you like me to help you draft a `README.md` for a different version of this tool, or perhaps optimize the installation script logic?