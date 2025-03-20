import Foundation
import SwiftData

/// @mockable
protocol TagRepositoryProtocol: Sendable {
    func fetch() async throws -> [Tag]
}

enum TagRepositoryError: Error {
    case fetchFailed
}

final class TagRepository: TagRepositoryProtocol {
    private let modelContainer: ModelContainer

    init(
        modelContainer: ModelContainer
    ) {
        self.modelContainer = modelContainer
    }

    func fetch() async throws -> [Tag] {
        do {
            let context = ModelContext(modelContainer)
            let tags = try context.fetch(FetchDescriptor<TagModel>())
            return tags.filter { $0.snaps?.isEmpty == false }.map { $0.toTag() }
        } catch {
            throw TagRepositoryError.fetchFailed
        }
    }
}
