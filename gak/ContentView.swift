//
//  ContentView.swift
//  gak
//
//  Created by Beers,Theo on 5/31/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
  @State private var input = ""
  @State private var character: Character? = nil
  @State private var unicodeName: String = ""
  @State private var errorMessage: String?
  @FocusState private var isInputFocused: Bool

  var displayCharacter: Character? {
    guard let character,
      let scalar = character.unicodeScalars.first,
      isPrintable(scalar)
    else {
      return "�"
    }
    return character
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Enter a Unicode code point (e.g., 063A or U+063A):")
        .frame(maxWidth: .infinity, alignment: .leading)

      TextField("Code point", text: $input)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .focused($isInputFocused)
        .onSubmit { processInput() }
        .frame(width: 150, alignment: .leading)

      if let character {
        Text(String(displayCharacter ?? "�"))
          .font(.custom("NotoSans-Regular", size: 64))
          .frame(maxWidth: .infinity, alignment: .center)
          .padding(.vertical, 20)

        Text("Character name: \(unicodeName)")

        Button("Copy to Clipboard") {
          NSPasteboard.general.clearContents()
          NSPasteboard.general.setString(String(character), forType: .string)
        }
      } else if let errorMessage {
        Text("Error: \(errorMessage)")
          .foregroundColor(.red)
      }

      Spacer()
    }
    .font(.system(size: 16))
    .padding()
    .frame(width: 500)
  }

  func processInput() {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    let hex = trimmed.replacingOccurrences(of: "U+", with: "")
    input = hex

    guard let scalarValue = UInt32(hex, radix: 16),
      let scalar = UnicodeScalar(scalarValue)
    else {
      character = nil
      unicodeName = ""
      errorMessage = "Invalid code point"
      return
    }

    character = Character(scalar)
    unicodeName = scalar.properties.name ?? "(no name found)"
    errorMessage = nil
    isInputFocused = false
  }

  func isPrintable(_ scalar: Unicode.Scalar) -> Bool {
    switch scalar.properties.generalCategory {
    case .closePunctuation,
      .connectorPunctuation,
      .currencySymbol,
      .dashPunctuation,
      .decimalNumber,
      .finalPunctuation,
      .initialPunctuation,
      .letterNumber,
      .lowercaseLetter,
      .mathSymbol,
      .modifierLetter,
      .modifierSymbol,
      .openPunctuation,
      .otherLetter,
      .otherNumber,
      .otherPunctuation,
      .otherSymbol,
      .titlecaseLetter,
      .uppercaseLetter:
      return true
    default:
      return false
    }
  }
}
