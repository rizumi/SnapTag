//
//  HomeViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import Foundation
import UIKit

@MainActor
final class HomeViewModel: ObservableObject {
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
    }

    func loadImage(path: String) -> UIImage? {
        return snapRepository.load(name: path)
    }
}
