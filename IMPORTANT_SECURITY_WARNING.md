# ⚠️ CRITICAL SECURITY WARNING ⚠️

## API Keys Have Been Exposed

The API keys you've provided appear to be real credentials. These should NEVER be:
- Hardcoded in source code
- Committed to version control
- Shared publicly

## Immediate Actions Required:

1. **REVOKE ALL THESE API KEYS IMMEDIATELY** through their respective platforms:
   - OpenAI: https://platform.openai.com/api-keys
   - Anthropic: https://console.anthropic.com/account/keys
   - Google: https://console.cloud.google.com/apis/credentials
   - Perplexity: Check your Perplexity account settings

2. **Generate new API keys** after revoking the exposed ones

3. **Use secure methods** for API key management:
   - Environment variables
   - iOS Keychain
   - Configuration files in .gitignore
   - CI/CD secrets management

## Secure Alternative Implementation

Instead of hardcoding, use one of these approaches:

### Option 1: Environment Configuration File (Recommended for Development)
Create a `Config.xcconfig` file (add to .gitignore):
```
CHATGPT_API_KEY = your_key_here
GEMINI_API_KEY = your_key_here
CLAUDE_API_KEY = your_key_here
PERPLEXITY_API_KEY = your_key_here
```

### Option 2: Use a Secrets.plist (add to .gitignore)
Create a plist file with your keys and load at runtime.

### Option 3: Use iOS Keychain
Store keys securely in the iOS Keychain.

## Why This Matters

- Exposed API keys can be stolen and misused
- You'll be charged for unauthorized usage
- Your accounts could be compromised
- This violates security best practices

Please revoke these keys immediately and use a secure method instead.