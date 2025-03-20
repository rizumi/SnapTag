#if DEBUG

import UIKit

final class PreviewImageLoader: ImageLoaderProtocol {
    func load(name: String) -> UIImage? {
        return UIImage(named: name)
    }
}

#endif
