import Foundation
import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    var responses: [AIResponse]
    
    init(content: String, isUser: Bool, timestamp: Date = Date(), responses: [AIResponse] = []) {
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.responses = responses
    }
}

struct AIResponse: Identifiable {
    let id = UUID()
    let platform: AIPlatform
    let content: String
    let isLoading: Bool
    let error: String?
    
    init(platform: AIPlatform, content: String = "", isLoading: Bool = true, error: String? = nil) {
        self.platform = platform
        self.content = content
        self.isLoading = isLoading
        self.error = error
    }
}

enum AIPlatform: String, CaseIterable {
    case chatGPT = "ChatGPT"
    case gemini = "Gemini"
    case claude = "Claude"
    case perplexity = "Perplexity"
    
    var iconName: String {
        switch self {
        case .chatGPT: return "brain"
        case .gemini: return "sparkles"
        case .claude: return "text.bubble"
        case .perplexity: return "magnifyingglass"
        }
    }
    
    var color: Color {
        switch self {
        case .chatGPT: return .green
        case .gemini: return .blue
        case .claude: return .purple
        case .perplexity: return .orange
        }
    }
}