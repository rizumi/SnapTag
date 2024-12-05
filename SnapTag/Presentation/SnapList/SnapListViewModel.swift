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
    @Published private(set) var errorState: PresentationError?
    @Published var scrollTo: Snap?

    private let snapRepository: SnapRepositoryProtocol
    private let tagRepository: TagRepositoryProtocol
    private let imageLoader: ImageLoaderProtocol

    private let flow: SnapListViewFlow

    private var allSnaps: [Snap] = []

    init(
        snapRepository: SnapRepositoryProtocol,
        tagRepository: TagRepositoryProtocol,
        imageLoader: ImageLoaderProtocol,
        flow: SnapListViewFlow
    ) {
        self.snapRepository = snapRepository
        self.tagRepository = tagRepository
        self.imageLoader = imageLoader
        self.flow = flow
    }

    func refresh() async {
        do {
            async let allSnaps = try await snapRepository.fetch()
            async let tags = try await tagRepository.fetch()

            (self.allSnaps, self.tags) = try await (allSnaps, tags)
            updateSnaps()
        } catch let error as RepositoryError {
            errorState = error.toPresentationError()
        } catch {
            errorState = .loadFailed
        }
    }

    func loadImage(name: String) -> UIImage? {
        return imageLoader.load(name: name)
    }

    func onSelectedTag(_ tag: Tag) {
        selectedTag = tag
        updateSnaps()
        scrollTo = snaps.first
    }

    func onSelectedAll() {
        selectedTag = nil
        updateSnaps()
        scrollTo = snaps.first
    }

    func onTapActionButton() {
        flow.toSnapUpload { [weak self] in
            Task {
                await self?.refresh()
            }
        }
    }

    func onSelectSnap(_ snap: Snap) {
        flow.toSnapDetail(snap: snap, snaps: snaps) { [weak self] snap in
            guard let self else { return }
            Task {
                if let index = allSnaps.firstIndex(of: snap) {
                    allSnaps.remove(at: index)

                    // 写真が削除されタグが0件になった場合、タグ選択をリセットする
                    tags = (try? await tagRepository.fetch()) ?? tags
                    if let selectedTag = selectedTag, !tags.contains(selectedTag) {
                        self.selectedTag = nil
                    }

                    updateSnaps()
                }
            }
        }
    }

    func onDismissErrorAlert() {
        errorState = nil
    }

    private func updateSnaps() {
        if let selectedTag = selectedTag {
            snaps = allSnaps.filter { $0.tags.contains(selectedTag) }
        } else {
            snaps = allSnaps
        }
    }
}
