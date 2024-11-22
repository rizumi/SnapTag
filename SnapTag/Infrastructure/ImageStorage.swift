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
        try data.write(to: fileURL(from: name))
        return name
    }

    func loadImage(name: String) -> UIImage? {
        return UIImage(contentsOfFile: fileURL(from: name).path)
    }

    func deleteImage(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }

    private func fileURL(from name: String) -> URL {
        return directory.appendingPathComponent(name).appendingPathExtension("jpg")
    }
}
