import Foundation
import SwiftData

@Model
final class SnapModel {
    @Attribute(.unique) private(set) var id: String = UUID().uuidString
    private(set) var imageName: String

    // iOS17ではRelationshipをoptionalにしないとinsert時にcrashするためoptionalにしている
    // 参考: https://forums.developer.apple.com/forums/thread/738961
    @Relationship(inverse: \TagModel.snaps)
    private(set) var tags: [TagModel]!

    private(set) var createdAt: Date = Date()

    init(imageName: String, tags: [TagModel]) {
        self.imageName = imageName
        self.tags = tags
    }
}
