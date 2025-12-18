//
//  Ma.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class PreviewController: UIViewController {
    let contentView = PreviewContent()
    private let timeService = TimeService()

    private var isCheckingConnection = false

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppCoordinator.shared.tabBarController?.hideTabBar()
        navigationController?.isNavigationBarHidden = true

        timeService.onTick = { [weak self] sec in
            guard let self else { return }
            contentView.updateCountdown(sec)
        }

        contentView.backButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            navigationController?.popViewController(animated: true)
        }

        contentView.startCallButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            self.checkInternetAndStartCountdown()
        }

        contentView.tryAgainButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            self.checkInternetAndStartCountdown()
        }

        timeService.onFinished = { [weak self] in
            guard let self else { return }
            AppCoordinator.shared.showCall(previewType: contentView.currentType)
        }
    }

    private func checkInternetAndStartCountdown() {
        contentView.tryAgainButton.showLoading()
        contentView.startCallButton.showLoading()
        guard !isCheckingConnection else { return }
        isCheckingConnection = true

        let url = URL(string: "https://www.google.com")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isCheckingConnection = false

                if let _ = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    self.contentView.showValidateView()
                    self.timeService.start(mode: .countdown(from: 5))
                } else {
                    self.contentView.currentErrorType = .noWifi
                }
                contentView.tryAgainButton.hideLoading()
                contentView.startCallButton.hideLoading()
            }
        }.resume()
    }
}

