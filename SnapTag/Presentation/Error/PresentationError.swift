//
//  PresentationError.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

import Foundation

enum PresentationError: LocalizedError {
    case loadfailed
    case saveFailed
    case deleteFailed
    case imageNotSelected
    case tagRecommendFailed

    var errorDescription: String? {
        switch self {
        case .loadfailed:
            String(localized: "Failed to load")
        case .saveFailed, .imageNotSelected:
            String(localized: "Failed to save")
        case .deleteFailed:
            String(localized: "Failed to delete")
        case .tagRecommendFailed:
            String(localized: "Failed to recommend tags")
        }
    }

    var failureReason: String? {
        switch self {
        case .loadfailed, .saveFailed, .deleteFailed:
            String(localized: "Please try again.")
        case .imageNotSelected:
            String(localized: "Please select photo.")
        case .tagRecommendFailed:
            nil
        }
    }
}
