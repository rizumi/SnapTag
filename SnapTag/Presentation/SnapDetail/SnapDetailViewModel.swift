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

    private var snap: Snap
    @Published var snaps: [Snap] = []
    @Published var tags: [String] = []

    var currentIndexPath: IndexPath {
        .init(item: snaps.firstIndex(of: snap) ?? 0, section: 0)
    }

    init(snap: Snap, snaps: [Snap]) {
        self.snap = snap
        self.snaps = snaps
        tags = snap.tags.map { $0.name }
    }

    func onChangeSnap(_ index: Int) {
        guard index < snaps.count else { return }
        snap = snaps[index]
        tags = snap.tags.map { $0.name }
    }
}
