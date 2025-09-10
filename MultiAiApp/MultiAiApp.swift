import SwiftUI

@main
struct MultiAiApp: App {
    @StateObject private var chatManager = ChatManager()
    @StateObject private var settingsManager = SettingsManager()
    
    init() {
        // Configure managers after they're initialized
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chatManager)
                .environmentObject(settingsManager)
                .onAppear {
                    // Configure ChatManager with SettingsManager
                    chatManager.configure(with: settingsManager)
                }
        }
    }
}