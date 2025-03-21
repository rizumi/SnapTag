import Testing

@testable import SnapTag

@MainActor
struct SnapListViewModelTests {

    @Test("SnapとTagの一覧が取得されること")
    func testInit() async throws {
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        let imageLoader = ImageLoaderProtocolMock()
        let flow = SnapListViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "1", imageName: "", tags: [tagA])
        let snapB = Snap(id: "2", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "3", imageName: "", tags: [tagB])
        let snapD = Snap(id: "4", imageName: "", tags: [tagC])

        tagRepository.fetchHandler = {
            return [tagA, tagB, tagC]
        }
        snapRepository.fetchHandler = {
            return [snapA, snapB, snapC, snapD]
        }

        // Act
        let viewModel = SnapListViewModel(
            snapRepository: snapRepository,
            tagRepository: tagRepository,
            imageLoader: imageLoader,
            flow: flow)
        await viewModel.refresh()

        // Assert
        #expect(viewModel.tags == [tagA, tagB, tagC])
        #expect(viewModel.snaps == [snapA, snapB, snapC, snapD])
    }

    @Test("SnapとTagの一覧が更新されること")
    func testRefresh() async throws {
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        let imageLoader = ImageLoaderProtocolMock()
        let flow = SnapListViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "1", imageName: "", tags: [tagA])
        let snapB = Snap(id: "2", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "3", imageName: "", tags: [tagB])
        let snapD = Snap(id: "4", imageName: "", tags: [tagC])

        tagRepository.fetchHandler = {
            return [tagA, tagB, tagC]
        }
        snapRepository.fetchHandler = {
            return [snapA, snapB, snapC, snapD]
        }
        let viewModel = SnapListViewModel(
            snapRepository: snapRepository,
            tagRepository: tagRepository,
            imageLoader: imageLoader,
            flow: flow)
        await viewModel.refresh()

        tagRepository.fetchHandler = {
            return [tagA, tagC]
        }
        snapRepository.fetchHandler = {
            return [snapA, snapB, snapD]
        }

        // Act
        await viewModel.refresh()

        // Assert
        #expect(viewModel.tags == [tagA, tagC])
        #expect(viewModel.snaps == [snapA, snapB, snapD])
    }

    @Test("Snapのfetch失敗時にerrorStateがloadFailedとなること")
    func testFetchSnapError() async throws {
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        let imageLoader = ImageLoaderProtocolMock()
        let flow = SnapListViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        tagRepository.fetchHandler = {
            return [tagA, tagB, tagC]
        }
        snapRepository.fetchHandler = {
            throw SnapRepositoryError.fetchFailed
        }

        // Act
        let viewModel = SnapListViewModel(
            snapRepository: snapRepository,
            tagRepository: tagRepository,
            imageLoader: imageLoader,
            flow: flow)
        await viewModel.refresh()

        // Assert
        #expect(viewModel.snaps == [])
        #expect(viewModel.tags == [])
        #expect(viewModel.errorState == .loadFailed)
    }

    @Test("Tagのfetch失敗時にerrorStateがloadFailedとなること")
    func testFetchTagError() async throws {
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        let imageLoader = ImageLoaderProtocolMock()
        let flow = SnapListViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "1", imageName: "", tags: [tagA])
        let snapB = Snap(id: "2", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "3", imageName: "", tags: [tagB])
        let snapD = Snap(id: "4", imageName: "", tags: [tagC])

        tagRepository.fetchHandler = {
            throw TagRepositoryError.fetchFailed
        }
        snapRepository.fetchHandler = {
            return [snapA, snapB, snapC, snapD]
        }

        // Act
        let viewModel = SnapListViewModel(
            snapRepository: snapRepository,
            tagRepository: tagRepository,
            imageLoader: imageLoader,
            flow: flow)
        await viewModel.refresh()

        // Assert
        #expect(viewModel.snaps == [])
        #expect(viewModel.tags == [])
        #expect(viewModel.errorState == .loadFailed)
    }

    @Test("タグ選択時に該当タグを含むSnapに絞り込まれること")
    func testOnSelectedTag() async throws {
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        let imageLoader = ImageLoaderProtocolMock()
        let flow = SnapListViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "1", imageName: "", tags: [tagA])
        let snapB = Snap(id: "2", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "3", imageName: "", tags: [tagB])
        let snapD = Snap(id: "4", imageName: "", tags: [tagC])

        tagRepository.fetchHandler = {
            return [tagA, tagB, tagC]
        }
        snapRepository.fetchHandler = {
            return [snapA, snapB, snapC, snapD]
        }

        let viewModel = SnapListViewModel(
            snapRepository: snapRepository,
            tagRepository: tagRepository,
            imageLoader: imageLoader,
            flow: flow)

        // Act
        await viewModel.refresh()
        viewModel.onSelectedTag(tagA)

        // Assert
        #expect(viewModel.selectedTag == tagA)
        #expect(viewModel.snaps == [snapA, snapB])
        #expect(viewModel.scrollTo == snapA)
    }

    @Test("すべてを選択時にタグ選択がリセットされること")
    func testOnSelectedAll() async throws {
        // Arrange
        let snapRepository = SnapRepositoryProtocolMock()
        let tagRepository = TagRepositoryProtocolMock()
        let imageLoader = ImageLoaderProtocolMock()
        let flow = SnapListViewFlowMock()

        let tagA = Tag(id: "1", name: "a")
        let tagB = Tag(id: "2", name: "b")
        let tagC = Tag(id: "2", name: "c")

        let snapA = Snap(id: "1", imageName: "", tags: [tagA])
        let snapB = Snap(id: "2", imageName: "", tags: [tagA, tagB])
        let snapC = Snap(id: "3", imageName: "", tags: [tagB])
        let snapD = Snap(id: "4", imageName: "", tags: [tagC])

        tagRepository.fetchHandler = {
            return [tagA, tagB, tagC]
        }
        snapRepository.fetchHandler = {
            return [snapA, snapB, snapC, snapD]
        }

        let viewModel = SnapListViewModel(
            snapRepository: snapRepository,
            tagRepository: tagRepository,
            imageLoader: imageLoader,
            flow: flow)

        // Act
        await viewModel.refresh()
        viewModel.onSelectedTag(tagA)
        viewModel.onSelectedAll()

        // Assert
        #expect(viewModel.selectedTag == nil)
        #expect(viewModel.snaps == [snapA, snapB, snapC, snapD])
        #expect(viewModel.scrollTo == snapA)
    }
}
