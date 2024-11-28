//
//  SnapDetailViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import UIKit

/// @mockable
@MainActor
protocol SnapDetailViewFlow {
}

final class SnapDetailViewCoordinator: Coordinator {
    private var navigator: UINavigationController?
    private let snaps: [Snap]

    init(
        snaps: [Snap],
        navigator: UINavigationController
    ) {
        self.snaps = snaps
        self.navigator = navigator
    }

    func start() {
        let viewModel = SnapDetailViewModel(currentIndex: 0, snaps: snaps)
        let vc = SnapDetailViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen

        navigator?.present(vc, animated: true)
    }
}
