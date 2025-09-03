//
//  ContentView.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/8/27.
//
import SwiftUI

struct FocusAppContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("选择 App 限制", destination: AppSelectionView())
                    .padding()
            }
            .navigationTitle("防沉迷首页")
        }
    }
}


class Property {
    deinit {
        print("Property-deint")
    }
}

class Test {
    let property = Property()
    
    deinit {
        print("Test-deinit")
    }
}
