//
//  SantaAudioService.swift
//  SantaCallSimulator
//
//  Created by b on 17.12.2025.
//

import Foundation
import AVFoundation

// MARK: - Models

struct SantaAudioResponse: Codable {
    let replyText: String
    let replyAudioBase64: String

    enum CodingKeys: String, CodingKey {
        case replyText = "reply_text"
        case replyAudioBase64 = "reply_audio_base64"
    }
}

// MARK: - Service

final class SantaAudioService: NSObject {
    var onError: ((Error) -> Void)?

    // MARK: - Audio
    private let session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
    private var fillerPlayer: AVAudioPlayer?
    private var santaPlayer: AVAudioPlayer?

    private var isCallActive = false
    private var levelTimer: Timer?
    private var silenceTime: TimeInterval = 0
    private var recordStartTime: Date?

    // MARK: - Settings
    private let silenceThreshold: Float = -40
    private let silenceLimit: TimeInterval = 1.2
    private let maxRecordDuration: TimeInterval = 15
    
    var isPlaying: Bool {
        return santaPlayer?.isPlaying ?? false
    }

    private let fillerAudioFiles = [
        "HoHoHo_BeforeSan",
        "HoHoHo_DontRush",
        "HoHoHo_EvenSanta",
        "HoHoHo_JustALit",
        "HoHoHo_StayWith",
        "JustATinyWait",
        "JustHoldOn",
        "SantaIsHere",
        "WellNow_HoHoHo"
    ]

    var baseURL = "https://fastapi.kreaai.inc/santa/api/santa/audio"

    // MARK: - Call Control
    func startCall() {
        isCallActive = true
        startRecording()
    }

    func endCall() {
        isCallActive = false
        stopRecording()
        stopPlayback()
    }

    // MARK: - Recording
    private func startRecording() {
        guard isCallActive else { return }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".wav")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try session.setActive(true)
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.record()
        } catch {
            print("Error starting recording:", error)
            return
        }

        recordStartTime = Date()
        silenceTime = 0
        startLevelMonitoring()
    }

    private func stopRecording() {
        levelTimer?.invalidate()
        levelTimer = nil
        recorder?.stop()

        if let url = recorder?.url {
            sendAudio(url)
        }

        recorder = nil
    }

    // MARK: - Silence detection
    private func startLevelMonitoring() {
        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            self?.checkLevel()
        }
    }

    private func checkLevel() {
        guard let recorder else { return }

        recorder.updateMeters()
        let level = recorder.averagePower(forChannel: 0)

        if level > silenceThreshold {
            silenceTime = 0
        } else {
            silenceTime += 0.15
        }

        if silenceTime > silenceLimit ||
            Date().timeIntervalSince(recordStartTime ?? Date()) > maxRecordDuration {
            stopRecording()
        }
    }

    // MARK: - Send to API
    private func sendAudio(_ url: URL) {
        playFiller()

        guard let audioData = try? Data(contentsOf: url) else { return }

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.wav\"\r\n")
        body.append("Content-Type: audio/wav\r\n\r\n")
        body.append(audioData)
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self, let data else { return }
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.onError?(error)
                }
                return
            }
            guard let response = try? JSONDecoder().decode(SantaAudioResponse.self, from: data) else {
                DispatchQueue.main.async {
                    self.onError?(NSError(domain: "SantaAudioService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.playSanta(response)
            }
        }.resume()
    }

    // MARK: - Playback

    private func playFiller() {
        guard let fillerName = fillerAudioFiles.randomElement(),
              let url = Bundle.main.url(forResource: fillerName, withExtension: "caf") else { return }

        do {
            fillerPlayer = try AVAudioPlayer(contentsOf: url)
            fillerPlayer?.delegate = self
            fillerPlayer?.play()
        } catch {
            print("Error playing filler:", error)
        }
    }

    private func playSanta(_ response: SantaAudioResponse) {
        guard let audioData = Data(base64Encoded: response.replyAudioBase64) else {
            startRecording()
            return
        }

        do {
            santaPlayer = try AVAudioPlayer(data: audioData)
            santaPlayer?.delegate = self
            santaPlayer?.play()
        } catch {
            print("Error playing Santa reply:", error)
            startRecording()
        }
    }

    private func stopPlayback() {
        fillerPlayer?.stop()
        santaPlayer?.stop()
    }
}

// MARK: - AVAudioPlayerDelegate

extension SantaAudioService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard isCallActive else { return }

        if player == santaPlayer {
            startRecording()
        }
    }
}

// MARK: - Data append

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
