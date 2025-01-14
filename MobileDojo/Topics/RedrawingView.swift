//
//  RedrawingView.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 8/1/2025.
//

import SwiftUI

// MARK: - Self._printChanges()
//
// - PURPOSE: Used for debugging SwiftUI views by printing state changes in the console.
// - VISIBILITY: Helps developers understand how and when views update as state changes occur.
// - USAGE: Can be called within the body of a SwiftUI view to log state changes during rendering.
// - PERFORMANCE: Might impact performance if used frequently due to logging overhead.
// - CAUTION: It is a private API and should not be relied upon in production code, as it may change or be removed in future SwiftUI versions.

class RedrawingViewModel: ObservableObject {
  @Published var isEnabled = true
}

struct RedrawingView: View {
  @StateObject private var viewModel: RedrawingViewModel = .init()
  @State private var date = Date()

  var body: some View {
    VStack {
      let _ = Self._printChanges()
      Text("Is Enabled: " + (viewModel.isEnabled ? "👍" : "👎"))
        .font(.largeTitle)
        .onTapGesture { withAnimation { viewModel.isEnabled.toggle() } }

//      SomeSubView(settings: viewModel)
//      SomeSubView2()

      Text(date, format: .dateTime.hour().minute().second())
        .font(.largeTitle)
//        .monospaced()
//        .contentTransition(.numericText())
    }
    .task {
      while true {
        try? await Task.sleep(for: .seconds(1))
//        withAnimation { /// Animation is required when using the `contentTransition` modifier
          date = Date()
//        }
      }
    }
  }
}

private struct SomeSubView: View {
  @ObservedObject var settings: RedrawingViewModel

  var body: some View {
    VStack {
      let _ = Self._printChanges()
      Text("Is Enabled: " + (settings.isEnabled ? "👍" : "👎"))
        .font(.largeTitle)
        .onTapGesture { withAnimation { settings.isEnabled.toggle() } }
    }
  }
}

private struct SomeSubView2: View {
  @StateObject var settings: RedrawingViewModel = .init()

  var body: some View {
    VStack {
      let _ = Self._printChanges()
      Text("Is Enabled: " + (settings.isEnabled ? "👍" : "👎"))
        .font(.largeTitle)
        .onTapGesture { withAnimation { settings.isEnabled.toggle() } }
    }
  }
}


// MARK: - MONOSPACED MODIFIER
// - PURPOSE: Applies a monospaced font design.
// - CHARACTER WIDTH: Ensures each character (letters, numbers, symbols) occupies the same width.
// - USE CASE: Especially useful for aligned text, such as tables or numerical data.
// - VISUAL CLARITY: Enhances readability and maintains uniform spacing, which is key for clear presentation.

// MARK: - CONTENTTRANSITION MODIFIER
// - PURPOSE: Animates changes to numeric text updates instead of sudden changes.
// - USE CASE: Ideal for updating counters, scores, or financial data where a smooth transition is desirable.
// - VISUAL APPEAL: Provides a dynamic and engaging experience, improving the app's overall flow.
// - IMPACT: A minor detail that enhances user interaction and visual consistency within the app.
