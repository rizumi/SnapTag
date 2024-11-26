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

    // iOS17ではRelationshipをoptionalにしないとinsert時にcrashする
    // 参考: https://forums.developer.apple.com/forums/thread/738961
    // TODO: inverseにしておくかどうか精査
    @Relationship(inverse: \Tag.snaps)
    private(set) var tags: [Tag]!

    init(imagePath: String, tags: [Tag]) {
        self.imagePath = imagePath
        self.tags = tags
    }
}
