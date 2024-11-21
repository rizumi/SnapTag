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

    func fetch() -> [SnapTest] {
        return (try? context.fetch(FetchDescriptor<SnapTest>())) ?? []
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
            let path = try imageStorage.save(image: image, with: UUID().uuidString)
            context.insert(SnapTest(name: path))
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
