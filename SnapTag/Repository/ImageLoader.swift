//
//  ImageLoader.swift
//  SnapTag
//
//  Created by izumi on 2024/12/05.
//

import UIKit

/// @mockable
protocol ImageLoaderProtocol {
    func load(name: String) -> UIImage?
}

final class ImageLoader: ImageLoaderProtocol {
    private let imageStorage: ImageStorage
    private let cache: ImageCache

    init(imageStorage: ImageStorage, cache: ImageCache = ImageCache.shared) {
        self.imageStorage = imageStorage
        self.cache = cache
    }

    func load(name: String) -> UIImage? {
        if let cachedImage = cache.getImage(forKey: name) {
            return cachedImage
        }
        if let image = imageStorage.loadImage(name: name) {
            cache.setImage(image, forKey: name)
            return image
        }

        return nil
    }
}
