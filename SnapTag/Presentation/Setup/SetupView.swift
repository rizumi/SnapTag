//
//  SetupView.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import SwiftUI

struct SetupView: View {
    let viewModel: SetupViewModel

    var body: some View {
        EmptyView()
            .task {
                await viewModel.setupPresetSnaps()
            }
    }
}
