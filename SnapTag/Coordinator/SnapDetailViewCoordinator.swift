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
    private let snap: Snap
    private let snaps: [Snap]

    init(
        snap: Snap,
        snaps: [Snap],
        navigator: UINavigationController
    ) {
        self.snap = snap
        self.snaps = snaps
        self.navigator = navigator
    }

    func start() {
        let viewModel = SnapDetailViewModel(snap: snap, snaps: snaps)
        let vc = SnapDetailViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen

        navigator?.present(vc, animated: true)
    }
}
