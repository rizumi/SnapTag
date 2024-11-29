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
    func toSnapDetail(snap: Snap, snaps: [Snap])
}

final class SnapListViewCoordinator: Coordinator {
    private let window: UIWindow
    private var navigator: UINavigationController?

    init(window: UIWindow) {
        self.window = window
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
        let nav = UINavigationController(rootViewController: vc)

        self.navigator = nav
        window.rootViewController = nav
    }
}

extension SnapListViewCoordinator: SnapListViewFlow {
    func toSnapPicker(_ completion: @escaping () -> Void) {
        guard let navigator else { return }
        let coordinator = SnapPickerViewCoordinator(navigator: navigator, completion: completion)
        coordinator.start()
    }

    func toSnapDetail(snap: Snap, snaps: [Snap]) {
        guard let navigator else { return }
        let coordinator = SnapDetailViewCoordinator(snap: snap, snaps: snaps, navigator: navigator)
        coordinator.start()
    }
}
