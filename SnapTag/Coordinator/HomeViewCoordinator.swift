//
//  RootViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/19.
//

import SwiftUI
import UIKit

protocol HomeViewFlow {
    func toSnapPicker()
}

final class HomeViewCoordinator: Coordinator {
    private let window: UIWindow
    private var navigator: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let vc = UIHostingController(
            rootView: HomeView(
                flow: self,
                viewModel: .init(
                    snapRepository: SnapRepository(
                        context: AppModelContainer.shared.modelContext,
                        imageStorage: LocalImageStorage())))
        )
        let nav = UINavigationController(rootViewController: vc)

        self.navigator = nav
        window.rootViewController = nav
    }
}

extension HomeViewCoordinator: HomeViewFlow {
    func toSnapPicker() {
        guard let navigator else { return }
        let coordinator = SnapPickerViewCoordinator(navigator: navigator)
        coordinator.start()
    }
}
