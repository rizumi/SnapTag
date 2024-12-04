//
//  LocalImageStorage.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import Foundation
import UIKit

final class LocalImageStorage: ImageStorage, Sendable {
    private let directory: URL
    static let shared: LocalImageStorage = LocalImageStorage()

    private init() {
        let directoryName = "Images"
        let fileManager = FileManager.default
        self.directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(directoryName)

        if !fileManager.fileExists(atPath: directory.path) {
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }

    func save(image: UIImage, with name: String) throws -> String {
        // NOTE:
        // 今回はデータを全てLocalに画像保存する関係上ストレージ領域節約のために小さくリサイズしたデータだけ保持しています
        // 実際に運用するサービスでサーバーやクラウドストレージに保存する場合は
        // Thumbnail用の小さい画像と詳細表示用の大きい画像でそれぞれ保存しておいて使い分けると良い
        guard let resizedImage = image.resizedIfNeeded(maxSize: .init(width: 256, height: 256))
        else {
            throw NSError(
                domain: "ImageStorageError", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to resize image"])
        }

        guard let data = resizedImage.jpegData(compressionQuality: 0.5) else {
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

    func deleteImage(name: String) throws {
        try FileManager.default.removeItem(atPath: fileURL(from: name).path)
    }

    private func fileURL(from name: String) -> URL {
        return directory.appendingPathComponent(name).appendingPathExtension("jpg")
    }
}
