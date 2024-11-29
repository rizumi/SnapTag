//
//  ImageStorage.swift
//  SnapTag
//
//  Created by izumi on 2024/11/22.
//

import Foundation
import UIKit

protocol ImageStorage {
    func save(image: UIImage, with name: String) throws -> String
    func loadImage(name: String) -> UIImage?
    func deleteImage(path: String) throws
}
