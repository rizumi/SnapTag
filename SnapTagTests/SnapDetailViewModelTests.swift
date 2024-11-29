//
//  SnapDetailViewModelTests.swift
//  SnapTagTests
//
//  Created by izumi on 2024/11/30.
//

import Testing
@testable import SnapTag

@MainActor
struct SnapDetailViewModelTests {

    @Test("指定したSnapのindexがstartIndexPathに設定されること")
    func testStartIndexPath() async throws {
        // Arrange
        let snapA = Snap(id: "A", imagePath: "", tags: [])
        let snapB = Snap(id: "B", imagePath: "", tags: [])
        let snapC = Snap(id: "C", imagePath: "", tags: [])
        let snaps = [snapA, snapB, snapC]

        // Act
        let viewModel = SnapDetailViewModel(snap: snapB, snaps: snaps)

        // Assert
        #expect(viewModel.startIndexPath == .init(item: 1, section: 0))
    }

}
