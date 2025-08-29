//
//  WaveformView.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import SwiftUI

struct WaveformView: View {
    let audioLevels: [Float]
    let isRecording: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(Array(audioLevels.enumerated()), id: \.offset) { index, level in
                Rectangle()
                    .fill(isRecording ? Color.red : Color.cyan)
                    .frame(width: 3, height: max(4, CGFloat(level) * 50))
                    .opacity(isRecording ? (level > 0.1 ? 1.0 : 0.5) : 0.7)
                    .animation(.easeInOut(duration: 0.1), value: level)
            }
        }
        .frame(height: 60)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
    }
}

#Preview {
    WaveformView(audioLevels: Array(repeating: 0.5, count: 50), isRecording: true)
}
