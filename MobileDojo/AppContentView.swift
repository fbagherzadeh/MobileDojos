//
//  AppContentView.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 25/6/2024.
//

import SwiftUI

struct AppContentView: View {
    var body: some View {
        TabView {
            TopicsView()
                .tabItem {
                    Image(systemName: "doc.richtext")
                    Text("Dojos")
                }
            Text("PlaceHolder")
                .tabItem {
                    Image(systemName: "doc.questionmark")
                    Text("PlaceHolder")
                }
        }
        .onAppear {
            UINavigationBar
                .appearance()
                .largeTitleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
            UINavigationBar
                .appearance()
                .titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                ]
        }
    }
}

#Preview {
    AppContentView()
}
