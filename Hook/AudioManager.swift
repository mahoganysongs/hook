//
//  AudioManager.swift
//  Hook
//
//  Created by Mark Murdoch on 29/08/2025.
//

import Foundation
import AVFoundation

struct Recording {
    let id = UUID()
    let url: URL
    let name: String
    let date: Date
    let duration: TimeInterval
}

class AudioManager: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var recordingTimer: Timer?
    private var playbackTimer: Timer?
    
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var hasPermission = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var playbackProgress: TimeInterval = 0
    @Published var currentRecordingURL: URL?
    @Published var recordings: [Recording] = []
    @Published var audioLevels: [Float] = []
    
    init() {
        setupAudioSession()
        loadSavedRecordings()
    }
    
    func setupAudioSession() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            // Request microphone permission
            recordingSession.requestRecordPermission { [weak self] allowed in
                DispatchQueue.main.async {
                    self?.hasPermission = allowed
                }
            }
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording() {
        guard hasPermission else {
            print("No microphone permission")
            return
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording-\(Date().timeIntervalSince1970).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            currentRecordingURL = audioFilename
            isRecording = true
            recordingDuration = 0
            audioLevels = []
            
            // Start recording timer
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateRecordingMetrics()
            }
            
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recordingTimer?.invalidate()
        recordingTimer = nil
        isRecording = false
    }
    
    private func updateRecordingMetrics() {
        guard let recorder = audioRecorder, recorder.isRecording else { return }
        
        recordingDuration = recorder.currentTime
        
        // Update audio levels for waveform
        recorder.updateMeters()
        let level = recorder.averagePower(forChannel: 0)
        let normalizedLevel = max(0, (level + 60) / 60) // Normalize -60dB to 0dB to 0-1 range
        audioLevels.append(normalizedLevel)
        
        // Keep only recent levels for performance
        if audioLevels.count > 200 {
            audioLevels.removeFirst()
        }
    }
    
    func playRecording() {
        guard let recorder = audioRecorder else { return }
        playRecording(url: recorder.url)
    }
    
    func playRecording(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isPlaying = true
            playbackProgress = 0
            
            // Start playback timer
            playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updatePlaybackProgress()
            }
            
        } catch {
            print("Could not play recording: \(error)")
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        playbackTimer?.invalidate()
        playbackTimer = nil
        isPlaying = false
        playbackProgress = 0
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        playbackTimer?.invalidate()
        playbackTimer = nil
        isPlaying = false
    }
    
    private func updatePlaybackProgress() {
        guard let player = audioPlayer else { return }
        playbackProgress = player.currentTime
        
        // Stop when playback finishes
        if !player.isPlaying {
            stopPlaying()
        }
    }
    
    func saveCurrentRecording(name: String) {
        guard let url = currentRecordingURL else { return }
        
        // Get duration of the recording
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            let duration = player.duration
            
            let recording = Recording(
                url: url,
                name: name.isEmpty ? "Recording \(recordings.count + 1)" : name,
                date: Date(),
                duration: duration
            )
            
            recordings.append(recording)
            saveRecordingsMetadata()
            
        } catch {
            print("Could not save recording: \(error)")
        }
    }
    
    func deleteRecording(_ recording: Recording) {
        // Remove file
        try? FileManager.default.removeItem(at: recording.url)
        
        // Remove from list
        recordings.removeAll { $0.id == recording.id }
        saveRecordingsMetadata()
    }
    
    private func loadSavedRecordings() {
        // Load recordings metadata from UserDefaults or Core Data
        // For now, scan the documents directory for .m4a files
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            let audioFiles = files.filter { $0.pathExtension == "m4a" }
            
            for file in audioFiles {
                do {
                    let player = try AVAudioPlayer(contentsOf: file)
                    let attributes = try FileManager.default.attributesOfItem(atPath: file.path)
                    let creationDate = attributes[.creationDate] as? Date ?? Date()
                    
                    let recording = Recording(
                        url: file,
                        name: file.lastPathComponent.replacingOccurrences(of: ".m4a", with: ""),
                        date: creationDate,
                        duration: player.duration
                    )
                    
                    recordings.append(recording)
                } catch {
                    print("Could not load recording: \(error)")
                }
            }
            
            // Sort by date (newest first)
            recordings.sort { $0.date > $1.date }
            
        } catch {
            print("Could not load recordings directory: \(error)")
        }
    }
    
    private func saveRecordingsMetadata() {
        // In a full implementation, this would save to Core Data
        // For now, we rely on file system scanning
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
