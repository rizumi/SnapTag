//
//  ModelContainer.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import SwiftData

final class AppModelContainer {
    static let shared: AppModelContainer = AppModelContainer()
    private(set) var modelContainer: ModelContainer!
    lazy var modelContext: ModelContext = {
        ModelContext(modelContainer)
    }()

    private init() {
        do {
            modelContainer = try ModelContainer(for: SnapTest.self)
        } catch {
            print("Failed to initialize ModelContainer: \(error)")
            fatalError()
        }
    }
}
