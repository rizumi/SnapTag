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

        let repo = TagRepository(context: AppModelContainer.shared.modelContext)
        let tags = repo.fetch()
        tags.forEach { tag in
            print(tag.name)
            print(tag.snaps.map { $0.imagePath })
        }
    }

    func loadImage(path: String) -> UIImage? {
        return snapRepository.load(name: path)
    }
}
