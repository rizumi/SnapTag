import SwiftData
import UIKit

/// @mockable
protocol SnapRepositoryProtocol: Sendable {
    func fetch() async throws -> [Snap]
    func save(_ image: UIImage, tagNames: [String]) async throws
    func delete(_ snap: Snap) async throws
}

enum SnapRepositoryError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
}

final class SnapRepository: SnapRepositoryProtocol {
    private let modelContainer: ModelContainer
    private let imageStorage: ImageStorage
    private let cache: ImageCache

    init(
        modelContainer: ModelContainer,
        imageStorage: ImageStorage,
        cache: ImageCache = ImageCache.shared
    ) {
        self.modelContainer = modelContainer
        self.imageStorage = imageStorage
        self.cache = cache
    }

    func fetch() async throws -> [Snap] {
        do {
            // 今は一度にまとめてfetchしているが、プロダクトとして運用する場合にはページングに対応した方が良い
            let sort = SortDescriptor(\SnapModel.createdAt, order: .reverse)
            let context = ModelContext(modelContainer)
            let models = try context.fetch(FetchDescriptor<SnapModel>(sortBy: [sort]))
            return models.map { $0.toSnap() }
        } catch {
            throw SnapRepositoryError.fetchFailed
        }
    }

    func save(_ image: UIImage, tagNames: [String]) async throws {
        do {
            // 画像名はユニークであれば良いのでUUIDを用いる
            let imageName = try imageStorage.save(image: image, with: UUID().uuidString)
            let context = ModelContext(modelContainer)
            let tagModels: [TagModel] = try tagNames.compactMap { name in
                let tag = try context.fetch(
                    FetchDescriptor<TagModel>(
                        predicate: #Predicate {
                            $0.name == name
                        }
                    )
                )

                // 同名のタグが既にある場合はそれを使い、ない場合に新規生成を行う。
                if let tag = tag.first {
                    return tag
                } else {
                    let tag = TagModel(name: name)
                    return tag
                }
            }

            context.insert(SnapModel(imageName: imageName, tags: tagModels))
            try context.save()
        } catch {
            throw SnapRepositoryError.saveFailed
        }
    }

    func delete(_ snap: Snap) async throws {
        do {
            let snapId = snap.id
            let context = ModelContext(modelContainer)
            try context.delete(
                model: SnapModel.self,
                where: #Predicate<SnapModel> {
                    $0.id == snapId
                })
            try imageStorage.deleteImage(name: snap.imageName)
            cache.removeImage(forKey: snap.imageName)
        } catch {
            throw SnapRepositoryError.deleteFailed
        }
    }
}
