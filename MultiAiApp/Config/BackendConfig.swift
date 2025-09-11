import Foundation

struct BackendConfig {
    // MARK: - Backend URL Configuration
    
    // Get the backend URL from SettingsManager or use defaults
    static var baseURL: String {
        // Try to get URL from SettingsManager if available
        if let settingsManager = getSettingsManager() {
            return settingsManager.getBackendURL()
        }
        
        // Fallback to compile-time defaults
        #if DEBUG
        return "http://localhost:48395"
        #else
        return "http://YOUR_LINODE_IP" // User should update this in Settings
        #endif
    }
    
    // MARK: - API Endpoints
    
    static var apiURL: String {
        return "\(baseURL)/api/ai"
    }
    
    static var healthURL: String {
        return "\(baseURL)/health"
    }
    
    // MARK: - Helper Methods
    
    static func isLocalhost() -> Bool {
        return baseURL.contains("localhost") || baseURL.contains("127.0.0.1")
    }
    
    static func getServiceURL(for service: String) -> String {
        return "\(apiURL)/chat/\(service)"
    }
    
    static func getServicesURL() -> String {
        return "\(apiURL)/services"
    }
    
    // Try to get SettingsManager instance from the app
    private static func getSettingsManager() -> SettingsManager? {
        // This will be set by the app when it starts
        return BackendConfigHelper.shared.settingsManager
    }
}

// Helper class to store reference to SettingsManager
class BackendConfigHelper {
    static let shared = BackendConfigHelper()
    var settingsManager: SettingsManager?
    
    private init() {}
}

// MARK: - Instructions for Setup

/*
 SETUP INSTRUCTIONS:
 
 1. CONFIGURE IN APP SETTINGS:
    - Open the app and go to Settings tab
    - Enter your backend URL in the "Backend URL" field
    - Toggle "Use Custom URL" to enable it
    - Tap "Save Settings"
 
 2. DEFAULT URLS:
    - Debug builds: http://localhost:48395
    - Release builds: Set in Settings tab
 
 3. FOR LOCAL DEVELOPMENT (iOS Simulator):
    - Keep the default "http://localhost:48395"
    - Make sure your backend is running locally: npm run dev
 
 4. FOR TESTING ON PHYSICAL DEVICE WITH LOCAL BACKEND:
    - Find your Mac's IP address:
      * System Preferences > Network > Wi-Fi > IP Address
      * Or run in Terminal: ifconfig | grep "inet " | grep -v 127.0.0.1
    - In Settings tab, enter: "http://YOUR_MAC_IP:48395"
    - Ensure your device is on the same Wi-Fi network
 
 5. FOR PRODUCTION DEPLOYMENT:
    - In Settings tab, enter your Linode server IP or domain
    - Example: "http://123.456.789.0" or "https://api.yourdomain.com"
 
 6. TROUBLESHOOTING:
    - Check backend status in Settings tab
    - Green checkmark = Connected
    - Red X = Check your URL and network connection
    - Use "Refresh Connection" button to test
 */