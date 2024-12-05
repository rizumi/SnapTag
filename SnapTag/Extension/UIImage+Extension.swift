//
//  UIImage+Extension.swift
//  SnapTag
//
//  Created by izumi on 2024/11/23.
//

import UIKit

extension UIImage {
    func resizedIfNeeded(maxSize: CGSize) -> UIImage? {
        if size.width <= maxSize.width && size.height <= maxSize.height {
            return self
        }

        let ratioW = maxSize.width / size.width
        let ratioH = maxSize.height / size.height
        let scaleRatio = min(ratioW, ratioH)

        let newSize = CGSize(
            width: size.width * scaleRatio,
            height: size.height * scaleRatio
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
