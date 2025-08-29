//
//  LibraryView.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Library")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your Song Ideas")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Placeholder for song library
                VStack {
                    Text("🎵")
                        .font(.system(size: 60))
                    
                    Text("Your Songs Will Appear Here")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("• Organize by date, project, or genre\n• Quick playback and editing\n• Export and share with collaborators")
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
    LibraryView()
}
