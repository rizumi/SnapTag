//
//  SnapRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import SwiftData
import UIKit

final class SnapRepository {
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

    func add(_ test: SnapTest) {
        context.insert(test)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
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
