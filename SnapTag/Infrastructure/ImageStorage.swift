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
    func loadImage(path: String) -> UIImage?
    func deleteImage(path: String) throws
}

final class LocalImageStorage: ImageStorage {
    private let directory: URL

    init() {
        let directoryName = "Images"
        let fileManager = FileManager.default
        self.directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(directoryName)

        if !fileManager.fileExists(atPath: directory.path) {
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }

    func save(image: UIImage, with name: String) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(
                domain: "ImageStorageError", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
        }
        let fileURL = directory.appendingPathComponent(name).appendingPathExtension("jpg")
        try data.write(to: fileURL)
        return fileURL.path
    }

    func loadImage(path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }

    func deleteImage(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
}
