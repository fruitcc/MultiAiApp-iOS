import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    // For development: Create APIKeys.swift from APIKeys-Template.swift with your keys
    // For production: Use environment variables or keychain
    @Published var chatGPTAPIKey: String = ""
    @Published var geminiAPIKey: String = ""
    @Published var claudeAPIKey: String = ""
    @Published var perplexityAPIKey: String = ""
    
    @Published var isChatGPTEnabled: Bool = true
    @Published var isGeminiEnabled: Bool = true
    @Published var isClaudeEnabled: Bool = true
    @Published var isPerplexityEnabled: Bool = true
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        // For now, using UserDefaults (switch to Keychain when ready)
        chatGPTAPIKey = userDefaults.string(forKey: "chatGPTAPIKey") ?? ""
        geminiAPIKey = userDefaults.string(forKey: "geminiAPIKey") ?? ""
        claudeAPIKey = userDefaults.string(forKey: "claudeAPIKey") ?? ""
        perplexityAPIKey = userDefaults.string(forKey: "perplexityAPIKey") ?? ""
        
        isChatGPTEnabled = userDefaults.bool(forKey: "isChatGPTEnabled")
        isGeminiEnabled = userDefaults.bool(forKey: "isGeminiEnabled")
        isClaudeEnabled = userDefaults.bool(forKey: "isClaudeEnabled")
        isPerplexityEnabled = userDefaults.bool(forKey: "isPerplexityEnabled")
    }
    
    func saveSettings() {
        // Save API keys to UserDefaults (temporary - should use Keychain in production)
        userDefaults.set(chatGPTAPIKey, forKey: "chatGPTAPIKey")
        userDefaults.set(geminiAPIKey, forKey: "geminiAPIKey")
        userDefaults.set(claudeAPIKey, forKey: "claudeAPIKey")
        userDefaults.set(perplexityAPIKey, forKey: "perplexityAPIKey")
        
        // Save toggle states to UserDefaults
        userDefaults.set(isChatGPTEnabled, forKey: "isChatGPTEnabled")
        userDefaults.set(isGeminiEnabled, forKey: "isGeminiEnabled")
        userDefaults.set(isClaudeEnabled, forKey: "isClaudeEnabled")
        userDefaults.set(isPerplexityEnabled, forKey: "isPerplexityEnabled")
    }
    
    func isAPIKeyConfigured(for platform: AIPlatform) -> Bool {
        switch platform {
        case .chatGPT:
            return !chatGPTAPIKey.isEmpty && isChatGPTEnabled
        case .gemini:
            return !geminiAPIKey.isEmpty && isGeminiEnabled
        case .claude:
            return !claudeAPIKey.isEmpty && isClaudeEnabled
        case .perplexity:
            return !perplexityAPIKey.isEmpty && isPerplexityEnabled
        }
    }
    
    func getAPIKey(for platform: AIPlatform) -> String? {
        guard isAPIKeyConfigured(for: platform) else { return nil }
        
        switch platform {
        case .chatGPT:
            return chatGPTAPIKey
        case .gemini:
            return geminiAPIKey
        case .claude:
            return claudeAPIKey
        case .perplexity:
            return perplexityAPIKey
        }
    }
    
}