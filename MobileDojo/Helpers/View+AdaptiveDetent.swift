import Foundation
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {
  /// Set up presentationDetents so that when the view is presented in sheet, the detent's height is dynamically set based on the view's natural content height.
  ///
  /// For example:
  /// ```
  /// myView
  /// .sheet(isPresented: $isPresented) {
  ///     sheetConent()
  ///     .applyAdaptiveDetent()
  /// }
  /// ```
  func applyAdaptiveDetent() -> some View {
    modifier(AdaptiveDetent())
  }
}


@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct AdaptiveDetent: ViewModifier {
  @State private var contentSize: CGSize = .zero

  ///
  /// When sheet content length is longer than screen height, we want sheet to use scrollView propsed height, so we don't want fixedSize;
  /// When sheet content is shorter than screen height, we want sheet to use it's natural height, so fixedSize is applied to counter the proposed height by scroll view.
  /// UIScreen.main.bounds.height * 0.8 is used to simulate maximum sheet height
  ///
  /// This solution only works on iPhone. It has bugs on iPad(iOS 17 and iOS 18).
  func body(content: Content) -> some View {
    content
    //            .fixedSize(horizontal: false, vertical: true) //2.3 comment and uncomment, read documentation
    //            .fixedSize(horizontal: false, vertical: contentSize.height < UIScreen.main.bounds.height * 0.8) //3
      .verticalHugging() //4
      .readSize(into: $contentSize)
      .presentationDetents([.height(contentSize.height)]) // 2.1  comment line
  }
}

private extension View {
  func verticalHugging() -> some View {
    VerticalHugging {
      self
    }
  }
}

/// A custom layout.
///
/// Rules:
///
/// - Always take width proposed by parent view.
/// - Always take the smaller between proposed height and fitting height. (see explanation below)
///   - If parent view proposes a height which is greater than the view's ideal height that fits into the parent proposal, the current view takes the fitting height.
///   - If parent view proposes a height which is smaller or equal than the view's ideal height that fits into the parent proposal, the current view takes the proposed height.
private struct VerticalHugging: Layout {
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
    precondition(subviews.count <= 1)
    guard let subview = subviews.first else { return .zero }
    let fittingSize = subview.sizeThatFits(ProposedViewSize(width: proposal.width, height: nil))
    if let proposalHeight = proposal.height,
       let proposalWidth = proposal.width,
       proposalWidth != 0,
       proposalHeight != 0 {
      return CGSize(width: proposalWidth, height: min(fittingSize.height, proposalHeight))
    } else {
      return fittingSize
    }
  }

  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
    precondition(subviews.count <= 1)
    guard let subview = subviews.first else { return }
    subview.place(at: CGPoint(x: bounds.minX, y: bounds.minY), proposal: proposal)
  }
}

