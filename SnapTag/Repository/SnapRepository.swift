//
//  SnapRepository.swift
//  SnapTag
//
//  Created by izumi on 2024/11/21.
//

import SwiftData

final class SnapRepository {
    private var context: ModelContext {
        AppModelContainer.shared.modelContext
    }

    init() {
    }

    func fetch() -> [SnapTest] {
        return (try? context.fetch(FetchDescriptor<SnapTest>())) ?? []
    }

    func add(_ test: SnapTest) {
        context.insert(test)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
