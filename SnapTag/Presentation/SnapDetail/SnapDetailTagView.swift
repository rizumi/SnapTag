//
//  SnapDetailTagView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/30.
//

import SwiftUI

struct SnapDetailTagView: View {
    @ObservedObject var viewModel: SnapDetailViewModel

    var body: some View {
        VStack {
            Spacer()

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading,
                spacing: 8
            ) {
                ForEach(viewModel.tags, id: \.self) { tag in
                    TagView(name: tag)
                }
            }
            .padding()
        }
    }
}
