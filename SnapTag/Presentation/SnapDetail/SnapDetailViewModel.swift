//
//  SnapDetailViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import Combine
import Foundation

@MainActor
final class SnapDetailViewModel: ObservableObject {

    @Published private(set) var snaps: [Snap] = []
    @Published private(set) var tags: [String] = []
    @Published private(set) var showUI: Bool = true
    @Published private(set) var presentedDeleteConfirmDialog: Bool = false

    var currentIndexPath: IndexPath {
        .init(item: currentIndex, section: 0)
    }

    private var currentIndex: Int
    private let flow: SnapDetailViewFlow

    init(snap: Snap, snaps: [Snap], flow: SnapDetailViewFlow) {
        self.snaps = snaps
        self.currentIndex = snaps.firstIndex(of: snap) ?? 0
        self.flow = flow
        tags = snap.tags.map { $0.name }
    }

    func onChangeSnap(_ index: Int) {
        currentIndex = min(max(index, 0), snaps.count - 1)
        tags = snaps[currentIndex].tags.map { $0.name }
    }

    func onTapView() {
        showUI.toggle()
    }

    func onTapDelete() {
        presentedDeleteConfirmDialog = true
    }

    func deleteSnap() {
        // TODO: repositoryを繋ぐ

        snaps.remove(at: currentIndex)
        if snaps.isEmpty {
            flow.dismiss()
        } else {
            onChangeSnap(currentIndex)
        }
    }
}
