//
//  SnapListViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/19.
//

import SwiftUI
import UIKit

/// @mockable
@MainActor
protocol SnapListViewFlow {
    func toSnapPicker(_ completion: @escaping () -> Void)
    func toSnapDetail(snap: Snap, snaps: [Snap], onDelete: @escaping (Snap) -> Void)
}

final class SnapListViewCoordinator: Coordinator {
    private var navigator: UINavigationController?

    init(navigator: UINavigationController) {
        self.navigator = navigator
    }

    func start() {
        let viewController = UIHostingController(
            rootView: SnapListView(
                viewModel: .init(
                    snapRepository: SnapRepository(
                        modelContainer: AppModelContainer.shared.container,
                        imageStorage: LocalImageStorage.shared),
                    tagRepository: TagRepository(
                        modelContainer: AppModelContainer.shared.container),
                    imageLoader: ImageLoader(imageStorage: LocalImageStorage.shared),
                    flow: self
                ))
        )
        viewController.modalPresentationStyle = .fullScreen
        navigator?.pushViewController(viewController, animated: false)
    }
}

extension SnapListViewCoordinator: SnapListViewFlow {
    func toSnapPicker(_ completion: @escaping () -> Void) {
        guard let navigator else { return }
        let coordinator = SnapUploadViewCoordinator(navigator: navigator, completion: completion)
        coordinator.start()
    }

    func toSnapDetail(snap: Snap, snaps: [Snap], onDelete: @escaping (Snap) -> Void) {
        guard let navigator else { return }
        let coordinator = SnapDetailViewCoordinator(
            snap: snap, snaps: snaps,
            navigator: navigator, onDelete: onDelete)
        coordinator.start()
    }
}
