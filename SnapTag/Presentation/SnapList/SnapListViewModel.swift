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

    private let flow: SnapListViewFlow

    private var allSnaps: [Snap] = []

    init(
        snapRepository: SnapRepositoryProtocol,
        tagRepository: TagRepositoryProtocol,
        flow: SnapListViewFlow
    ) {
        self.snapRepository = snapRepository
        self.tagRepository = tagRepository
        self.flow = flow

        refresh()
        snaps = allSnaps
    }

    func refresh() {
        allSnaps = snapRepository.fetch()
        tags = tagRepository.fetch()
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

    func onTapActionButton() {
        flow.toSnapPicker { [weak self] in
            self?.refresh()
        }
    }

    func onSelectSnap(_ snap: Snap) {
        flow.toSnapDetail(snap: snap, snaps: snaps)
    }
}
