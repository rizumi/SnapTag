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
        let vc = UIHostingController(
            rootView: SnapListView(
                viewModel: .init(
                    snapRepository: SnapRepository(
                        context: AppModelContainer.shared.modelContext,
                        imageStorage: LocalImageStorage()),
                    tagRepository: TagRepository(context: AppModelContainer.shared.modelContext),
                    flow: self
                ))
        )
        vc.modalPresentationStyle = .fullScreen
        navigator?.pushViewController(vc, animated: false)
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
