import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingSaveAlert = false
    @State private var backendStatus: BackendStatus = .checking
    @State private var availableServices: [String] = []
    
    enum BackendStatus {
        case checking
        case connected
        case disconnected
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Backend Connection")) {
                    HStack {
                        Text("Backend Status")
                        Spacer()
                        switch backendStatus {
                        case .checking:
                            ProgressView()
                                .scaleEffect(0.8)
                        case .connected:
                            Label("Connected", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        case .disconnected:
                            Label("Disconnected", systemImage: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    if backendStatus == .connected && !availableServices.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Available Services:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            ForEach(availableServices, id: \.self) { service in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text(service.capitalized)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    
                    Button("Refresh Connection") {
                        Task {
                            await checkBackendConnection()
                        }
                    }
                }
                
                Section(header: Text("Backend Mode Info")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Using Backend Service", systemImage: "server.rack")
                            .font(.caption)
                        Text("API keys are managed by the backend server at localhost:3000")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("Individual API key settings below are not used in backend mode")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
                
                Section(header: Text("ChatGPT Configuration (Not Used in Backend Mode)")) {
                    Toggle("Enable ChatGPT", isOn: $settingsManager.isChatGPTEnabled)
                        .disabled(true)
                    if settingsManager.isChatGPTEnabled {
                        SecureField("API Key", text: $settingsManager.chatGPTAPIKey)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disabled(true)
                    }
                }
                
                Section(header: Text("Google Gemini Configuration (Not Used in Backend Mode)")) {
                    Toggle("Enable Gemini", isOn: $settingsManager.isGeminiEnabled)
                        .disabled(true)
                    if settingsManager.isGeminiEnabled {
                        SecureField("API Key", text: $settingsManager.geminiAPIKey)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disabled(true)
                    }
                }
                
                Section(header: Text("Claude Configuration (Not Used in Backend Mode)")) {
                    Toggle("Enable Claude", isOn: $settingsManager.isClaudeEnabled)
                        .disabled(true)
                    if settingsManager.isClaudeEnabled {
                        SecureField("API Key", text: $settingsManager.claudeAPIKey)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disabled(true)
                    }
                }
                
                Section(header: Text("Perplexity Configuration (Not Used in Backend Mode)")) {
                    Toggle("Enable Perplexity", isOn: $settingsManager.isPerplexityEnabled)
                        .disabled(true)
                    if settingsManager.isPerplexityEnabled {
                        SecureField("API Key", text: $settingsManager.perplexityAPIKey)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disabled(true)
                    }
                }
                
                Section {
                    Button(action: saveSettings) {
                        HStack {
                            Spacer()
                            Text("Save Settings")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                    .disabled(true)
                }
                
                Section(header: Text("Service Status")) {
                    ForEach(AIPlatform.allCases, id: \.self) { platform in
                        HStack {
                            Image(systemName: platform.iconName)
                                .foregroundColor(platform.color)
                            Text(platform.rawValue)
                            Spacer()
                            if backendStatus == .connected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Via Backend")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showingSaveAlert) {
                Alert(
                    title: Text("Settings Saved"),
                    message: Text("Your API configurations have been saved successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                Task {
                    await checkBackendConnection()
                }
            }
        }
    }
    
    private func saveSettings() {
        settingsManager.saveSettings()
        showingSaveAlert = true
    }
    
    private func checkBackendConnection() async {
        backendStatus = .checking
        
        let isConnected = await APIManager.shared.checkBackendHealth()
        
        if isConnected {
            backendStatus = .connected
            availableServices = await APIManager.shared.getAvailableServices()
        } else {
            backendStatus = .disconnected
            availableServices = []
        }
    }
}