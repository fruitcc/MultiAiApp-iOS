import Foundation

class APIManager {
    static let shared = APIManager()
    private var settingsManager: SettingsManager?
    
    // Backend URL is now configured in BackendConfig.swift
    private var backendURL: String {
        return BackendConfig.apiURL
    }
    
    private init() {}
    
    func configure(with settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }
    
    func sendRequest(to platform: AIPlatform, prompt: String) async throws -> String {
        // For backend mode, we don't need individual API keys in the app
        // The backend will handle API key management
        
        print("[\(platform.rawValue)] Sending request through backend with prompt: \(prompt)")
        
        return try await sendBackendRequest(platform: platform, prompt: prompt)
    }
    
    private func sendBackendRequest(platform: AIPlatform, prompt: String) async throws -> String {
        // Map platform names to backend service names
        let serviceName: String
        switch platform {
        case .chatGPT:
            serviceName = "openai"
        case .gemini:
            serviceName = "google"
        case .claude:
            serviceName = "anthropic"
        case .perplexity:
            serviceName = "perplexity"
        }
        
        let url = URL(string: "\(backendURL)/chat/\(serviceName)")!
        print("[Backend] URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare request body matching backend's ChatRequest interface
        let body: [String: Any] = [
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        print("[Backend] Request body: \(String(data: request.httpBody!, encoding: .utf8) ?? "")")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("[Backend] Status code: \(httpResponse.statusCode)")
                print("[Backend] Response data: \(String(data: data, encoding: .utf8) ?? "")")
                
                if httpResponse.statusCode != 200 {
                    if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMessage = errorJson["error"] as? String {
                        throw APIError.apiError("\(platform.rawValue): \(errorMessage)")
                    }
                    throw APIError.invalidResponse
                }
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("[Backend] Failed to parse JSON")
                throw APIError.parsingError
            }
            
            // Parse the standardized response format from backend
            if let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                print("[Backend] Successfully extracted text for \(platform.rawValue)")
                return content
            }
            
            print("[Backend] Failed to extract text from response structure: \(json)")
            throw APIError.parsingError
            
        } catch {
            print("[Backend] Error for \(platform.rawValue): \(error.localizedDescription)")
            throw error
        }
    }
    
    // Check if backend is available
    func checkBackendHealth() async -> Bool {
        let healthURL = BackendConfig.healthURL
        print("[Backend] Checking health at URL: \(healthURL)")
        guard let url = URL(string: healthURL) else { 
            print("[Backend] Invalid URL: \(healthURL)")
            return false 
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["status"] as? String {
                return status == "ok"
            }
        } catch {
            print("[Backend] Health check failed: \(error.localizedDescription)")
        }
        
        return false
    }
    
    // Get available services from backend
    func getAvailableServices() async -> [String] {
        guard let url = URL(string: BackendConfig.getServicesURL()) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let services = json["services"] as? [String] {
                return services
            }
        } catch {
            print("[Backend] Failed to get services: \(error.localizedDescription)")
        }
        
        return []
    }
}

enum APIError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case parsingError
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key is missing or service is disabled"
        case .invalidResponse:
            return "Invalid response from API"
        case .parsingError:
            return "Failed to parse API response"
        case .apiError(let message):
            return message
        }
    }
}