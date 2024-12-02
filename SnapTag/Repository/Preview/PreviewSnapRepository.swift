//
//  PreviewSnapRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

import UIKit

final class PreviewSnapRepository: SnapRepositoryProtocol {
    func fetch() throws -> [Snap] {
        let snapA = Snap(id: "a", imagePath: "image1", tags: [])
        let snapB = Snap(id: "b", imagePath: "image2", tags: [])
        let snapC = Snap(id: "c", imagePath: "image3", tags: [])

        return [snapA, snapB, snapC]
    }

    func load(name: String) -> UIImage? {
        return UIImage(named: name)
    }

    func save(_ image: UIImage, tagNames: [String]) throws {
    }

    func delete(_ snap: Snap) throws {
    }
}
