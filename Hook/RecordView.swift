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
            VStack(spacing: 20) {
                Text("Record")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Capture Your Musical Ideas")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Recording Duration
                if audioManager.isRecording || audioManager.recordingDuration > 0 {
                    Text(audioManager.formatDuration(audioManager.recordingDuration))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(audioManager.isRecording ? .red : .primary)
                }
                
                // Waveform Visualization
                if !audioManager.audioLevels.isEmpty {
                    WaveformView(audioLevels: audioManager.audioLevels, isRecording: audioManager.isRecording)
                        .padding(.horizontal)
                }
                
                // Control Buttons
                VStack(spacing: 15) {
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
                    
                    // Playback Controls
                    if audioManager.currentRecordingURL != nil {
                        HStack(spacing: 15) {
                            Button(action: {
                                if audioManager.isPlaying {
                                    audioManager.pausePlaying()
                                } else {
                                    audioManager.playRecording()
                                }
                            }) {
                                HStack {
                                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.title2)
                                    Text(audioManager.isPlaying ? "Pause" : "Play")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.green)
                                .cornerRadius(8)
                            }
                            
                            Button("Save to Library") {
                                audioManager.saveCurrentRecording()
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.orange)
                            .cornerRadius(8)
                        }
                        
                        // Playback Progress
                        if audioManager.isPlaying && audioManager.playbackProgress > 0 {
                            VStack {
                                Text("Playing: \(audioManager.formatDuration(audioManager.playbackProgress))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Permission Status
                if !audioManager.hasPermission {
                    Text("❌ Microphone Permission Required")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
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
