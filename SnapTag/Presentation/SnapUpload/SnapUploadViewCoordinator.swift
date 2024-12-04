//
//  SnapUploadViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/22.
//

import SwiftUI
import UIKit

/// @mockable
@MainActor
protocol SnapUploadViewFlow {
    func dismiss(isCompleted: Bool)
}

final class SnapUploadViewCoordinator: Coordinator {
    private let navigator: UINavigationController
    private let completion: () -> Void

    init(navigator: UINavigationController, completion: @escaping () -> Void) {
        self.navigator = navigator
        self.completion = completion
    }

    func start() {
        let viewController = UIHostingController(
            rootView: SnapUploadView(
                viewModel: .init(
                    snapRepository: SnapRepository(
                        modelContainer: AppModelContainer.shared.container,
                        imageStorage: LocalImageStorage.shared),
                    recommender: CoreMLTagRecommender(),
                    flow: self)
            )
        )
        navigator.present(viewController, animated: true)
    }
}

extension SnapUploadViewCoordinator: SnapUploadViewFlow {
    func dismiss(isCompleted: Bool) {
        navigator.dismiss(animated: true) { [weak self] in
            if isCompleted {
                self?.completion()
            }
        }
    }
}
