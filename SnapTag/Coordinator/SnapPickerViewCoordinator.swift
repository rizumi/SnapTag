//
//  SnapPickerViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/22.
//

import SwiftUI
import UIKit

protocol SnapPickerViewFlow {
    func dismiss()
}

final class SnapPickerViewCoordinator: Coordinator {
    private let navigator: UINavigationController

    init(navigator: UINavigationController) {
        self.navigator = navigator
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
    func dismiss() {
        navigator.dismiss(animated: true)
    }
}
