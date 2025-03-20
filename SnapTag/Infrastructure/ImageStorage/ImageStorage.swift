import Foundation
import UIKit

protocol ImageStorage: Sendable {
    func save(image: UIImage, with name: String) throws -> String
    func loadImage(name: String) -> UIImage?
    func deleteImage(name: String) throws
}
