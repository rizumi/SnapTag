//
//  SnapPickerViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/22.
//

import SwiftUI
import UIKit

@MainActor
protocol SnapPickerViewFlow {
    func dismiss(isCompleted: Bool)
}

final class SnapPickerViewCoordinator: Coordinator {
    private let navigator: UINavigationController
    private let completion: () -> Void

    init(navigator: UINavigationController, completion: @escaping () -> Void) {
        self.navigator = navigator
        self.completion = completion
    }

    func start() {
        let vc = UIHostingController(
            rootView: SnapPickerView(
                viewModel: .init(
                    snapRepository: SnapRepository(
                        context: AppModelContainer.shared.modelContext,
                        imageStorage: LocalImageStorage())),
                flow: self)
        )
        navigator.present(vc, animated: true)
    }
}

extension SnapPickerViewCoordinator: SnapPickerViewFlow {
    func dismiss(isCompleted: Bool) {
        navigator.dismiss(animated: true) { [weak self] in
            if isCompleted {
                self?.completion()
            }
        }
    }
}
