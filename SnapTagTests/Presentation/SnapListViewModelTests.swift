//
//  SnapListViewModelTests.swift
//  SnapTagTests
//
//  Created by izumi on 2024/11/28.
//

import Testing
@testable import SnapTag

@MainActor
struct SnapListViewModelTests {

    @Test func testOnSelectedTag() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        
        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")
        
        let snapA = Snap(id: "1", imagePath: "", tags: [tagA])
        let snapB = Snap(id: "2", imagePath: "", tags: [tagA, tagB])
        let snapC = Snap(id: "3", imagePath: "", tags: [tagB])
        let snapD = Snap(id: "4", imagePath: "", tags: [tagC])

        let snaps: [Snap] = {
            return [
                snapA, snapB, snapC, snapD
            ]
        }()
        
        snapRepository.fetchHandler = {
            return snaps
        }
        
        let viewModel = SnapListViewModel(snapRepository: snapRepository, tagRepository: tagRepository)
        viewModel.refresh()
        
        // Act
        viewModel.onSelectedTag(tagA)
        
        // Assert
        #expect(viewModel.snaps == [snapA, snapB])
    }

}
