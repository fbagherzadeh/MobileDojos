//
//  RedrawingView.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 8/1/2025.
//

import SwiftUI

class RedrawingViewModel: ObservableObject {
  @Published var isEnabled = true
}

struct RedrawingView: View {
  @StateObject private var settings: RedrawingViewModel = .init()
  @State private var date = Date()

  var body: some View {
    VStack {
      let _ = Self._printChanges()
      Text("Is Enabled: " + (settings.isEnabled ? "✅" : "❎"))
        .onTapGesture { withAnimation { settings.isEnabled.toggle() } }

      Text(date, format: .dateTime.hour().minute().second())
    }
    .task {
      while true {
        try? await Task.sleep(for: .seconds(1))
        date = Date()
      }
    }
  }
}

private struct SomeSubView: View {
  @ObservedObject var settings: RedrawingViewModel

  var body: some View {
    VStack {
      let _ = Self._printChanges()
      Text("Is Enabled: " + (settings.isEnabled ? "✅" : "❎"))
        .onTapGesture { withAnimation { settings.isEnabled.toggle() } }
    }
  }
}
