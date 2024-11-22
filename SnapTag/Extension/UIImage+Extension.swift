//
//  UIImage+Extension.swift
//  SnapTag
//
//  Created by izumi on 2024/11/23.
//

import UIKit

extension UIImage {
    func resizedIfNeeded(maxSize: CGSize) -> UIImage? {
        let originalSize = self.size

        if originalSize.width <= maxSize.width && originalSize.height <= maxSize.height {
            return self
        }

        let ratioW = maxSize.width / originalSize.width
        let ratioH = maxSize.height / originalSize.height
        let scaleRatio = min(ratioW, ratioH)

        let newSize = CGSize(
            width: originalSize.width * scaleRatio,
            height: originalSize.height * scaleRatio
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
