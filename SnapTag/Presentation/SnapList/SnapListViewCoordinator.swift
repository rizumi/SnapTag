import SwiftUI
import UIKit

/// @mockable
@MainActor
protocol SnapListViewFlow {
    func toSnapUpload(_ completion: @escaping () -> Void)
    func toSnapDetail(snap: Snap, snaps: [Snap], onDelete: @escaping (Snap) -> Void)
}

final class SnapListViewCoordinator: Coordinator {
    private let navigator: UINavigationController

    init(navigator: UINavigationController) {
        self.navigator = navigator
    }

    func start() {
        let viewController = UIHostingController(
            rootView: SnapListView(
                viewModel: .init(
                    snapRepository: SnapRepository(
                        modelContainer: AppModelContainer.shared.container,
                        imageStorage: LocalImageStorage.shared),
                    tagRepository: TagRepository(
                        modelContainer: AppModelContainer.shared.container),
                    imageLoader: ImageLoader(imageStorage: LocalImageStorage.shared),
                    flow: self
                ))
        )
        navigator.pushViewController(viewController, animated: false)
    }
}

extension SnapListViewCoordinator: SnapListViewFlow {
    func toSnapUpload(_ completion: @escaping () -> Void) {
        let coordinator = SnapUploadViewCoordinator(navigator: navigator, completion: completion)
        coordinator.start()
    }

    func toSnapDetail(snap: Snap, snaps: [Snap], onDelete: @escaping (Snap) -> Void) {
        let coordinator = SnapDetailViewCoordinator(
            snap: snap, snaps: snaps,
            navigator: navigator, onDelete: onDelete)
        coordinator.start()
    }
}
