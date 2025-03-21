import Testing

@testable import SnapTag

@MainActor
struct SnapUploadViewModelTests {

    @Test("imageがセットされていてタグが5件未満の場合にはshowAddTagButtonがtrueになること")
    func testShowAddTagButton() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["1", "2", "3", "4", "5"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)

        // Act
        await viewModel.onSelectedImage(.init())

        // Assert
        #expect(viewModel.showAddTagButton == true)
    }

    @Test("imageがセットされていない場合はshowAddTagButtonがfalseになること")
    func testShowAddTagButtonImageNil() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["1", "2", "3", "4", "5"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)

        // Assert
        #expect(viewModel.showAddTagButton == false)
    }

    @Test("タグが6件以上の場合はshowAddTagButtonがfalseになること")
    func testShowAddTagButtonTagLimit() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["1", "2", "3", "4", "5", "6"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)

        // Act
        await viewModel.onSelectedImage(.init())

        // Assert
        #expect(viewModel.showAddTagButton == false)
    }

    @Test("保存完了後dismissが呼ばれること")
    func testOnTapSave() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        var result = false
        flow.dismissHandler = { isCompleted in
            result = isCompleted
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        await viewModel.onTapSave()

        // Assert
        #expect(flow.dismissCallCount == 1)
        #expect(result == true)
    }

    @Test("保存に失敗した場合場合保存でエラーが返ること")
    func testOnTapSaveError() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        repository.saveHandler = { _, _ in
            throw SnapRepositoryError.saveFailed
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        await viewModel.onTapSave()

        // Assert
        #expect(viewModel.errorState == .saveFailed)
    }

    @Test("Imageが選択されていない場合保存でエラーが返ること")
    func testOnTapSaveImageNil() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)

        // Act
        await viewModel.onTapSave()

        // Assert
        #expect(viewModel.errorState == .imageNotSelected)
    }

    @Test("Image選択後にタグが設定されること")
    func testOnSelectedImage() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["a", "b", "c"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)

        // Act
        await viewModel.onSelectedImage(.init())

        // Assert
        #expect(viewModel.tags == ["a", "b", "c"])
        #expect(viewModel.isRecommendingTags == false)
    }

    @Test("タグ推薦に失敗した場合エラーが設定されること")
    func testOnSelectedImageError() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            throw CoreMLTagRecommenderError.classificationFailed
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)

        // Act
        await viewModel.onSelectedImage(.init())

        // Assert
        #expect(viewModel.tags == [])
        #expect(viewModel.errorState == .tagRecommendFailed)
        #expect(viewModel.isRecommendingTags == false)
    }

    @Test("指定のタグが削除できること")
    func testOnTapDeleteTag() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["a", "b", "c"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        viewModel.onTapDeleteTag("b")

        // Assert
        #expect(viewModel.tags == ["a", "c"])
    }

    @Test("タグの追加ができること")
    func testAddTag() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["a", "b", "c"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        viewModel.tagText = "d"
        viewModel.onSubmitTagText()

        // Assert
        #expect(viewModel.tags == ["a", "b", "c", "d"])
    }

    @Test("空文字タグの追加ができないこと")
    func testAddEmptyTag() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["a", "b", "c"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        viewModel.tagText = ""
        viewModel.onSubmitTagText()

        // Assert
        #expect(viewModel.tags == ["a", "b", "c"])
    }

    @Test("重複タグの追加ができないこと")
    func testAddSameTag() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["a", "b", "c"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        viewModel.tagText = "b"
        viewModel.onSubmitTagText()

        // Assert
        #expect(viewModel.tags == ["a", "b", "c"])
    }

    @Test("11文字以上のタグが追加できないこと")
    func testAddTagLimit() async throws {
        // Arrange
        let repository = SnapRepositoryProtocolMock()
        let recommender = TagRecommenderMock()
        let flow = SnapUploadViewFlowMock()

        recommender.recommendTagsHandler = { _ in
            return ["a", "b", "c"]
        }

        let viewModel = SnapUploadViewModel(
            snapRepository: repository, recommender: recommender, flow: flow)
        await viewModel.onSelectedImage(.init())

        // Act
        viewModel.tagText = "12345678901"
        viewModel.onSubmitTagText()

        // Assert
        #expect(viewModel.tags == ["a", "b", "c"])
        #expect(viewModel.errorState == .tagLengthLimit)
    }
}
