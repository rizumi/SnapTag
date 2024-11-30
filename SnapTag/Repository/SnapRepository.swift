//
//  SnapRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import SwiftData
import UIKit

/// @mockable
protocol SnapRepositoryProtocol {
    func fetch() -> [Snap]
    func load(name: String) -> UIImage?
    func save(_ image: UIImage, tagNames: [String]) throws
}

enum SnapRepositoryError: Error {
    case saveFailed
}

final class SnapRepository: SnapRepositoryProtocol {
    private let context: ModelContext
    private let imageStorage: ImageStorage

    init(
        context: ModelContext,
        imageStorage: ImageStorage
    ) {
        self.context = context
        self.imageStorage = imageStorage
    }

    func fetch() -> [Snap] {
        let sort = SortDescriptor(\SnapModel.createdAt, order: .reverse)
        let models = (try? context.fetch(FetchDescriptor<SnapModel>(sortBy: [sort]))) ?? []
        return models.map { $0.toSnap() }
    }

    func load(name: String) -> UIImage? {
        return imageStorage.loadImage(name: name)
    }

    func save(_ image: UIImage, tagNames: [String]) throws {
        do {
            let path = try imageStorage.save(image: image, with: UUID().uuidString)
            let tagModels = tagNames.map { name in
                let tag = try? context.fetch(
                    FetchDescriptor<TagModel>(
                        predicate: #Predicate {
                            $0.name == name
                        }
                    )
                )

                if let tag = tag?.first {
                    return tag
                } else {
                    let tag = TagModel(name: name)
                    return tag
                }
            }

            context.insert(SnapModel(imagePath: path, tags: tagModels))
            try context.save()
        } catch {
            throw SnapRepositoryError.saveFailed
        }
    }
}
