//
//  CustomTextModifier.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 12/9/2024.
//

import SwiftUI

extension View {
  func customTextStyle() -> some View {
    self.modifier(CustomTextModifier())
  }
}

struct CustomTextModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(10)
      .padding(.horizontal)
  }
}

