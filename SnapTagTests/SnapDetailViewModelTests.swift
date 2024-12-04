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

    @Test("指定したSnapのindexとtagが設定されること")
    func testCurrentIndexPath() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let flow = SnapDetailViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "A", imageName: "", tags: [tagA])
        let snapB = Snap(id: "B", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "C", imageName: "", tags: [tagC])
        let snaps = [snapA, snapB, snapC]

        // Act
        let viewModel = SnapDetailViewModel(
            snap: snapB, snaps: snaps,
            repository: repository, flow: flow)

        // Assert
        #expect(viewModel.currentIndexPath == .init(item: 1, section: 0))
        #expect(viewModel.tags == [tagA.name, tagB.name])
    }

    @Test("指定したindexのSnapのindexとtagが設定されること")
    func testOnChangeSnap() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let flow = SnapDetailViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "A", imageName: "", tags: [tagA])
        let snapB = Snap(id: "B", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "C", imageName: "", tags: [tagC])
        let snaps = [snapA, snapB, snapC]
        let viewModel = SnapDetailViewModel(
            snap: snapB, snaps: snaps,
            repository: repository, flow: flow)

        // Act
        viewModel.onChangeSnap(0)

        // Assert
        #expect(viewModel.currentIndexPath == .init(item: 0, section: 0))
        #expect(viewModel.tags == [tagA.name])
    }

    @Test("showUIの状態がtoggleすること")
    func testOnTapView() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let flow = SnapDetailViewFlowMock()

        let snapA = Snap(id: "A", imageName: "", tags: [])
        let snaps = [snapA]
        let viewModel = SnapDetailViewModel(
            snap: snapA, snaps: snaps,
            repository: repository, flow: flow)

        // Act + Assert
        viewModel.onTapView()
        #expect(viewModel.showUI == false)

        viewModel.onTapView()
        #expect(viewModel.showUI == true)
    }

    @Test("削除後にtagが更新されること")
    func testDeleteSnap() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let flow = SnapDetailViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "A", imageName: "", tags: [tagA])
        let snapB = Snap(id: "B", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "C", imageName: "", tags: [tagC])
        let snaps = [snapA, snapB, snapC]

        let viewModel = SnapDetailViewModel(
            snap: snapA, snaps: snaps,
            repository: repository, flow: flow)

        // Act + Assert
        #expect(viewModel.tags == [tagA.name])
        await viewModel.deleteSnap()
        #expect(viewModel.tags == [tagA.name, tagB.name])
    }

    @Test("最後の1枚削除でdismissが呼ばれること")
    func testDeleteLastSnap() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let flow = SnapDetailViewFlowMock()

        let snapA = Snap(id: "A", imageName: "", tags: [])
        let snaps = [snapA]

        let viewModel = SnapDetailViewModel(
            snap: snapA, snaps: snaps,
            repository: repository, flow: flow)

        // Act
        await viewModel.deleteSnap()

        // Assert
        #expect(flow.dismissCallCount == 1)
    }

    @Test("削除失敗時にErrorが返ること")
    func testDeleteSnapError() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let flow = SnapDetailViewFlowMock()

        let snapA = Snap(id: "A", imageName: "", tags: [])
        let snaps = [snapA]

        repository.deleteHandler = { _ in
            throw SnapRepositoryError.deleteFailed
        }

        let viewModel = SnapDetailViewModel(
            snap: snapA, snaps: snaps,
            repository: repository, flow: flow)

        // Act
        await viewModel.deleteSnap()

        // Assert
        #expect(viewModel.errorState != nil)
        #expect(viewModel.errorState == .deleteFailed)
    }
}
