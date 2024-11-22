//
//  Snap.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftData

@Model
class Snap {
    private(set) var imagePath: String
    private(set) var tags: [String]  // TODO: tag型にする

    init(imagePath: String, tags: [String]) {
        self.imagePath = imagePath
        self.tags = tags
    }
}
