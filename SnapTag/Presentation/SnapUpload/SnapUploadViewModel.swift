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

    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem?
    @Published var tags: [String] = []
    @Published var presentedPhotosPicker = false
    @Published var presentedSaveErrorAlert = false
    @Published var presentedImageNotSelectedErrorAlert = false

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
            presentedImageNotSelectedErrorAlert = true
            return
        }

        do {
            try snapRepository.save(image, tagNames: tags)
            flow.dismiss(isCompleted: true)
        } catch {
            presentedSaveErrorAlert = true
        }
    }

    func onTapDeleteTag(_ tag: String) {
        tags.removeAll { $0 == tag }
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
                // TODO error表示
                print(error)
            }
        }
    }
}
