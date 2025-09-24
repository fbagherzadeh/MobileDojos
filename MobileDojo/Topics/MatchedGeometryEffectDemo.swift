//
//  MatchedGeometryEffectDemo.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 11/8/2025.
//

import SwiftUI

// MARK: - matchedGeometryEffect
/// - PURPOSE: to build smooth transitions
/// - USAGE: 2 ways to use this modifier:
///     - Transition between views - mostly well known, matching the geometry of 2 views, connecting them so that `when one view is removed and another is added`, it looks like the same view is transitioning smoothly from one place to another.
///         - Just have to make sure we have matching IDs in the same namespace
///
///     - Synchronising geometry between views - less known, allow us to match the geometry of a non-source view to a source view `while both remain present in the view hierarchy at the same time`. Can be used for things like indicating selection with a smooth transition from one selected view to another as the source changes.
///
/// Learn more:
///   - [Two Practical Ways to Use matchedGeometryEffect() in SwiftUI](https://www.youtube.com/watch?v=i87zOQubYoI)
///   - [MatchedGeometryEffect in SwiftUI](https://www.youtube.com/watch?v=xGNR7tvDE0Q)
///
/// Other notes:
///   - GroupBox with a title! https://developer.apple.com/documentation/swiftui/groupbox/init(_:content:)
///   - Namespace type and injection

struct MatchedGeometryEffectDemo: View {
  @State private var dishesToPrepare = ["starter", "salad", "main", "dessert"]
  @State private var readyDishes: [String] = []
  @State private var selectedDish: String?

  @Namespace private var animation

  var body: some View {
    VStack(spacing: 80) {
      GroupBox("To prepare") {
        HStack {
          ForEach(dishesToPrepare, id: \.self) { dish in
            DishImage(dish: dish)
              .onTapGesture(count: 2) {
                // TODO: 1. add animation
                withAnimation {
                  dishesToPrepare.removeAll  { $0 == dish}
                  readyDishes.insert(dish, at: .zero)
                }
              }
              // TODO: 2. add matchedGeometryEffect
              .matchedGeometryEffect(id: dish, in: animation)
          }
        }
      }

      GroupBox("Ready") {
        HStack {
          ForEach(readyDishes, id: \.self) { dish in
            DishImage(dish: dish)
              .onTapGesture {
                // TODO: 3. add withAnimation
                withAnimation {
                  selectedDish = dish
                }
              }
            // TODO: 2. add matchedGeometryEffect
              .matchedGeometryEffect(id: dish, in: animation)
            // TODO: 4. add overlay in parent view
//              .overlay {
//                if let selectedDish, selectedDish == dish {
//                  Circle()
//                    .stroke(.blue, lineWidth: 6)
//                }
//              }
          }
        }
        .overlay {
          Rectangle()
            .stroke(.red, lineWidth: 6)

          if let selectedDish {
            Circle()
              .stroke(.blue, lineWidth: 6)
              /// Second use case - Notice the overlay is moved to HStack, which contains all images, the id is `selectedDish`
              /// The most important consideration here is `isSource` with false value(default is true)
              /// There can only be one source view with the same ID in a given namespace, in our case, it is the image inside the HStack.
              /// Since the overlay is not the source of our geometry, it will match the source with the same ID which updates dynamically as we change the selection
              .matchedGeometryEffect(
                id: selectedDish,
                in: animation,
                isSource: false
              )
          }
        }
      }

      if let selectedDish {
        Text(getDescription(for: selectedDish))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(.horizontal, 12)
    .frame(maxHeight: .infinity, alignment: .top)
  }

  private func getDescription(for dish: String) -> String {
    switch dish {
    case "starter":
      return "Crispy croquettes filled with flavorful goodness, perfect for kickstarting the meal."
    case "salad":
      return "A vibrant mix of fresh greens, tomatoes, olives, and onion, dressed to perfection."
    case "main":
      return "Juicy, perfectly cooked steak served with deliciously seasoned potatoes on the side."
    case "dessert":
      return "Indulgent chocolate lava cake with a gooey center, paired with creamy vanilla ice cream."
    default:
      return "Dish description not available."
    }
  }
}

struct DishImage: View {
  let dish: String

  var body: some View {
    Image(dish)
      .resizable()
      .frame(width: 80, height: 80)
      .mask {
        Circle()
      }
  }
}

#Preview {
  MatchedGeometryEffectDemo()
}
