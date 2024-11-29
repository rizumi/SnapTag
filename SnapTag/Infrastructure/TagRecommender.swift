//
//  TagRecommender.swift
//  SnapTag
//
//  Created by izumi on 2024/11/30.
//

import UIKit

protocol TagRecommender {
    func recommendTags(from image: UIImage) async throws -> [String]
}
