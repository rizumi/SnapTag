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
        let viewController = UIHostingController(
            rootView: SetupView(
                viewModel: .init(
                    repository: SnapRepository(
                        modelContainer: AppModelContainer.shared.container,
                        imageStorage: LocalImageStorage.shared),
                    tagRecommender: CoreMLTagRecommender(),
                    flow: self
                ))
        )

        navigator.pushViewController(viewController, animated: false)
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
