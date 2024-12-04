//
//  SnapDetailCellViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import UIKit

@MainActor
final class SnapDetailCellViewModel {

    private let snap: Snap
    private let snapRepository: SnapRepositoryProtocol

    var image: UIImage? {
        return snapRepository.loadImage(name: snap.imageName)
    }

    init(
        snap: Snap,
        snapRepository: SnapRepositoryProtocol
    ) {
        self.snap = snap
        self.snapRepository = snapRepository
    }
}
