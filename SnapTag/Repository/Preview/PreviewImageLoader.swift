//
//  PreviewImageLoader.swift
//  SnapTag
//
//  Created by izumi on 2024/12/05.
//

#if DEBUG

import UIKit

final class PreviewImageLoader: ImageLoaderProtocol {
    func load(name: String) -> UIImage? {
        return UIImage(named: name)
    }
}

#endif
