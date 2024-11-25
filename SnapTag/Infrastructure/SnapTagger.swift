//
//  SnapTagger.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import CoreML
import UIKit
import Vision

final class SnapTagger {
    enum SnapTaggerError: Error {
        case modelLoadError
        case imageConversionError
        case classificationFailed
    }

    func generateTags(from image: UIImage) async throws -> [String] {
        guard
            let model = try? VNCoreMLModel(
                for: MobileNetV2FP16(configuration: .init()).model)
        else {
            throw SnapTaggerError.modelLoadError
        }

        guard let ciImage = CIImage(image: image) else {
            throw SnapTaggerError.imageConversionError
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation] {
                    let topResults = results.prefix(3).map {
                        print("\($0.identifier): \($0.confidence * 100)%")
                        return $0.identifier
                    }
                    // カンマ区切りを別々にする
                    let result = topResults.flatMap {
                        $0.split(separator: ",")
                    }.map { String($0) }

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
                continuation.resume(throwing: SnapTaggerError.classificationFailed)
            }
        }
    }
}
