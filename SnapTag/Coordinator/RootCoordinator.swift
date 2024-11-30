//
//  RootCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/30.
//

import UIKit

final class RootCoordinator: Coordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let nav = UINavigationController()
        window.rootViewController = nav

        let coordinator = SnapListViewCoordinator(navigator: nav)
        coordinator.start()
    }
}
