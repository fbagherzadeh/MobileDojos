//
//  FormatterBasicView.swift
//  MobileDojo
//
//  Created by Farhad Bagherzadeh on 25/6/2024.
//

import SwiftUI

struct FormatterBasicView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Text("Old-Style Formatters")
          .font(.title2)
          .padding(.top)

        Text("Old-style formatters have been a part of Foundation for a long time. These include `DateFormatter`, `NumberFormatter`, and `DateComponentsFormatter`. They are powerful but can have several downsides:")
          .padding(.horizontal)

        VStack(alignment: .leading, spacing: 15) {
          Text("• Formatter initialisation is a resource-heavy task")
          Text("◦ We should cache formatter instances as much as we can and avoid the creation of a formatter instance per item in our collection.")
            .padding(.leading, 15)
            .font(.caption)


          Text("• It is an error-prone class-based API we inherited from the Objective-C era.")
          Text("◦ We can accidentally override the configuration of the formatter instance, and it will affect all the places where we are using it. It is a classical reference type-related issue.")
            .padding(.leading, 15)
            .font(.caption)

          Text("• Not Swift-friendly.")
          Text("◦ As the API was designed long before Swift was introduced, it may not take advantage of all Swift's modern features.")
            .padding(.leading, 15)
            .font(.caption)
        }
        .padding(.horizontal)

        Text("Example of Old-Style DateFormatter")
          .font(.headline)
          .padding(.top)
        formatterExampleView(oldStyleFormattedDate)

        divider

        Text("New Swift Foundation Formatter API")
          .font(.title2)
          .padding(.top)

        Text("The new Swift Foundation Formatter API aims to simplify and streamline formatting tasks. It provides a more Swift-friendly, concise, and safe way to format data.")
          .padding(.horizontal)

        VStack(alignment: .leading, spacing: 15) {
          Text("• New `formatted` function")
          Text("◦ Many types in Swift Foundation provide the new formatted function allowing us to format the instance in place. We don’t need to initialise any formatter instance or cache them because the Foundation automatically handles it.")
            .padding(.leading, 15)
            .font(.caption)
        }
        .padding(.horizontal)

        Text("Examples of New Swift Formatter API")
          .font(.headline)
          .padding(.top)
        Text("• Date")
        formatterExampleView(newStyleFormattedDate)
        formatterExampleView(Date.now.addingTimeInterval(-604800).formatted(.relative(presentation: .numeric)))
        formatterExampleView(Date.now.formatted(date: .abbreviated, time: .omitted))
        formatterExampleView(Date.now.formatted(.dateTime.day(.twoDigits).month(.abbreviated).year(.twoDigits)))
        formatterExampleView(Date.now.formatted(.iso8601))

        Text("• Numbers")
        formatterExampleView(1_000_000_000.formatted())
        formatterExampleView(1.001.formatted(.number.precision(.fractionLength(1))))
        formatterExampleView(0.1.formatted(.percent))
        formatterExampleView(0.99.formatted(.currency(code: "USD")))

        Text("• Unit")
        formatterExampleView(
          Measurement<UnitMass>(value: 3.5, unit: .kilograms)
            .formatted(
              .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .init(locale: .init(identifier: "en_AU"))
              )
            )
//            .formatted(.measurement(width: .abbreviated))
        )

        Text("• Array")
        formatterExampleView(["iOS", "Android", "Foo"].formatted(.list(type: .or)))
        formatterExampleView(["iOS", "Android", "Foo"].formatted(RelationshipStatus.love))
      }
    }
    .padding()
  }
}

private extension FormatterBasicView {
  var oldStyleFormattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: Date.now)
  }

  var newStyleFormattedDate: String {
    Date.now.formatted(
      .dateTime
        .year(.defaultDigits)
        .month(.abbreviated)
        .day(.twoDigits)
        .hour(.twoDigits(amPM: .wide))
        .minute(.twoDigits)
    )
  }

  func formatterExampleView(_ text: String) -> some View {
    Text(text)
      .padding()
      .background(Color.gray.opacity(0.1))
      .cornerRadius(10)
      .padding(.horizontal)
  }

  var divider: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundColor(.gray)
  }
}

#Preview {
  FormatterBasicView()
}

private enum RelationshipStatus: String, FormatStyle {
  case love = " ❤️ "
  case `break` = " 💔 "

  typealias FormatInput = Array<String>
  typealias FormatOutput = String

  func format(_ value: Array<String>) -> String {
    value.joined(separator: self.rawValue)
  }
}
