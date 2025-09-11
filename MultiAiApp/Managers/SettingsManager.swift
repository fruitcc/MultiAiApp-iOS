import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    // Backend URL configuration
    @Published var backendURL: String = ""
    @Published var useCustomBackendURL: Bool = false
    
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
        backendURL = userDefaults.string(forKey: "backendURL") ?? Self.defaultLocalURL
        useCustomBackendURL = userDefaults.bool(forKey: "useCustomBackendURL")
        
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
        userDefaults.set(useCustomBackendURL, forKey: "useCustomBackendURL")
        
        // Save service states
        userDefaults.set(isChatGPTEnabled, forKey: "isChatGPTEnabled")
        userDefaults.set(isGeminiEnabled, forKey: "isGeminiEnabled")
        userDefaults.set(isClaudeEnabled, forKey: "isClaudeEnabled")
        userDefaults.set(isPerplexityEnabled, forKey: "isPerplexityEnabled")
        
        // Force synchronize to ensure settings are saved immediately
        userDefaults.synchronize()
        
        print("[Settings] Saved - Backend URL: \(backendURL), Use Custom: \(useCustomBackendURL)")
    }
    
    func getBackendURL() -> String {
        let url: String
        if useCustomBackendURL && !backendURL.isEmpty {
            url = backendURL
        } else {
            #if DEBUG
            url = Self.defaultLocalURL
            #else
            url = backendURL.isEmpty ? Self.defaultProductionURL : backendURL
            #endif
        }
        print("[Settings] Getting backend URL - Custom: \(useCustomBackendURL), URL: \(url)")
        return url
    }
    
    func resetToDefaults() {
        #if DEBUG
        backendURL = Self.defaultLocalURL
        #else
        backendURL = Self.defaultProductionURL
        #endif
        useCustomBackendURL = false
        saveSettings()
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