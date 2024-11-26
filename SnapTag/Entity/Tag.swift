//
//  Tag.swift
//  SnapTag
//
//  Created by izumi on 2024/11/23.
//

import Foundation
import SwiftData

@Model
final class Tag {
    @Attribute(.unique) private(set) var id: String = UUID().uuidString
    @Attribute(.unique) private(set) var name: String
    var snaps: [Snap] = []

    init(name: String) {
        self.name = name
    }
}
