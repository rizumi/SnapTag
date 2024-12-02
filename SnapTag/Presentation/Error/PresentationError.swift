//
//  PresentationError.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

import Foundation

enum PresentationError: LocalizedError {
    case loadFailed
    case saveFailed
    case deleteFailed
    case imageNotSelected
    case tagRecommendFailed
    case tagLengthLimit

    var errorDescription: String? {
        switch self {
        case .loadFailed:
            String(localized: "Failed to load")
        case .saveFailed, .imageNotSelected:
            String(localized: "Failed to save")
        case .deleteFailed:
            String(localized: "Failed to delete")
        case .tagRecommendFailed:
            String(localized: "Failed to recommend tags")
        case .tagLengthLimit:
            String(localized: "Failed to add the tag")
        }
    }

    var failureReason: String? {
        switch self {
        case .loadFailed, .saveFailed, .deleteFailed:
            String(localized: "Please try again.")
        case .imageNotSelected:
            String(localized: "Please select photo.")
        case .tagLengthLimit:
            String(localized: "Please enter a tag within 10 characters.")
        case .tagRecommendFailed:
            nil
        }
    }
}

extension PresentationError {
    var title: String? {
        errorDescription
    }

    var message: String? {
        failureReason
    }
}
