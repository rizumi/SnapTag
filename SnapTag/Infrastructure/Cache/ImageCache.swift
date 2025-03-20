import UIKit

final class ImageCache: @unchecked Sendable {
    static let shared = ImageCache()

    // NOTE: NSCacheはスレッドセーフなので @unchecked SendableにしてOK
    // https://developer.apple.com/documentation/foundation/nscache
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
