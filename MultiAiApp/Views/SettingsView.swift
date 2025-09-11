import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingSaveAlert = false
    @State private var backendStatus: BackendStatus = .checking
    @State private var availableServices: [String] = []
    @State private var tempBackendURL: String = ""
    @State private var showingInvalidURLAlert = false
    @State private var hasInitialized = false
    
    enum BackendStatus {
        case checking
        case connected
        case disconnected
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Backend Configuration")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Backend URL")
                            .font(.headline)
                        
                        TextField("http://localhost:48395", text: $tempBackendURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.URL)
                        
                        HStack {
                            Button("Reset to Default") {
                                settingsManager.resetToDefaults()
                                tempBackendURL = settingsManager.backendURL
                            }
                            .foregroundColor(.orange)
                            
                            Spacer()
                            
                            Button("Test Connection") {
                                Task {
                                    await testConnectionWithURL(tempBackendURL)
                                }
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Connection Status")) {
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
                    
                    if backendStatus == .disconnected {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Troubleshooting:")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Text("• Check if backend is running")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("• Verify the URL is correct")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("• For device testing, use your Mac's IP")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Quick Setup Guide")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Simulator", systemImage: "desktopcomputer")
                            .font(.caption.bold())
                        Text("Use: http://localhost:48395")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        Label("Physical Device", systemImage: "iphone")
                            .font(.caption.bold())
                        Text("Use: http://YOUR_MAC_IP:48395")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("Find IP: System Preferences > Network")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        Label("Production", systemImage: "cloud")
                            .font(.caption.bold())
                        Text("Use: http://YOUR_SERVER_IP")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Service Status")) {
                    ForEach(AIPlatform.allCases, id: \.self) { platform in
                        HStack {
                            Image(systemName: platform.iconName)
                                .foregroundColor(platform.color)
                            Text(platform.rawValue)
                            Spacer()
                            if backendStatus == .connected && availableServices.contains(platformToService(platform)) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Available")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                Text("Not Available")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
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
                }
            }
            .navigationTitle("Settings")
            .alert("Settings Saved", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your backend configuration has been saved successfully.")
            }
            .alert("Invalid URL", isPresented: $showingInvalidURLAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid URL starting with http:// or https://")
            }
            .onAppear {
                // Only initialize once
                if !hasInitialized {
                    tempBackendURL = settingsManager.backendURL
                    hasInitialized = true
                }
                // Ensure APIManager is configured with settingsManager
                APIManager.shared.configure(with: settingsManager)
                Task {
                    await checkBackendConnection()
                }
            }
        }
    }
    
    private func saveSettings() {
        // Validate URL
        if !tempBackendURL.isEmpty && !settingsManager.isValidURL(tempBackendURL) {
            showingInvalidURLAlert = true
            return
        }
        
        print("[SettingsView] Saving URL: \(tempBackendURL)")
        
        // Save the URL from the text field
        settingsManager.backendURL = tempBackendURL
        settingsManager.saveSettings()
        
        // Force re-configure APIManager with updated settings
        APIManager.shared.configure(with: settingsManager)
        
        showingSaveAlert = true
        
        // Test connection after saving using the standard method
        Task {
            await checkBackendConnection()
        }
    }
    
    private func checkBackendConnection() async {
        backendStatus = .checking
        
        // Ensure APIManager has the current settingsManager
        APIManager.shared.configure(with: settingsManager)
        
        let isConnected = await APIManager.shared.checkBackendHealth()
        
        if isConnected {
            backendStatus = .connected
            availableServices = await APIManager.shared.getAvailableServices()
        } else {
            backendStatus = .disconnected
            availableServices = []
        }
    }
    
    private func testConnectionWithURL(_ urlToTest: String) async {
        guard !urlToTest.isEmpty else { return }
        
        backendStatus = .checking
        
        // Test the URL directly without modifying any settings
        let healthURL = "\(urlToTest)/health"
        let servicesURL = "\(urlToTest)/api/ai/services"
        
        print("[SettingsView] Testing connection to: \(healthURL)")
        
        guard let healthEndpoint = URL(string: healthURL) else {
            print("[SettingsView] Invalid URL: \(healthURL)")
            backendStatus = .disconnected
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: healthEndpoint)
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["status"] as? String,
               status == "ok" {
                
                backendStatus = .connected
                
                // Try to get services
                if let servicesEndpoint = URL(string: servicesURL) {
                    let (servicesData, _) = try await URLSession.shared.data(from: servicesEndpoint)
                    if let servicesJson = try? JSONSerialization.jsonObject(with: servicesData) as? [String: Any],
                       let services = servicesJson["services"] as? [String] {
                        availableServices = services
                    }
                }
            } else {
                backendStatus = .disconnected
                availableServices = []
            }
        } catch {
            print("[SettingsView] Connection test failed: \(error.localizedDescription)")
            backendStatus = .disconnected
            availableServices = []
        }
    }
    
    private func platformToService(_ platform: AIPlatform) -> String {
        switch platform {
        case .chatGPT:
            return "openai"
        case .gemini:
            return "google"
        case .claude:
            return "anthropic"
        case .perplexity:
            return "perplexity"
        }
    }
}