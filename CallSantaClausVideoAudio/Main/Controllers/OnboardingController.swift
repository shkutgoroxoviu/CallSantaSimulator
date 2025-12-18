//
//  OnboardingViewController.swift
//  SantaCallSimulator
//
//  Created by b on 11.12.2025.
//

import UIKit

class OnboardingController: UIViewController {
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            image: .santaOnboarding,
            title: "Video Call from Santa –\nShow Kids the Holidays",
            description: "Choose the right scenario and start a realistic\nvideo call with Santa to give your child\nan unforgettable surprise."
        ),
        OnboardingPage(
            image: .boyOnboarding,
            title: "Voice call - a quick surprise",
            description: "Select the appropriate message and your phone\nwill ring with a greeting from Santa."
        )
    ]
    
    var currentIndex = 0
    
    let contentView = OnboardingContent()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePage()
        contentView.nextButton.actionBlock = { [weak self] _ in
            guard let self else { return }
            if currentIndex == 1 {
                AppCoordinator.shared.showOnboardingBenefits()
                return
            }
            currentIndex = 1
            updatePage(index: 1)
        }
    }
    
    private func updatePage(index: Int = 0) {
        contentView.setPageInfo(info: pages[index])
    }
}
