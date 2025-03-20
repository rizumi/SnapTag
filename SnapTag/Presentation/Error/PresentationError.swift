import Foundation

enum PresentationError: LocalizedError {
    case loadFailed
    case saveFailed
    case deleteFailed
    case imageNotSelected
    case tagRecommendFailed
    case tagLengthLimit
    case setupFailed

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
        case .setupFailed:
            String(
                localized: "setup_failed",
                defaultValue: "Failed load preset images")
        }
    }

    var recoverySuggestion: String? {
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
        case .setupFailed:
            String(
                localized: "setup_failed_message",
                defaultValue:
                    "The demo preset images could not be loaded, but you can continue using the app without any issues."
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
        recoverySuggestion
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
