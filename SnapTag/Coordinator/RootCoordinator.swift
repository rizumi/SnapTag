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
        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        if AppLaunchChecker().ifFirstLaunch {
            let coordinator = SetupViewCoordinator(navigator: navigationController)
            coordinator.start()
        } else {
            let coordinator = SnapListViewCoordinator(navigator: navigationController)
            coordinator.start()
        }
    }
}
