import Foundation
import SwiftUI
import UIKit

@MainActor
final class SnapUploadViewModel: ObservableObject {

    @Published var presentedPhotosPicker = false
    @Published var presentedAddTagAlert = false
    @Published var tagText: String = ""

    @Published private(set) var selectedImage: UIImage?
    @Published private(set) var tags: [String] = []
    @Published private(set) var errorState: PresentationError?
    @Published private(set) var isRecommendingTags: Bool = false

    var showAddTagButton: Bool {
        selectedImage != nil && tags.count < Constants.tagLimit
    }

    private let snapRepository: SnapRepositoryProtocol
    private let recommender: TagRecommender
    private let flow: SnapUploadViewFlow

    init(
        snapRepository: SnapRepositoryProtocol,
        recommender: TagRecommender,
        flow: SnapUploadViewFlow
    ) {
        self.snapRepository = snapRepository
        self.recommender = recommender
        self.flow = flow
    }

    func showPhotoPicker() {
        presentedPhotosPicker = true
    }

    func onTapSave() async {
        guard let image = selectedImage else {
            errorState = .imageNotSelected
            return
        }

        do {
            try await snapRepository.save(image, tagNames: tags)
            flow.dismiss(isCompleted: true)
        } catch let error as RepositoryError {
            errorState = error.toPresentationError()
        } catch {
            errorState = .saveFailed
        }
    }

    func onTapCancel() {
        flow.dismiss(isCompleted: false)
    }

    func onTapDeleteTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    func onTapAddTag() {
        presentedAddTagAlert = true
    }

    func onSubmitTagText() {
        defer { tagText = "" }

        if tagText.isEmpty { return }
        if tags.contains(tagText) { return }
        guard tagText.count <= Constants.tagCharacterLimit else {
            errorState = .tagLengthLimit
            return
        }

        tags.append(tagText)
    }

    func onDismissErrorAlert() {
        guard let error = errorState else { return }
        if error == .imageNotSelected {
            presentedPhotosPicker = true
        }

        errorState = nil
    }

    func onSelectedImage(_ image: UIImage) async {
        isRecommendingTags = true
        defer {
            isRecommendingTags = false
        }

        do {
            selectedImage = image
            tags = try await recommender.recommendTags(from: image)
        } catch {
            errorState = .tagRecommendFailed
        }
    }
}
