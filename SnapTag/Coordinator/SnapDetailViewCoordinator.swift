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

    init(navigator: UINavigationController) {
        self.navigator = navigator
    }

    func start() {
        let vc = SnapDetailViewController()
        vc.modalPresentationStyle = .fullScreen

        navigator?.present(vc, animated: true)
    }
}
