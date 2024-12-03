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
            String(
                localized: "load_failed",
                defaultValue: "Failed to load")
        case .saveFailed, .imageNotSelected:
            String(
                localized: "save_failed",
                defaultValue: "Failed to save")
        case .deleteFailed:
            String(
                localized: "delete_failed",
                defaultValue: "Failed to delete")
        case .tagRecommendFailed:
            String(
                localized: "tag_recommend_failed",
                defaultValue: "Failed to recommend tags")
        case .tagLengthLimit:
            String(
                localized: "add_tag_failed",
                defaultValue: "Failed to add the tag")
        }
    }

    var failureReason: String? {
        switch self {
        case .loadFailed, .saveFailed, .deleteFailed:
            String(
                localized: "try_again",
                defaultValue: "Please try again.")
        case .imageNotSelected:
            String(
                localized: "image_not_selected_error_message",
                defaultValue: "Please select photo.")
        case .tagLengthLimit:
            String(
                localized: "tag_length_limit_message",
                defaultValue: "Please enter a tag within \(Constants.tagCharacterLimit) characters."
            )
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

protocol RepositoryError: Error {
    func toPresentationError() -> PresentationError
}

extension SnapRepositoryError: RepositoryError {
    func toPresentationError() -> PresentationError {
        switch self {
        case .saveFailed:
            return .saveFailed
        case .deleteFailed:
            return .deleteFailed
        case .fetchFailed:
            return .loadFailed
        }
    }
}

extension TagRepositoryError: RepositoryError {
    func toPresentationError() -> PresentationError {
        switch self {
        case .fetchFailed:
            return .loadFailed
        }
    }
}
