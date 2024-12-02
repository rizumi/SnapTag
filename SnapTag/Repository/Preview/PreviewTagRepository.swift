//
//  PreviewTagRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

#if DEBUG

import UIKit

final class PreviewTagRepository: TagRepositoryProtocol {
    func fetch() throws -> [Tag] {
        return [.init(id: "a", name: "TagA"), .init(id: "b", name: "TagB")]
    }
}

#endif
