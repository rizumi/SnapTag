//
//  RootViewCoordinator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/19.
//

import UIKit
import SwiftUI

protocol HomeViewFlow {
    func toUploadSnapView()
}

final class HomeViewCoordinator: Coordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let vc = UIHostingController(rootView: SnapPickerView())
        let nav = UINavigationController(rootViewController: vc)
        
        window.rootViewController = nav
    }
}

extension HomeViewCoordinator: HomeViewFlow {
    func toUploadSnapView() {
    }
}
