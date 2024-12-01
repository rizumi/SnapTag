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

        updateSnaps()
    }

    func loadImage(path: String) -> UIImage? {
        return snapRepository.load(name: path)
    }

    func onSelectedTag(_ tag: Tag) {
        selectedTag = tag
        updateSnaps()
    }

    func onSelectedAll() {
        selectedTag = nil
        updateSnaps()
    }

    func onTapActionButton() {
        flow.toSnapPicker { [weak self] in
            self?.refresh()
        }
    }

    func onSelectSnap(_ snap: Snap) {
        flow.toSnapDetail(snap: snap, snaps: snaps) { [weak self] snap in
            guard let self else { return }

            if let index = allSnaps.firstIndex(of: snap) {
                allSnaps.remove(at: index)

                // 写真が削除されタグが0件になった場合選択中の状態をすべてに戻す
                tags = tagRepository.fetch()
                if let selectedTag = selectedTag, !tags.contains(selectedTag) {
                    self.selectedTag = nil
                }

                updateSnaps()
            }
        }
    }

    private func updateSnaps() {
        if let selectedTag = selectedTag {
            snaps = allSnaps.filter { $0.tags.contains(selectedTag) }
        } else {
            snaps = allSnaps
        }
    }
}
