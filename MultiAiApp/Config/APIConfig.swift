import Foundation

// IMPORTANT: Add this file to .gitignore!
// This is for DEVELOPMENT ONLY - never use in production

struct APIConfig {
    // For initial setup during development
    // After first run, keys will be stored in Keychain
    static let initialKeys = [
        "chatGPT": "",     // Add your key here
        "gemini": "",      // Add your key here
        "claude": "",      // Add your key here
        "perplexity": ""   // Add your key here
    ]
    
    static func setupInitialKeys() {
        let keychain = KeychainManager.shared
        
        // Only set if not already in keychain
        for (service, key) in initialKeys {
            if !key.isEmpty {
                if keychain.retrieve(key: service, for: "MultiAiApp") == nil {
                    _ = keychain.save(key: service, value: key, for: "MultiAiApp")
                    print("[\(service)] Initial key saved to Keychain")
                }
            }
        }
    }
}