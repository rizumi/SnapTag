#if DEBUG

import UIKit

final class PreviewTagRepository: TagRepositoryProtocol {
    func fetch() throws -> [Tag] {
        return [.init(id: "a", name: "TagA"), .init(id: "b", name: "TagB")]
    }
}

#endif
