//
//  Snap.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import Foundation
import SwiftData

@Model
final class SnapModel {
    @Attribute(.unique) private(set) var id: String = UUID().uuidString
    private(set) var imagePath: String

    // iOS17ではRelationshipをoptionalにしないとinsert時にcrashする
    // 参考: https://forums.developer.apple.com/forums/thread/738961
    // TODO: inverseにしておくかどうか精査
    @Relationship(inverse: \TagModel.snaps)
    private(set) var tags: [TagModel]!

    init(imagePath: String, tags: [TagModel]) {
        self.imagePath = imagePath
        self.tags = tags
    }
}
