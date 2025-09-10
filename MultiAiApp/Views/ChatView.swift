import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatManager: ChatManager
    @State private var messageText = ""
    @State private var selectedResponseIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(chatManager.messages) { message in
                                MessageRow(message: message, selectedResponseIndex: $selectedResponseIndex)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatManager.messages.count) { _ in
                        withAnimation {
                            scrollProxy.scrollTo(chatManager.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                HStack {
                    TextField("Type a message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(chatManager.isProcessing)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(messageText.isEmpty || chatManager.isProcessing ? Color.gray : Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty || chatManager.isProcessing)
                }
                .padding()
            }
            .navigationTitle("Multi AI Chat")
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        chatManager.sendMessage(messageText)
        messageText = ""
    }
}

struct MessageRow: View {
    let message: Message
    @Binding var selectedResponseIndex: Int
    
    var body: some View {
        HStack(alignment: .top) {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
            } else {
                if !message.responses.isEmpty {
                    AIResponseView(responses: message.responses, selectedIndex: $selectedResponseIndex)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .leading)
                }
            }
        }
    }
}