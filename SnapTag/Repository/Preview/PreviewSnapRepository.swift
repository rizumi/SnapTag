//
//  PreviewSnapRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

#if DEBUG

import UIKit

final class PreviewSnapRepository: SnapRepositoryProtocol {
    func fetch() throws -> [Snap] {
        let snapA = Snap(id: "a", imageName: "image1", tags: [])
        let snapB = Snap(id: "b", imageName: "image2", tags: [])
        let snapC = Snap(id: "c", imageName: "image3", tags: [])

        return [snapA, snapB, snapC]
    }

    func save(_ image: UIImage, tagNames: [String]) throws {
    }

    func delete(_ snap: Snap) throws {
    }
}

#endif
