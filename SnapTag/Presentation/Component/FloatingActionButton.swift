//
//  FloatingActionButton.swift
//  SnapTag
//
//  Created by izumi on 2024/11/22.
//

import SwiftUI

struct FloatingActionButton: View {
    var action: (() -> Void)?

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()

                Button {
                    action?()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                        .padding()
                        .background(Circle().fill())
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}

#Preview {
    FloatingActionButton(action: nil)
}
