//
//  TagView.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import SwiftUI

struct TagView: View {
    var name: String
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(name)
                .lineLimit(1)

            if onDelete != nil {
                Button {
                    onDelete?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(8)
        .background(Color.gray)
        .foregroundStyle(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    TagView(name: "TagName")
}
