import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    // Backend URL configuration
    @Published var backendURL: String = ""
    
    // Service enablement states (managed by backend)
    @Published var isChatGPTEnabled: Bool = true
    @Published var isGeminiEnabled: Bool = true
    @Published var isClaudeEnabled: Bool = true
    @Published var isPerplexityEnabled: Bool = true
    
    private let userDefaults = UserDefaults.standard
    
    // Default backend URLs
    static let defaultLocalURL = "http://localhost:48395"
    static let defaultProductionURL = "http://YOUR_LINODE_IP" // User should update this
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        // Load backend URL configuration
        let savedURL = userDefaults.string(forKey: "backendURL")
        backendURL = savedURL ?? Self.defaultLocalURL
        print("[Settings] Loaded backend URL from storage: \(savedURL ?? "nil"), using: \(backendURL)")
        
        // Load service states (these are just for UI display now)
        isChatGPTEnabled = userDefaults.bool(forKey: "isChatGPTEnabled")
        isGeminiEnabled = userDefaults.bool(forKey: "isGeminiEnabled")
        isClaudeEnabled = userDefaults.bool(forKey: "isClaudeEnabled")
        isPerplexityEnabled = userDefaults.bool(forKey: "isPerplexityEnabled")
        
        // Set defaults if not previously set
        if !userDefaults.bool(forKey: "hasSetDefaults") {
            isChatGPTEnabled = true
            isGeminiEnabled = true
            isClaudeEnabled = true
            isPerplexityEnabled = true
            userDefaults.set(true, forKey: "hasSetDefaults")
        }
    }
    
    func saveSettings() {
        // Save backend URL configuration
        userDefaults.set(backendURL, forKey: "backendURL")
        
        // Save service states
        userDefaults.set(isChatGPTEnabled, forKey: "isChatGPTEnabled")
        userDefaults.set(isGeminiEnabled, forKey: "isGeminiEnabled")
        userDefaults.set(isClaudeEnabled, forKey: "isClaudeEnabled")
        userDefaults.set(isPerplexityEnabled, forKey: "isPerplexityEnabled")
        
        // Force synchronize to ensure settings are saved immediately
        userDefaults.synchronize()
        
        print("[Settings] Saved - Backend URL: \(backendURL)")
    }
    
    func getBackendURL() -> String {
        // Always return the configured URL, or default if empty
        let url = backendURL.isEmpty ? Self.defaultLocalURL : backendURL
        print("[Settings] Getting backend URL: \(url)")
        return url
    }
    
    func resetToDefaults() {
        print("[Settings] resetToDefaults called!")
        #if DEBUG
        backendURL = Self.defaultLocalURL
        #else
        backendURL = Self.defaultProductionURL
        #endif
        saveSettings()
    }
    
    func clearAndSetURL(_ url: String) {
        // Clear old value first
        userDefaults.removeObject(forKey: "backendURL")
        userDefaults.synchronize()
        
        // Set new value
        backendURL = url
        saveSettings()
        print("[Settings] Cleared old URL and set new URL: \(url)")
    }
    
    // Check if backend URL is valid format
    func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString),
              let scheme = url.scheme,
              ["http", "https"].contains(scheme.lowercased()),
              url.host != nil else {
            return false
        }
        return true
    }
}