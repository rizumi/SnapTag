//
//  SnapPickerViewModel.swift
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
final class SnapPickerViewModel: ObservableObject {

    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem?
    @Published var tags: [String] = []

    private let snapRepository: SnapRepositoryProtocol

    private var cancellables: Set<AnyCancellable> = []

    init(snapRepository: SnapRepositoryProtocol) {
        self.snapRepository = snapRepository

        $selectedItem
            .compactMap { $0 }
            .sink { [weak self] item in
                self?.onChangeSelectedItem(item: item)
            }
            .store(in: &cancellables)
    }

    func onTapSave() {
        guard let image = selectedImage else {
            print("image not selected")
            return
        }

        snapRepository.save(image, tags: tags)
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
                    let snapTagger = SnapTagger()
                    tags = try await snapTagger.generateTags(from: uiImage)
                }
            } catch {
                // TODO error表示
                print(error)
            }
        }
    }
}
