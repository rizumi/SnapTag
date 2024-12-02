//
//  CoreMLTagRecommender.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import CoreML
import UIKit
import Vision

enum CoreMLTagRecommenderError: Error {
    case modelLoadError
    case imageConversionError
    case classificationFailed
}

final class CoreMLTagRecommender: TagRecommender {

    func recommendTags(from image: UIImage) async throws -> [String] {
        guard
            let model = try? VNCoreMLModel(
                for: MobileNetV2FP16(configuration: .init()).model)
        else {
            throw CoreMLTagRecommenderError.modelLoadError
        }

        guard let ciImage = CIImage(image: image) else {
            throw CoreMLTagRecommenderError.imageConversionError
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation] {
                    let topResults = results.prefix(3)
                        // .filter { $0.confidence >= 0.3 }
                        .map { $0.identifier }
                    // カンマ区切りで類似単語が入っているので先頭だけ取得する
                    let result = topResults.compactMap {
                        $0.split(separator: ",").first
                    }.map { String($0).trimmingCharacters(in: .whitespaces) }

                    continuation.resume(returning: result)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: [])
                }
            }

            do {
                try VNImageRequestHandler(ciImage: ciImage).perform([request])
            } catch {
                continuation.resume(throwing: CoreMLTagRecommenderError.classificationFailed)
            }
        }
    }
}
