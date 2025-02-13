import SwiftUI

struct SizeReaderModifier: ViewModifier {
  @Binding var size: CGSize
  func body(content: Content) -> some View {
    content
      .overlay(GeometryReader { geometry in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometry.size)
      })
      .onPreferenceChange(SizePreferenceKey.self) { size in
        print(size)
        self.size = size
      }
  }

  private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
      value = nextValue()
    }
  }
}

extension View {
  func readSize(into size: Binding<CGSize>) -> some View {
    modifier(SizeReaderModifier(size: size))
  }
}
