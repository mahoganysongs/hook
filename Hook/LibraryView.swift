//
//  LibraryView.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject private var audioManager = AudioManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Library")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your Song Ideas")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                if audioManager.recordings.isEmpty {
                    // Empty state
                    VStack {
                        Text("🎵")
                            .font(.system(size: 60))
                        
                        Text("No Recordings Yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Record your first song idea in the Record tab!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                } else {
                    // Recordings list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(audioManager.recordings, id: \.id) { recording in
                                RecordingRowView(recording: recording)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct RecordingRowView: View {
    let recording: Recording
    @ObservedObject private var audioManager = AudioManager.shared
    @State private var showingDeleteConfirmation = false
    @State private var showingRenameDialog = false
    @State private var newName = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        newName = recording.name
                        showingRenameDialog = true
                    }) {
                        Text(recording.name)
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                    }
                    
                    Text(formatDate(recording.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(audioManager.formatDuration(recording.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.stopPlaying()
                    } else {
                        audioManager.playRecording(url: recording.url)
                    }
                }) {
                    HStack {
                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        Text(audioManager.isPlaying ? "Pause" : "Play")
                            .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.cyan)
                    .cornerRadius(6)
                }
                
                Spacer()
                
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .confirmationDialog("Delete Recording", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                audioManager.deleteRecording(recording)
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Rename Recording", isPresented: $showingRenameDialog) {
            TextField("Recording Name", text: $newName)
            Button("Save") {
                audioManager.renameRecording(recording, newName: newName)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter a new name for this recording")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    LibraryView()
}

#Preview {
    LibraryView()
}
