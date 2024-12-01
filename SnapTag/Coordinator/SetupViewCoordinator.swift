//
//  SetupViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import SwiftUI
import UIKit

@MainActor
protocol SetupViewFlow {
    func toSnapList()
}

final class SetupViewCoordinator: Coordinator {
    private let navigator: UINavigationController

    init(navigator: UINavigationController) {
        self.navigator = navigator
    }

    func start() {
        let vc = UIHostingController(
            rootView: SetupView(
                viewModel: .init(
                    repository: SnapRepository(
                        context: AppModelContainer.shared.modelContext,
                        imageStorage: LocalImageStorage()),
                    tagRecommender: CoreMLTagRecommender(),
                    flow: self
                ))
        )

        navigator.pushViewController(vc, animated: false)
    }
}

extension SetupViewCoordinator: SetupViewFlow {
    func toSnapList() {
        let coordinator = SnapListViewCoordinator(navigator: navigator)
        // setup画面には戻れないようにする
        navigator.setViewControllers([], animated: false)
        coordinator.start()
    }
}
