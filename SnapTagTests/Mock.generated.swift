///
/// @Generated by Mockolo
///



import Foundation
import SwiftData
import SwiftUI
import UIKit
@testable import SnapTag


final class TagRecommenderMock: TagRecommender {
    init() { }


    private(set) var recommendTagsCallCount = 0
    var recommendTagsHandler: ((UIImage) async throws -> ([String]))?
    func recommendTags(from image: UIImage) async throws -> [String] {
        recommendTagsCallCount += 1
        if let recommendTagsHandler = recommendTagsHandler {
            return try await recommendTagsHandler(image)
        }
        return [String]()
    }
}

final class SnapDetailViewFlowMock: SnapDetailViewFlow {
    init() { }


    private(set) var dismissCallCount = 0
    var dismissHandler: (() -> ())?
    func dismiss()  {
        dismissCallCount += 1
        if let dismissHandler = dismissHandler {
            dismissHandler()
        }
        
    }

    private(set) var onDeleteCallCount = 0
    var onDeleteHandler: ((Snap) -> ())?
    func onDelete(_ snap: Snap)  {
        onDeleteCallCount += 1
        if let onDeleteHandler = onDeleteHandler {
            onDeleteHandler(snap)
        }
        
    }
}

final class SnapRepositoryProtocolMock: SnapRepositoryProtocol, @unchecked Sendable {
    init() { }


    private(set) var fetchCallCount = 0
    var fetchHandler: (() async throws -> ([Snap]))?
    func fetch() async throws -> [Snap] {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return try await fetchHandler()
        }
        return [Snap]()
    }

    private(set) var loadCallCount = 0
    var loadHandler: ((String) -> (UIImage?))?
    func loadImage(name: String) -> UIImage? {
        loadCallCount += 1
        if let loadHandler = loadHandler {
            return loadHandler(name)
        }
        return nil
    }

    private(set) var saveCallCount = 0
    var saveHandler: ((UIImage, [String]) async throws -> ())?
    func save(_ image: UIImage, tagNames: [String]) async throws  {
        saveCallCount += 1
        if let saveHandler = saveHandler {
            try await saveHandler(image, tagNames)
        }
        
    }

    private(set) var deleteCallCount = 0
    var deleteHandler: ((Snap) async throws -> ())?
    func delete(_ snap: Snap) async throws  {
        deleteCallCount += 1
        if let deleteHandler = deleteHandler {
            try await deleteHandler(snap)
        }
        
    }
}

final class TagRepositoryProtocolMock: TagRepositoryProtocol {
    init() { }


    private(set) var fetchCallCount = 0
    var fetchHandler: (() throws -> ([Tag]))?
    func fetch() throws -> [Tag] {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return try fetchHandler()
        }
        return [Tag]()
    }
}

final class SnapListViewFlowMock: SnapListViewFlow {
    init() { }


    private(set) var toSnapPickerCallCount = 0
    var toSnapPickerHandler: ((@escaping () -> Void) -> ())?
    func toSnapPicker(_ completion: @escaping () -> Void)  {
        toSnapPickerCallCount += 1
        if let toSnapPickerHandler = toSnapPickerHandler {
            toSnapPickerHandler(completion)
        }
        
    }

    private(set) var toSnapDetailCallCount = 0
    var toSnapDetailHandler: ((Snap, [Snap], @escaping (Snap) -> Void) -> ())?
    func toSnapDetail(snap: Snap, snaps: [Snap], onDelete: @escaping (Snap) -> Void)  {
        toSnapDetailCallCount += 1
        if let toSnapDetailHandler = toSnapDetailHandler {
            toSnapDetailHandler(snap, snaps, onDelete)
        }
        
    }
}

final class SnapUploadViewFlowMock: SnapUploadViewFlow {
    init() { }


    private(set) var dismissCallCount = 0
    var dismissHandler: ((Bool) -> ())?
    func dismiss(isCompleted: Bool)  {
        dismissCallCount += 1
        if let dismissHandler = dismissHandler {
            dismissHandler(isCompleted)
        }
        
    }
}

