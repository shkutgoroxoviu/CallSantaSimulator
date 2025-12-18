//
//  ActiveCallController.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

final class ActiveCallController: UIViewController {

    private let contentView = ActiveContent()
    private let timeService = TimeService()
    private let santaAudioService = SantaAudioService()

    var currentType: PreviewContent.PreviewType = .audio

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AppCoordinator.shared.tabBarController?.hideTabBar()
        navigationController?.isNavigationBarHidden = true

        contentView.currentType = currentType
        setupUIBindings()

        startTimer()

        contentView.endButton.button.actionBlock = { [weak self] _ in
            self?.endCall()
        }
        santaAudioService.onError = { [weak self] error in
            guard let self else { return }
            contentView.errorView.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCall()
    }

    // MARK: - Timer

    private func startTimer() {
        timeService.onTick = { [weak self] seconds in
            self?.contentView.updateCallTimer(seconds)
        }
        timeService.start(mode: .timer)
    }

    // MARK: - Call Control

    private func startCall() {
        updateStatusForRecording(true)
        santaAudioService.startCall()
        monitorPlayback()
    }

    private func endCall() {
        timeService.stop()
        santaAudioService.endCall()
        AppCoordinator.shared.showCallEnded(previewType: currentType)
    }

    // MARK: - UI Updates

    private func setupUIBindings() {
        // Запуск и остановка индикатора записи можно проверять через таймер или KVO,
        // но проще — подписываться на события прямо после вызова сервиса
    }

    private func updateStatusForRecording(_ recording: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if recording {
                self.contentView.showRecordingIndicator()
                self.contentView.updateStatus("🎤 Speak…")
            } else {
                self.contentView.hideRecordingIndicator()
                self.contentView.updateStatus("⏳ Santa is listening…")
            }
        }
    }

    private func updateStatusForFiller() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentView.updateStatus("🎅 Santa thinks…")
        }
    }

    private func updateStatusForSantaReply() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentView.updateStatus("🎅 Santa says…")
        }
    }

    private func clearStatus() {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.updateStatus("")
        }
    }

    // MARK: - Playback Monitoring

    private func monitorPlayback() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            if self.santaAudioService.isPlaying {
                self.updateStatusForSantaReply()
            } else {
                self.updateStatusForRecording(true)
            }
        }
    }
}




