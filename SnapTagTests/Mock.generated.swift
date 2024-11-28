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
    var saveHandler: ((UIImage, [String]) -> ())?
    func save(_ image: UIImage, tagNames: [String])  {
        saveCallCount += 1
        if let saveHandler = saveHandler {
            saveHandler(image, tagNames)
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
}

