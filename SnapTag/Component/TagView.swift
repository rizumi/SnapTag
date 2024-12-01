//
//  TagView.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import SwiftUI

struct TagView: View {
    var name: String

    var body: some View {
        Text(name)
            .lineLimit(1)
            .padding(8)
            .background(Color.gray)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
    }
}

#Preview {
    TagView(name: "TagName")
}
