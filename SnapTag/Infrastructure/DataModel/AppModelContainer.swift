//
//  AppModelContainer.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import SwiftData

@MainActor
final class AppModelContainer {
    static let shared: AppModelContainer = AppModelContainer()
    private(set) var container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(for: SnapModel.self, TagModel.self)
        } catch {
            print("Failed to initialize ModelContainer: \(error)")
            fatalError()
        }
    }
}
