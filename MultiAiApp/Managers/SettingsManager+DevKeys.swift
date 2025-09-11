import Foundation

// DEVELOPMENT ONLY - Configuration helper
extension SettingsManager {
    func loadDevelopmentConfiguration() {
        // Set development backend URL if needed
        // Uncomment and modify for your development setup
        
        // For simulator testing:
        // backendURL = "http://localhost:48395"
        
        // For device testing with local backend:
        // backendURL = "http://192.168.1.100:48395" // Replace with your Mac's IP
        
        // For testing with production backend:
        // backendURL = "http://YOUR_SERVER_IP"
        
        // useCustomBackendURL = true
        // saveSettings()
    }
}