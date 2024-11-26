//
//  SnapListViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import Foundation
import UIKit

struct TagContent {
    var name: String
}

@MainActor
final class SnapListViewModel: ObservableObject {
    @Published private(set) var snaps: [Snap] = []
    @Published private(set) var tags: [Tag] = []
    private let snapRepository: SnapRepositoryProtocol
    private let tagRepository: TagRepositoryProtocol

    init(
        snapRepository: SnapRepositoryProtocol,
        tagRepository: TagRepositoryProtocol
    ) {
        self.snapRepository = snapRepository
        self.tagRepository = tagRepository
    }

    func refresh() {
        snaps = snapRepository.fetch()
        tags = tagRepository.fetch()

        tags.forEach { tag in
            print(tag.name)
            print(tag.snaps.map { $0.imagePath })
        }
    }

    func loadImage(path: String) -> UIImage? {
        return snapRepository.load(name: path)
    }
}
