//
//  WriteView.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import SwiftUI

struct WriteView: View {
    @State private var lyricsText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Write")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Craft Your Lyrics")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Placeholder for lyric editor
                VStack {
                    Text("✍️")
                        .font(.system(size: 60))
                    
                    Text("Lyric Editor Coming Soon")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("• Drag & drop verse/chorus sections\n• Lyric assist with rhyme suggestions\n• Performance view for live singing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    WriteView()
}
