//
//  SetupViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import Foundation
import UIKit

@MainActor
final class SetupViewModel {

    private let repository: SnapRepositoryProtocol
    private let tagRecommender: TagRecommender
    private let flow: SetupViewFlow

    private let sampleImages = ["image1", "image2", "image3"]

    init(
        repository: SnapRepositoryProtocol,
        tagRecommender: TagRecommender,
        flow: SetupViewFlow
    ) {
        self.repository = repository
        self.tagRecommender = tagRecommender
        self.flow = flow
    }

    /// 初回起動時にデモ用のプリセット画像を保存するための処理
    func setupPresetSnaps() async {
        let images = sampleImages.compactMap { UIImage(named: $0) }
        await withDiscardingTaskGroup { group in
            for index in 0..<images.count {
                group.addTask {
                    await self.save(images[index])
                }
            }
        }

        flow.toSnapList()
    }

    private func save(_ image: UIImage) async {
        do {
            if let tag = try await tagRecommender.recommendTags(from: image).first {
                try repository.save(image, tagNames: [tag])
            } else {
                try repository.save(image, tagNames: [])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
