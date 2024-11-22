//
//  HomeViewModel.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import Foundation
import UIKit

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var snaps: [Snap] = []
    private let snapRepository: SnapRepositoryProtocol

    init(snapRepository: SnapRepositoryProtocol) {
        self.snapRepository = snapRepository
    }

    func onAppear() {
        snaps = snapRepository.fetch()
    }

    func loadImage(path: String) -> UIImage? {
        return snapRepository.load(name: path)
    }
}
