# MultiAiApp - Multi-Platform AI Chat iOS App

An iOS app that allows you to chat with multiple AI platforms simultaneously (ChatGPT, Google Gemini, Claude, and Perplexity) with swipeable responses.

## Features

- 🤖 Support for 4 AI platforms: ChatGPT, Google Gemini, Claude, and Perplexity
- 👆 Swipe between different AI responses  
- 🔐 Secure API key storage
- ⚙️ Enable/disable individual AI services
- 💬 Clean chat interface with message bubbles

## Setup Instructions

### Option 1: Using XcodeGen (Recommended)

1. Run the setup script:
   ```bash
   ./setup.sh
   ```
   This will install XcodeGen if needed and open the project in Xcode.

### Option 2: Manual Setup with XcodeGen

1. Install XcodeGen:
   ```bash
   brew install xcodegen
   ```

2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```

3. Open the project:
   ```bash
   open MultiAiApp.xcodeproj
   ```

### Option 3: Create New Project in Xcode

1. Open Xcode
2. Create new iOS App (File → New → Project)
3. Choose:
   - Product Name: MultiAiApp
   - Interface: SwiftUI
   - Language: Swift
   - Minimum iOS: 16.0
4. Delete the default files
5. Copy all files from the `MultiAiApp/` folder into your Xcode project
6. Build and run

## Configuration

1. Launch the app
2. Go to Settings tab
3. Enable desired AI services
4. Enter your API keys for each service:
   - **ChatGPT**: Get from [OpenAI Platform](https://platform.openai.com/api-keys)
   - **Gemini**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - **Claude**: Get from [Anthropic Console](https://console.anthropic.com/account/keys)
   - **Perplexity**: Get from [Perplexity](https://www.perplexity.ai/)
5. Save settings

## Usage

1. Open the Chat tab
2. Type your message
3. All enabled AI services will respond simultaneously
4. Swipe left/right or tap platform buttons to view different responses

## Project Structure

```
MultiAiApp/
├── MultiAiApp.swift          # App entry point
├── ContentView.swift         # Main tab view
├── Models/
│   └── Message.swift        # Data models
├── Views/
│   ├── ChatView.swift       # Chat interface
│   ├── AIResponseView.swift # Swipeable responses
│   └── SettingsView.swift   # Settings screen
├── Managers/
│   ├── ChatManager.swift    # Chat state
│   └── SettingsManager.swift # Settings persistence
└── Services/
    └── APIManager.swift      # API integration
```

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+

## Next Features to Add

- Message history persistence
- Conversation export
- Custom system prompts per platform
- Response regeneration
- Voice input support
- Dark mode optimization