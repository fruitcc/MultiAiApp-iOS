# Setup Instructions for API Keys

## ⚠️ Security First
**NEVER commit API keys to version control!**

## Development Setup

### Step 1: Create your API Keys file
```bash
cd MultiAiApp/Config
cp APIKeys-Template.swift APIKeys.swift
```

### Step 2: Add your API keys to APIKeys.swift
Edit `APIKeys.swift` and replace the placeholder values with your actual keys.

### Step 3: Update SettingsManager.swift
Uncomment the lines in `loadDevelopmentKeys()` method:
```swift
chatGPTAPIKey = APIKeys.chatGPT
geminiAPIKey = APIKeys.gemini
claudeAPIKey = APIKeys.claude
perplexityAPIKey = APIKeys.perplexity
```

### Step 4: Verify .gitignore
Make sure `APIKeys.swift` is in your `.gitignore` file (it already is).

## Alternative: Using Environment Variables

For CI/CD or more secure local development:

1. Set environment variables in your scheme:
   - Edit Scheme → Run → Arguments → Environment Variables
   - Add: CHATGPT_API_KEY, GEMINI_API_KEY, etc.

2. Load from environment:
```swift
chatGPTAPIKey = ProcessInfo.processInfo.environment["CHATGPT_API_KEY"] ?? ""
```

## Production Recommendations

For production apps, use:
- iOS Keychain Services
- Remote configuration service
- Encrypted plist files
- Server-side proxy for API calls

Remember: The Settings UI can still be used to override these development keys if needed.