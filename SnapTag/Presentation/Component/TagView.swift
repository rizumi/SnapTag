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
    var backgroundColor: Color = .gray

    var body: some View {
        HStack {
            Text("#" + name)
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
        .background(backgroundColor)
        .foregroundStyle(Color.white)
        .cornerRadius(8)
    }
}

struct AllTagView: View {
    var backgroundColor: Color = .gray

    var body: some View {
        Text("all")
            .lineLimit(1)
            .padding(8)
            .background(backgroundColor)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
    }
}

struct AddTagView: View {
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("add")
            }
            .padding(8)
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    VStack {
        TagView(name: "TagName")
        AllTagView()
        AddTagView(onTap: {})
    }
}
