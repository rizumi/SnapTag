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
    func dismiss()
    func onDelete(_ snap: Snap)
}

final class SnapDetailViewCoordinator: Coordinator {
    private let navigator: UINavigationController
    private let snap: Snap
    private let snaps: [Snap]
    private let onDelete: ((Snap) -> Void)?

    init(
        snap: Snap,
        snaps: [Snap],
        navigator: UINavigationController,
        onDelete: ((Snap) -> Void)?
    ) {
        self.snap = snap
        self.snaps = snaps
        self.navigator = navigator
        self.onDelete = onDelete
    }

    func start() {
        let repository = SnapRepository(
            modelContainer: AppModelContainer.shared, imageStorage: LocalImageStorage.shared)
        let viewModel = SnapDetailViewModel(
            snap: snap, snaps: snaps, repository: repository, flow: self)
        let viewController = SnapDetailViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve

        navigator.present(viewController, animated: true)
    }
}

extension SnapDetailViewCoordinator: SnapDetailViewFlow {
    func dismiss() {
        navigator.dismiss(animated: true)
    }

    func onDelete(_ snap: Snap) {
        onDelete?(snap)
    }
}
