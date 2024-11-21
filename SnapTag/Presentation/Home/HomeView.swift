//
//  HomeView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Text("Hello, World!")

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button {
                        print("FAB tapped!")
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
}

#Preview {
    HomeView()
}
