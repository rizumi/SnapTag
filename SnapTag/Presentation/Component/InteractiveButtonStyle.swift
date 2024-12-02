//
//  InteractiveButtonStyle.swift
//  SnapTag
//
//  Created by izumi on 2024/11/23.
//

import SwiftUI

struct InteractiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let scale = configuration.isPressed ? 0.9 : 1.0
        configuration.label
            .cornerRadius(8)
            .scaleEffect(scale)
            .animation(
                .spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0),
                value: scale)
    }
}
