//
//  SnapUploadViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import Combine
import Foundation
import PhotosUI
import SwiftUI
import UIKit

@MainActor
final class SnapUploadViewModel: ObservableObject {

    @Published var selectedItem: PhotosPickerItem?
    @Published var presentedPhotosPicker = false
    @Published var presentedAddTagAlert = false
    @Published var tagText: String = ""

    @Published private(set) var selectedImage: UIImage?
    @Published private(set) var tags: [String] = []
    @Published private(set) var errorState: PresentationError?

    var showAddTagButton: Bool {
        selectedImage != nil && tags.count <= 5
    }

    private let snapRepository: SnapRepositoryProtocol
    private let flow: SnapUploadViewFlow

    private var cancellables: Set<AnyCancellable> = []

    init(
        snapRepository: SnapRepositoryProtocol,
        flow: SnapUploadViewFlow
    ) {
        self.snapRepository = snapRepository
        self.flow = flow

        $selectedItem
            .compactMap { $0 }
            .sink { [weak self] item in
                self?.onChangeSelectedItem(item: item)
            }
            .store(in: &cancellables)
    }

    func showPhotoPicker() {
        presentedPhotosPicker = true
    }

    func onTapSave() {
        guard let image = selectedImage else {
            errorState = .imageNotSelected
            return
        }

        do {
            try snapRepository.save(image, tagNames: tags)
            flow.dismiss(isCompleted: true)
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

    func addTag() {
        guard !tagText.isEmpty else { return }
        // TODO: 文字数制限をするならここ
        tags.append(tagText)
        tagText = ""
    }

    func onDismissErrorAlert() {
        guard let error = errorState else { return }
        if error == .imageNotSelected {
            presentedPhotosPicker = true
        }

        errorState = nil
    }

    private func onChangeSelectedItem(item: PhotosPickerItem) {
        Task {
            defer {
                selectedItem = nil
            }

            do {
                if let data = try await item.loadTransferable(type: Data.self),
                    let uiImage = UIImage(data: data)
                {
                    selectedImage = uiImage

                    // TODO: SnapTaggerをDIする
                    let recommender = CoreMLTagRecommender()
                    tags = try await recommender.recommendTags(from: uiImage)
                }
            } catch {
                errorState = .tagRecommendFailed
            }
        }
    }
}
