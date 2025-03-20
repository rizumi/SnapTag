extension TagModel {
    func toTag() -> Tag {
        return .init(id: id, name: name)
    }
}

extension SnapModel {
    func toSnap() -> Snap {
        return .init(id: id, imageName: imageName, tags: tags.map { $0.toTag() })
    }
}
