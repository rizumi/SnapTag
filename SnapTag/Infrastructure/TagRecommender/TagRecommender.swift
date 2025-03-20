import UIKit

/// @mockable
protocol TagRecommender: Sendable {
    func recommendTags(from image: UIImage) async throws -> [String]
}
