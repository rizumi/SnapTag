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
    func save(_ image: UIImage, tags: [String])
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
        return (try? context.fetch(FetchDescriptor<Snap>())) ?? []
    }

    func load(name: String) -> UIImage? {
        return imageStorage.loadImage(name: name)
    }

    func save(_ image: UIImage, tags: [String]) {
        do {
            // TODO: Imageのsaveを別にした方が良いか検討
            let path = try imageStorage.save(image: image, with: UUID().uuidString)
            context.insert(Snap(imagePath: path, tags: []))
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
