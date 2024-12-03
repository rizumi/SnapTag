//
//  View+Extension.swift
//  SnapTag
//
//  Created by izumi on 2024/12/02.
//

import SwiftUI

extension View {
    func errorAlert(
        error: (some LocalizedError)?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            isPresented: .init(
                get: {
                    error != nil
                },
                set: { _ in
                }),
            error: error,
            actions: { _ in
                Button("ok") {
                    onDismiss()
                }
            },
            message: { error in
                Text(error.failureReason ?? "")
            }
        )
    }
}
