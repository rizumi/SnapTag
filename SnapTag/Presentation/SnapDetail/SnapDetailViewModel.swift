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
    let snapsSubject: CurrentValueSubject<[Snap], Never>
    var snaps: AnyPublisher<[Snap], Never> {
        snapsSubject.eraseToAnyPublisher()
    }

    @Published var tags: [String] = []

    var currentIndexPath: IndexPath {
        .init(item: snapsSubject.value.firstIndex(of: snap) ?? 0, section: 0)
    }

    init(snap: Snap, snaps: [Snap]) {
        self.snap = snap
        self.snapsSubject = .init(snaps)
        tags = snap.tags.map { $0.name }
    }

    func onChangeSnap(_ index: Int) {
        guard index < snapsSubject.value.count else { return }
        snap = snapsSubject.value[index]
        tags = snap.tags.map { $0.name }
    }
}
