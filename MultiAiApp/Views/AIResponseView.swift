import SwiftUI

struct AIResponseView: View {
    let responses: [AIResponse]
    @Binding var selectedIndex: Int
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Platform selector buttons
            HStack {
                ForEach(Array(responses.enumerated()), id: \.element.id) { index, response in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedIndex = index
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: response.platform.iconName)
                                .font(.caption)
                            Text(response.platform.rawValue)
                                .font(.caption2)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(selectedIndex == index ? response.platform.color : Color.gray.opacity(0.3))
                        .foregroundColor(selectedIndex == index ? .white : .primary)
                        .cornerRadius(12)
                    }
                }
            }
            
            // Response content with smooth swipe animation
            GeometryReader { geometry in
                HStack(spacing: 20) {
                    ForEach(Array(responses.enumerated()), id: \.element.id) { index, response in
                        ResponseCard(response: response)
                            .frame(width: geometry.size.width)
                    }
                }
                .offset(x: -CGFloat(selectedIndex) * (geometry.size.width + 20) + dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            let velocity = value.predictedEndTranslation.width - value.translation.width
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if value.translation.width > threshold || velocity > 200 {
                                    // Swipe right
                                    if selectedIndex > 0 {
                                        selectedIndex -= 1
                                    }
                                } else if value.translation.width < -threshold || velocity < -200 {
                                    // Swipe left
                                    if selectedIndex < responses.count - 1 {
                                        selectedIndex += 1
                                    }
                                }
                                dragOffset = 0
                            }
                        }
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedIndex)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
            }
            .frame(height: 200) // Adjust height as needed
        }
    }
}

struct ResponseCard: View {
    let response: AIResponse
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
            
            if response.isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            } else if let error = response.error {
                ScrollView {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                ScrollView {
                    Text(response.content)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}