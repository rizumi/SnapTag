import Combine
import Foundation

@MainActor
final class SnapDetailViewModel: ObservableObject {

    @Published private(set) var snaps: [Snap] = []
    @Published private(set) var tags: [String] = []
    @Published private(set) var showUI: Bool = true
    @Published private(set) var presentedDeleteConfirmDialog: Bool = false
    @Published private(set) var errorState: PresentationError?

    var currentIndexPath: IndexPath {
        .init(item: currentIndex, section: 0)
    }

    private var currentIndex: Int
    private let flow: SnapDetailViewFlow
    private let repository: SnapRepositoryProtocol

    init(
        snap: Snap,
        snaps: [Snap],
        repository: SnapRepositoryProtocol,
        flow: SnapDetailViewFlow
    ) {
        self.snaps = snaps
        self.currentIndex = snaps.firstIndex(of: snap) ?? 0
        self.repository = repository
        self.flow = flow
        tags = snap.tags.map { $0.name }
    }

    func onChangeSnap(_ index: Int) {
        currentIndex = min(max(index, 0), snaps.count - 1)
        tags = snaps[currentIndex].tags.map { $0.name }
    }

    func onTapView() {
        showUI.toggle()
    }

    func onTapDelete() {
        presentedDeleteConfirmDialog = true
    }

    func deleteSnap() async {
        do {
            let snap = snaps[currentIndex]
            try await repository.delete(snap)
            snaps.remove(at: currentIndex)
            flow.onDelete(snap)

            if snaps.isEmpty {
                flow.dismiss()
            } else {
                onChangeSnap(currentIndex)
            }
        } catch let error as RepositoryError {
            errorState = error.toPresentationError()
        } catch {
            errorState = .deleteFailed
        }
    }

    func onDismissErrorAlert() {
        errorState = nil
    }
}
