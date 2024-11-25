//
//  Tag.swift
//  SnapTag
//
//  Created by izumi on 2024/11/23.
//

import SwiftData

@Model
final class Tag {
    @Attribute(.unique) private(set) var name: String

    init(name: String) {
        self.name = name
    }
}
