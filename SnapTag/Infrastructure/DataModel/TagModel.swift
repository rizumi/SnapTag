//
//  TagModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/23.
//

import Foundation
import SwiftData

@Model
final class TagModel {
    @Attribute(.unique) private(set) var id: String = UUID().uuidString
    @Attribute(.unique) private(set) var name: String
    private(set) var createdAt: Date = Date()
    private(set) var snaps: [SnapModel] = []

    init(name: String) {
        self.name = name
    }
}
