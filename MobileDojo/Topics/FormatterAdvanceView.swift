//
//  FormatterAdvanceView.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 12/9/2024.
//

import SwiftUI

struct FormatterAdvanceView: View {
    var body: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Text("Custom Format Styles")
            .font(.title2)
            .padding(.top)

          Text("As mentioned in part one, many Swift Foundation types offer the **`formatted`** function to format dates, numbers, and more into user-friendly styles. The formatting logic is separate from the specific type, encapsulated by various types conforming to the **`FormatStyle`** protocol.")
            .padding(.horizontal)

          exampleTitle("Example - ShortNumberFormatStyle")
          exampleText(100.001.formatted(ShortNumberFormatStyle(maxFractionLength: 1)))
//          exampleText(100.001.formatted(.short(maxFractionLength: 2)))

          exampleTitle("Example - BoldPreDecimalFormatStyle")
          exampleText(100.01.formatted(.boldPreDecimal))

          exampleTitle("Example - ProductPriceFormatStyle")
          let product = Product(title: "App", price: 0.99, oldPrice: 1.99)
          exampleText(product.formatted(.price))
        }
      }
      .padding()
    }
}

#Preview {
    FormatterAdvanceView()
}

private extension FormatterAdvanceView {
  func exampleTitle(_ string: String) -> some View {
    Text(string)
      .font(.headline)
      .padding(.top)
  }

  func exampleText(_ string: String) -> some View {
    Text(string)
      .customTextStyle()
  }

  func exampleText(_ attributedString: AttributedString) -> some View {
    Text(attributedString)
      .customTextStyle()
  }
}

// MARK: - ShortNumberFormatStyle
struct ShortNumberFormatStyle: FormatStyle {
  typealias FormatInput = Double
  typealias FormatOutput = String

  let maxFractionLength: Int

  func format(_ value: Double) -> String {
    value.formatted(.number.precision(.fractionLength(maxFractionLength)))
  }
}

/// Conditionally applying to FormatStyle only when the conforming type (Self) is specifically ShortNumberFormat.
extension FormatStyle where Self == ShortNumberFormatStyle {
  /// static func short: static function added to ShortNumberFormat through this conditional extension.
  /// short(maxFractionLength: Int = 1): ShortNumberFormat's convenience initializer
  static func short(maxFractionLength: Int = 1) -> ShortNumberFormatStyle {
    .init(maxFractionLength: maxFractionLength)
  }
}



// MARK: - BoldPreDecimalFormatStyle
struct BoldPreDecimalFormatStyle: FormatStyle {
  func format(_ value: Double) -> AttributedString {
    var string = AttributedString(value.formatted(.number))

    if let range = string.range(of: String(Int(value))) {
      string[range].inlinePresentationIntent = .stronglyEmphasized
    }

    return string
  }
}

extension FormatStyle where Self == BoldPreDecimalFormatStyle {
  static var boldPreDecimal: BoldPreDecimalFormatStyle { .init() }
}



// MARK: - ProductPriceFormatStyle
struct Product {
    let title: String
    let price: Decimal
    let oldPrice: Decimal?
}

struct ProductPriceFormatStyle: FormatStyle {
  func format(_ value: Product) -> AttributedString {
    guard let oldPrice = value.oldPrice else {
      return value.price.formatted(.number.attributed)
    }

    let priceFormatted = value.price.formatted()
    let oldPriceFormatted = oldPrice.formatted()

    var string = AttributedString("\(priceFormatted) \(oldPriceFormatted)")

    if let range = string.range(of: oldPriceFormatted) {
      string[range].inlinePresentationIntent = .strikethrough
    }

    return string
  }
}

extension FormatStyle where Self == ProductPriceFormatStyle {
  static var price: ProductPriceFormatStyle { .init() }
}

extension Product {
  /// Defining a generic method named `formatted`
  /// `<Style: FormatStyle>` specifies that the function is generic over a type parameter `Style`, and `Style` must conform to the `FormatStyle` protocol.
  func formatted<Style: FormatStyle>(
    _ style: Style
    /// returns an output of type `Style.FormatOutput`
    /// `where Style.FormatInput == Self`, this constraint specifies that the `Style`'s `FormatInput` type must be the same as the type to which the extension is being applied, which is `Product`.
  ) -> Style.FormatOutput where Style.FormatInput == Self {
    style.format(self)
  }
}
