//
//  SnapRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import SwiftData
import UIKit

protocol SnapRepositoryProtocol {
    func fetch() -> [Snap]
    func load(name: String) -> UIImage?
    func save(_ image: UIImage, tagNames: [String])
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
        let sort = SortDescriptor(\Snap.imagePath)
        return (try? context.fetch(FetchDescriptor<Snap>(sortBy: [sort]))) ?? []
    }

    // TODO: タグによる絞り込みを追加

    func load(name: String) -> UIImage? {
        return imageStorage.loadImage(name: name)
    }

    func save(_ image: UIImage, tagNames: [String]) {
        do {
            // TODO: Imageのsaveを別にした方が良いか検討
            let path = try imageStorage.save(image: image, with: UUID().uuidString)
            let tagModels = tagNames.map { name in
                let tag = try? context.fetch(
                    FetchDescriptor<Tag>(
                        predicate: #Predicate {
                            $0.name == name
                        }
                    )
                )

                tag?.forEach({ tag in
                    print(tag.name)
                })

                if let tag = tag?.first {
                    return tag
                } else {
                    let tag = Tag(name: name)
                    return tag
                }
            }

            context.insert(Snap(imagePath: path, tags: tagModels))
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
