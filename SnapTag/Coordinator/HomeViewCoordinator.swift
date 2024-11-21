//
//  RootViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/19.
//

import SwiftUI
import UIKit

protocol HomeViewFlow {
    func toUploadSnapView()
}

final class HomeViewCoordinator: Coordinator {
    private let window: UIWindow
    private var navigator: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let vc = UIHostingController(
            rootView: HomeView(flow: self)
        )
        let nav = UINavigationController(rootViewController: vc)

        self.navigator = nav
        window.rootViewController = nav
    }
}

extension HomeViewCoordinator: HomeViewFlow {
    func toUploadSnapView() {
        guard let navigator else { return }
        let coordinator = SnapPickerViewCoordinator(navigator: navigator)
        coordinator.start()
    }
}
