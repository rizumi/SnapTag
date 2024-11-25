//
//  Snap.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftData

@Model
final class Snap {
    private(set) var imagePath: String
    @Relationship private(set) var tags: [Tag]

    init(imagePath: String, tags: [Tag]) {
        self.imagePath = imagePath
        self.tags = tags
    }
}
