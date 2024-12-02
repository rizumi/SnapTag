//
//  PresentationError.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

import Foundation

enum PresentationError: LocalizedError {
    case saveFailed
    case imageNotSelected
    case tagRecommendFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed, .imageNotSelected:
            String(localized: "Failed to save")
        case .tagRecommendFailed:
            String(localized: "Failed to recommend tags")
        }
    }

    var failureReason: String? {
        switch self {
        case .saveFailed:
            String(localized: "Please try again.")
        case .imageNotSelected:
            String(localized: "Please select photo.")
        case .tagRecommendFailed:
            nil
        }
    }
}
