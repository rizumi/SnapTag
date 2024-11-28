//
//  SnapListViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import Foundation
import UIKit

@MainActor
final class SnapListViewModel: ObservableObject {
    @Published private(set) var snaps: [Snap] = []
    @Published private(set) var tags: [Tag] = []
    @Published private(set) var selectedTag: Tag? = nil
    private let snapRepository: SnapRepositoryProtocol
    private let tagRepository: TagRepositoryProtocol
    private var allSnaps: [Snap] = []

    init(
        snapRepository: SnapRepositoryProtocol,
        tagRepository: TagRepositoryProtocol
    ) {
        self.snapRepository = snapRepository
        self.tagRepository = tagRepository
    }

    func refresh() {
        allSnaps = snapRepository.fetch()
        snaps = allSnaps
        tags = tagRepository.fetch()

        tags.forEach { tag in
            print(tag.id)
            print(tag.name)
        }
    }

    func loadImage(path: String) -> UIImage? {
        return snapRepository.load(name: path)
    }

    func onSelectedTag(_ tag: Tag) {
        selectedTag = tag
        snaps = allSnaps.filter { $0.tags.contains(tag) }
    }

    func onSelectedAll() {
        selectedTag = nil
        snaps = allSnaps
    }
}
