//
//  SnapDetailViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import Foundation

@MainActor
final class SnapDetailViewModel {
    let snap: Snap
    let snaps: [Snap]

    var startIndexPath: IndexPath {
        .init(item: snaps.firstIndex(of: snap) ?? 0, section: 0)
    }

    init(snap: Snap, snaps: [Snap]) {
        self.snap = snap
        self.snaps = snaps
    }
}
