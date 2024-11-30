///
/// @Generated by Mockolo
///



import SwiftData
import SwiftUI
import UIKit
@testable import SnapTag


final class TagRepositoryProtocolMock: TagRepositoryProtocol {
    init() { }


    private(set) var fetchCallCount = 0
    var fetchHandler: (() -> ([Tag]))?
    func fetch() -> [Tag] {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler()
        }
        return [Tag]()
    }
}

final class SnapDetailViewFlowMock: SnapDetailViewFlow {
    init() { }


}

final class SnapRepositoryProtocolMock: SnapRepositoryProtocol {
    init() { }


    private(set) var fetchCallCount = 0
    var fetchHandler: (() -> ([Snap]))?
    func fetch() -> [Snap] {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler()
        }
        return [Snap]()
    }

    private(set) var loadCallCount = 0
    var loadHandler: ((String) -> (UIImage?))?
    func load(name: String) -> UIImage? {
        loadCallCount += 1
        if let loadHandler = loadHandler {
            return loadHandler(name)
        }
        return nil
    }

    private(set) var saveCallCount = 0
    var saveHandler: ((UIImage, [String]) throws -> ())?
    func save(_ image: UIImage, tagNames: [String]) throws  {
        saveCallCount += 1
        if let saveHandler = saveHandler {
            try saveHandler(image, tagNames)
        }
        
    }

    private(set) var deleteCallCount = 0
    var deleteHandler: ((Snap) throws -> ())?
    func delete(_ snap: Snap) throws  {
        deleteCallCount += 1
        if let deleteHandler = deleteHandler {
            try deleteHandler(snap)
        }
        
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
    var toSnapDetailHandler: ((Snap, [Snap]) -> ())?
    func toSnapDetail(snap: Snap, snaps: [Snap])  {
        toSnapDetailCallCount += 1
        if let toSnapDetailHandler = toSnapDetailHandler {
            toSnapDetailHandler(snap, snaps)
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

