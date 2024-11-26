//
//  TagRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/11/26.
//

import SwiftData

/// @mockable
protocol TagRepositoryProtocol {
    func fetch() -> [TagContent]
}

final class TagRepository: TagRepositoryProtocol {
    private let context: ModelContext

    init(
        context: ModelContext
    ) {
        self.context = context
    }

    func fetch() -> [TagContent] {
        let tags = (try? context.fetch(FetchDescriptor<Tag>())) ?? []
        return tags.map { .init(name: $0.name) }
    }
}
