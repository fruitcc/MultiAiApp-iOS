import Foundation

struct BackendConfig {
    // MARK: - Backend URL Configuration
    
    // For local development with simulator
    // Use "localhost" or "127.0.0.1" when running on iOS Simulator
    // private static let localURL = "http://localhost:48395"
    
    // For testing on physical device with local backend
    // Replace with your Mac's IP address (e.g., "http://192.168.1.100:48395")
    // private static let localURL = "http://YOUR_MAC_IP:48395"
    
    // For production deployment
    // Replace with your Linode server's IP or domain
    // Example: "http://123.456.789.0" or "https://api.yourdomain.com"
    private static let productionURL = "http://YOUR_LINODE_IP"
    
    // MARK: - Environment Selection
    
    #if DEBUG
    // For development builds - change this to your Mac's IP if testing on device
    static let baseURL = "http://localhost:48395"
    #else
    // For release builds - update with your production server URL
    static let baseURL = productionURL
    #endif
    
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
}

// MARK: - Instructions for Setup

/*
 SETUP INSTRUCTIONS:
 
 1. FOR LOCAL DEVELOPMENT (iOS Simulator):
    - Keep the default "http://localhost:48395"
    - Make sure your backend is running locally: npm run dev
 
 2. FOR TESTING ON PHYSICAL DEVICE WITH LOCAL BACKEND:
    - Find your Mac's IP address:
      * System Preferences > Network > Wi-Fi > IP Address
      * Or run in Terminal: ifconfig | grep "inet " | grep -v 127.0.0.1
    - Update localURL to: "http://YOUR_MAC_IP:48395"
    - Ensure your device is on the same Wi-Fi network
 
 3. FOR PRODUCTION DEPLOYMENT:
    - Update productionURL with your Linode server IP or domain
    - Example: "http://123.456.789.0" or "https://api.yourdomain.com"
    - Build in Release mode for App Store distribution
 
 4. SWITCHING ENVIRONMENTS:
    - Debug builds (running from Xcode) use localURL
    - Release builds (Archive/TestFlight/App Store) use productionURL
    - You can also manually change the baseURL assignment above
 
 5. TROUBLESHOOTING:
    - If connection fails on device, check:
      * Backend is running and accessible
      * Correct IP address is used
      * Firewall/network settings allow connection
      * Info.plist has NSAppTransportSecurity configured for HTTP (if not using HTTPS)
 */