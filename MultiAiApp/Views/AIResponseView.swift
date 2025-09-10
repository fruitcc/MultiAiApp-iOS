import SwiftUI

struct AIResponseView: View {
    let responses: [AIResponse]
    @Binding var selectedIndex: Int
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
            
            if responses.indices.contains(selectedIndex) {
                let currentResponse = responses[selectedIndex]
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                    
                    if currentResponse.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                            Text("Loading...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } else if let error = currentResponse.error {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text(currentResponse.content)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            withAnimation(.spring()) {
                                if value.translation.width > threshold && selectedIndex > 0 {
                                    selectedIndex -= 1
                                } else if value.translation.width < -threshold && selectedIndex < responses.count - 1 {
                                    selectedIndex += 1
                                }
                                dragOffset = 0
                            }
                        }
                )
                .offset(x: dragOffset * 0.3)
            }
        }
    }
}