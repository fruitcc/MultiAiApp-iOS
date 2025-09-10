import Foundation
import Combine

class ChatManager: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isProcessing = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiManager = APIManager.shared
    private var settingsManager: SettingsManager?
    
    func configure(with settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        apiManager.configure(with: settingsManager)
    }
    
    func sendMessage(_ content: String) {
        let userMessage = Message(content: content, isUser: true)
        messages.append(userMessage)
        
        var aiResponses: [AIResponse] = []
        for platform in AIPlatform.allCases {
            aiResponses.append(AIResponse(platform: platform))
        }
        
        let aiMessage = Message(content: "", isUser: false, responses: aiResponses)
        messages.append(aiMessage)
        
        isProcessing = true
        
        Task {
            await fetchResponses(for: content, messageIndex: messages.count - 1)
        }
    }
    
    private func fetchResponses(for prompt: String, messageIndex: Int) async {
        await withTaskGroup(of: (AIPlatform, Result<String, Error>).self) { group in
            for platform in AIPlatform.allCases {
                group.addTask { [weak self] in
                    guard let self = self else { 
                        return (platform, .failure(APIError.missingAPIKey))
                    }
                    do {
                        let response = try await self.apiManager.sendRequest(to: platform, prompt: prompt)
                        return (platform, .success(response))
                    } catch {
                        print("[\(platform.rawValue)] Error in fetchResponses: \(error.localizedDescription)")
                        return (platform, .failure(error))
                    }
                }
            }
            
            for await (platform, result) in group {
                await MainActor.run {
                    switch result {
                    case .success(let response):
                        updateResponse(platform: platform, response: response, messageIndex: messageIndex)
                    case .failure(let error):
                        updateResponse(platform: platform, response: nil, error: error.localizedDescription, messageIndex: messageIndex)
                    }
                }
            }
        }
        
        await MainActor.run {
            isProcessing = false
        }
    }
    
    private func updateResponse(platform: AIPlatform, response: String?, error: String? = nil, messageIndex: Int) {
        guard messageIndex < messages.count else { return }
        
        var message = messages[messageIndex]
        if let index = message.responses.firstIndex(where: { $0.platform == platform }) {
            var updatedResponse = message.responses[index]
            if let response = response {
                updatedResponse = AIResponse(platform: platform, content: response, isLoading: false)
            } else {
                let errorMessage = error ?? "Failed to get response"
                updatedResponse = AIResponse(platform: platform, content: "", isLoading: false, error: errorMessage)
            }
            message.responses[index] = updatedResponse
            messages[messageIndex] = message
        }
    }
}
