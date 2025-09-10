import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func save(key: String, value: String, for service: String) -> Bool {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete existing item
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func retrieve(key: String, for service: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        
        return nil
    }
    
    func delete(key: String, for service: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

// Usage in SettingsManager
extension SettingsManager {
    func saveKeysToKeychain() {
        KeychainManager.shared.save(key: "chatGPT", value: chatGPTAPIKey, for: "MultiAiApp")
        KeychainManager.shared.save(key: "gemini", value: geminiAPIKey, for: "MultiAiApp")
        KeychainManager.shared.save(key: "claude", value: claudeAPIKey, for: "MultiAiApp")
        KeychainManager.shared.save(key: "perplexity", value: perplexityAPIKey, for: "MultiAiApp")
    }
    
    func loadKeysFromKeychain() {
        chatGPTAPIKey = KeychainManager.shared.retrieve(key: "chatGPT", for: "MultiAiApp") ?? ""
        geminiAPIKey = KeychainManager.shared.retrieve(key: "gemini", for: "MultiAiApp") ?? ""
        claudeAPIKey = KeychainManager.shared.retrieve(key: "claude", for: "MultiAiApp") ?? ""
        perplexityAPIKey = KeychainManager.shared.retrieve(key: "perplexity", for: "MultiAiApp") ?? ""
    }
}