//
//  TopicsView.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 25/6/2024.
//

import SwiftUI

struct TopicsView: View {
  @State var columnVisibility: NavigationSplitViewVisibility = .all
  @State var selection: TopicMenuItem?

  var body: some View {
    NavigationSplitView(
      columnVisibility: $columnVisibility) {
        List(
          TopicMenuItem.allCases,
          id: \.self,
          selection: $selection
        ) { item in
          HStack {
            Text(item.rawValue)
            Spacer()
            Image(systemName: "chevron.right")
          }
        }
        .navigationTitle("Topics")
        .navigationBarTitleDisplayMode(.large)
      } detail: {
        Group {
          switch selection {
          case .subscripts:
            SubscriptsDojo()
          case .formatterBasic:
            FormatterView()
          case .none:
            EmptyView()
          }
        }
        .navigationTitle(selection?.rawValue ?? "")
      }
  }
}

enum TopicMenuItem: String, CaseIterable {
  case subscripts = "Subscripts"
  case formatterBasic = "Formatter - Part 1"
}

#Preview {
  TopicsView()
}
