//
//  SetupView.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import SwiftUI

struct SetupView: View {
    @StateObject private var viewModel: SetupViewModel

    init(viewModel: SetupViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        EmptyView()
            .task {
                await viewModel.setupPresetSnaps()
            }
            .errorAlert(
                error: viewModel.errorState,
                onDismiss: {
                    viewModel.onDismissErrorAlert()
                })
    }
}
