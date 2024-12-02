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
        let vc = UIHostingController(
            rootView: SnapUploadView(
                viewModel: .init(
                    snapRepository: SnapRepository(
                        context: AppModelContainer.shared.modelContext,
                        imageStorage: LocalImageStorage()),
                    recommender: CoreMLTagRecommender(),
                    flow: self)
            )
        )
        navigator.present(vc, animated: true)
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
