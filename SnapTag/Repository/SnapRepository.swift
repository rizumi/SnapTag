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
    func fetch() throws -> [Snap]
    func load(name: String) -> UIImage?
    func save(_ image: UIImage, tagNames: [String]) throws
    func delete(_ snap: Snap) throws
}

enum SnapRepositoryError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
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

    func fetch() throws -> [Snap] {
        do {
            // 今は一度にまとめてfetchしているが、プロダクトとして運用する場合にはページングに対応した方が良い
            let sort = SortDescriptor(\SnapModel.createdAt, order: .reverse)
            let models = try context.fetch(FetchDescriptor<SnapModel>(sortBy: [sort]))
            return models.map { $0.toSnap() }
        } catch {
            throw SnapRepositoryError.fetchFailed
        }
    }

    func load(name: String) -> UIImage? {
        return imageStorage.loadImage(name: name)
    }

    func save(_ image: UIImage, tagNames: [String]) throws {
        do {
            let path = try imageStorage.save(image: image, with: UUID().uuidString)
            let tagModels: [TagModel] = try tagNames.compactMap { [weak self] name in
                guard let self else { return nil }
                let tag = try context.fetch(
                    FetchDescriptor<TagModel>(
                        predicate: #Predicate {
                            $0.name == name
                        }
                    )
                )

                if let tag = tag.first {
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

    func delete(_ snap: Snap) throws {
        let snapId = snap.id

        do {
            // TODO: ファイルの削除と切り分ける
            try context.delete(
                model: SnapModel.self,
                where: #Predicate<SnapModel> {
                    $0.id == snapId
                })
            try imageStorage.deleteImage(name: snap.imagePath)
        } catch {
            throw SnapRepositoryError.deleteFailed
        }
    }
}
