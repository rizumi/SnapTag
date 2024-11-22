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
    private let snapRepository: SnapRepository

    init(snapRepository: SnapRepository) {
        print("init")
        self.snapRepository = snapRepository
    }

    func onAppear() {
        print("onAppear")
        snaps = snapRepository.fetch()
    }

    func loadImage(path: String) -> UIImage? {
        print(path)
        return snapRepository.load(name: path)
    }
}
