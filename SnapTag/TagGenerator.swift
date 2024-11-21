//
//  TagGenerator.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import CoreML
import UIKit
import Vision

final class TagGenerator {
    func classifyImage(
        _ image: UIImage, completion: @escaping ([String]) -> Void
    ) {
        // MobileNetV2 モデルをロード
        guard
            let model = try? VNCoreMLModel(
                for: MobileNetV2FP16(configuration: .init()).model)
        else {
            print("Failed to load Core ML model")
            completion([])
            return
        }

        // Visionリクエストを作成
        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation] {
                // 上位3つの結果を取得
                let topResults = results.prefix(3).map {
                    "\($0.identifier): \($0.confidence * 100)%"
                }
                completion(topResults)
            } else {
                completion([])
            }
        }

        // UIImageをCIImageに変換
        guard let ciImage = CIImage(image: image) else {
            print("Failed to convert UIImage to CIImage")
            completion([])
            return
        }

        // Visionリクエストを実行
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification: \(error)")
                completion([])
            }
        }
    }

}
