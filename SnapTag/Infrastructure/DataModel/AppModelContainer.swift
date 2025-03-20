import SwiftData

@MainActor
final class AppModelContainer {
    static let shared: AppModelContainer = AppModelContainer()
    let container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(for: SnapModel.self, TagModel.self)
        } catch {
            print("Failed to initialize ModelContainer: \(error)")
            fatalError()
        }
    }
}
