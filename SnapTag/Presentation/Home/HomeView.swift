//
//  HomeView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    let coordinator: HomeViewFlow
    @State var tests: [SnapTest] = []

    var body: some View {
        ZStack {
            Text("Hello, World!")
            List(tests) { test in
                Text(test.name)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button {
                        coordinator.toUploadSnapView()
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
        .onAppear {
            let repo = SnapRepository()
            tests = repo.fetch()
        }
    }
}

#Preview {
    HomeView(coordinator: HomeViewCoordinator(window: .init()))
}
