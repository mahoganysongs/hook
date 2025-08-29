//
//  RecordView.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import SwiftUI

struct RecordView: View {
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Record")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Capture Your Musical Ideas")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 20) {
                    // Record Button
                    Button(action: {
                        if audioManager.isRecording {
                            audioManager.stopRecording()
                        } else {
                            audioManager.startRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: audioManager.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.title)
                            Text(audioManager.isRecording ? "Stop Recording" : "Start Recording")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(audioManager.isRecording ? Color.red : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(!audioManager.hasPermission)
                    
                    // Play Button
                    Button(action: {
                        if audioManager.isPlaying {
                            audioManager.stopPlaying()
                        } else {
                            audioManager.playRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                            Text(audioManager.isPlaying ? "Stop Playback" : "Play Recording")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    // Permission Status
                    Text(audioManager.hasPermission ? "✓ Microphone Access Granted" : "❌ Microphone Permission Required")
                        .font(.caption)
                        .foregroundColor(audioManager.hasPermission ? .green : .red)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    RecordView()
}
