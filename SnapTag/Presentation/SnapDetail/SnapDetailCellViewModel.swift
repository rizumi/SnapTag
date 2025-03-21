import UIKit

@MainActor
final class SnapDetailCellViewModel {

    private let snap: Snap
    private let imageLoader: ImageLoaderProtocol

    var image: UIImage? {
        return imageLoader.load(name: snap.imageName)
    }

    init(
        snap: Snap,
        imageLoader: ImageLoaderProtocol
    ) {
        self.snap = snap
        self.imageLoader = imageLoader
    }
}
