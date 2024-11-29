//
//  SnapDetailViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import Combine
import Foundation

@MainActor
final class SnapDetailViewModel {
    private let snap: Snap
    let snapsSubject: CurrentValueSubject<[Snap], Never>
    var snaps: AnyPublisher<[Snap], Never> {
        snapsSubject.eraseToAnyPublisher()
    }

    var startIndexPath: IndexPath {
        .init(item: snapsSubject.value.firstIndex(of: snap) ?? 0, section: 0)
    }

    init(snap: Snap, snaps: [Snap]) {
        self.snap = snap
        self.snapsSubject = .init(snaps)
    }
}
