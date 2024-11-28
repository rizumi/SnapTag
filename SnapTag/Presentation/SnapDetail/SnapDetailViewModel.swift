//
//  SnapDetailViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

@MainActor
final class SnapDetailViewModel {
    var currentIndex: Int = 0
    var snaps: [Snap] = []

    init(currentIndex: Int, snaps: [Snap]) {
        self.currentIndex = currentIndex
        self.snaps = snaps
    }
}
