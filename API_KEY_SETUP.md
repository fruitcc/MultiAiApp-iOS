# API Key Setup Guide

## Recommended Approach: iOS Keychain (Secure)

The app now uses iOS Keychain for secure storage. Here's how to set it up:

### Method 1: Through the App UI (Easiest)
1. Run the app
2. Go to Settings tab
3. Enter your API keys
4. Tap "Save Settings"
5. Keys are now securely stored in iOS Keychain

### Method 2: Pre-configured for Development
1. Edit `MultiAiApp/Config/APIConfig.swift`
2. Add your keys to the `initialKeys` dictionary:
```swift
static let initialKeys = [
    "chatGPT": "your-chatgpt-key-here",
    "gemini": "your-gemini-key-here",
    "claude": "your-claude-key-here",
    "perplexity": "your-perplexity-key-here"
]
```
3. Make sure `APIConfig.swift` is in `.gitignore` (it already is)
4. Run the app - keys will be automatically saved to Keychain on first launch

### Method 3: Programmatically (For Testing)
In your AppDelegate or during app initialization:
```swift
KeychainManager.shared.save(key: "chatGPT", value: "your-key", for: "MultiAiApp")
KeychainManager.shared.save(key: "gemini", value: "your-key", for: "MultiAiApp")
// etc...
```

## Security Benefits of This Approach

✅ **Keychain Storage**
- Keys are encrypted by iOS
- Survive app reinstalls
- Can be shared across app group
- Protected by device passcode/biometrics

✅ **No Hardcoding**
- Keys not in source code
- Config file is gitignored
- Safe from repository exposure

✅ **Runtime Configuration**
- Can update keys without rebuilding
- Different keys for dev/prod
- Easy key rotation

## For Production Apps

Consider these additional measures:

1. **Certificate Pinning**: Prevent MITM attacks
2. **Obfuscation**: Make reverse engineering harder
3. **Server Proxy**: Keep keys server-side only
4. **Key Rotation**: Regularly update API keys
5. **Access Controls**: Limit key permissions

## Verifying Setup

After setup, you can verify keys are stored:
```swift
// In Settings view or debug console
print("ChatGPT key exists: \(KeychainManager.shared.retrieve(key: "chatGPT", for: "MultiAiApp") != nil)")
```

## Important Notes

- Keys in Keychain persist even after app deletion (iOS design)
- To fully remove keys, user must reset device or manually clear
- Never commit `APIConfig.swift` with actual keys
- Always use `.gitignore` for sensitive files