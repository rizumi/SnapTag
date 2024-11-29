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

            // TODO: レイアウト調整
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading,
                spacing: 8
            ) {
                ForEach(viewModel.tags, id: \.self) { tag in
                    HStack {
                        Text(tag)
                            .lineLimit(1)
                    }
                    .padding(8)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
