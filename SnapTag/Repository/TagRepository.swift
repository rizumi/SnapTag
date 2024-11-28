//
//  TagRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/11/26.
//

import SwiftData

/// @mockable
protocol TagRepositoryProtocol {
    func fetch() -> [Tag]
}

final class TagRepository: TagRepositoryProtocol {
    private let context: ModelContext

    init(
        context: ModelContext
    ) {
        self.context = context
    }

    func fetch() -> [Tag] {
        let tags = (try? context.fetch(FetchDescriptor<TagModel>())) ?? []
        return tags.map { $0.toTag() }
    }
}
